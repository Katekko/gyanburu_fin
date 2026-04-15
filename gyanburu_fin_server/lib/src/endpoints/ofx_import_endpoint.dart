import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class OfxImportEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  static const _maxTransactionsPerImport = 5000;
  static const _importCooldown = Duration(minutes: 1);
  static const _maxFileSize = 5 * 1024 * 1024; // 5 MB

  /// In-memory per-user cooldown tracker.
  static final _lastImportAt = <String, DateTime>{};

  Future<ImportHistory> importOfx(
    Session session,
    String ofxContent,
    String fileName,
  ) async {
    final userId = _userId(session);
    final userKey = userId.toString();

    // Rate limit: one import per user per minute
    final lastImport = _lastImportAt[userKey];
    if (lastImport != null &&
        DateTime.now().difference(lastImport) < _importCooldown) {
      throw Exception(
        'Please wait at least one minute between imports.',
      );
    }

    // File size limit
    if (ofxContent.length > _maxFileSize) {
      throw ArgumentError(
        'OFX file too large. Maximum size is 5 MB.',
      );
    }

    // Validate OFX structure
    if (!ofxContent.contains('<OFX>') && !ofxContent.contains('<ofx>')) {
      throw ArgumentError('Invalid OFX file: missing <OFX> root tag');
    }

    // Parse OFX
    final parsed = _parseOfx(ofxContent);

    if (parsed.transactions.length > _maxTransactionsPerImport) {
      throw ArgumentError(
        'Too many transactions (${parsed.transactions.length}). '
        'Maximum is $_maxTransactionsPerImport per import.',
      );
    }

    // Load category rules for auto-categorization
    final rules = await CategoryRule.db.find(
      session,
      where: (r) => r.userId.equals(userId),
    );
    final ruleMap = {for (final r in rules) r.merchantPattern: r};

    // Get existing external IDs to deduplicate
    final existingTransactions = await FinancialTransaction.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) & t.externalId.notEquals(null),
    );
    final existingFitIds = {
      for (final t in existingTransactions)
        if (t.externalId != null) t.externalId,
    };

    final billingMonth =
        '${parsed.dateEnd.year.toString().padLeft(4, '0')}-'
        '${parsed.dateEnd.month.toString().padLeft(2, '0')}';

    var newCount = 0;
    var skippedDuplicates = 0;
    var skippedCredits = 0;
    for (final txn in parsed.transactions) {
      try {
        // Skip credits (bill payments)
        if (txn.type == 'CREDIT') {
          skippedCredits++;
          continue;
        }

        // Skip duplicates
        if (existingFitIds.contains(txn.fitId)) {
          skippedDuplicates++;
          continue;
        }

        // Parse merchant name and installments
        final merchantInfo = _parseMerchantName(txn.memo);

        // Auto-categorize and apply display name from rules
        var category = '';
        String? displayName;
        final rule = ruleMap[merchantInfo.cleanName];
        if (rule != null) {
          if (rule.categoryId != null) {
            final cat =
                await Category.db.findById(session, rule.categoryId!);
            if (cat != null) {
              category = cat.name;
            }
          }
          displayName = rule.displayName;
        }

        final transaction = FinancialTransaction(
          userId: userId,
          merchantName: merchantInfo.cleanName,
          category: category,
          amount: txn.amount.abs(),
          currency: parsed.currency,
          occurredAt: txn.datePosted,
          externalId: txn.fitId,
          installmentCurrent: merchantInfo.installmentCurrent,
          installmentTotal: merchantInfo.installmentTotal,
          displayName: displayName,
          billingMonth: billingMonth,
        );

        await FinancialTransaction.db.insertRow(session, transaction);
        newCount++;
      } catch (_) {
        // Skip malformed individual transactions
      }
    }

    // Log the import
    final history = ImportHistory(
      userId: userId,
      importedAt: DateTime.now(),
      fileName: fileName,
      statementStart: parsed.dateStart,
      statementEnd: parsed.dateEnd,
      totalTransactions: parsed.transactions.length,
      newTransactions: newCount,
      skippedDuplicates: skippedDuplicates,
      skippedCredits: skippedCredits,
    );

    _lastImportAt[userKey] = DateTime.now();
    return ImportHistory.db.insertRow(session, history);
  }
}

// ── OFX Parser ──────────────────────────────────────────────────────────────

class _ParsedOfx {
  final String currency;
  final DateTime dateStart;
  final DateTime dateEnd;
  final List<_ParsedTransaction> transactions;

  _ParsedOfx({
    required this.currency,
    required this.dateStart,
    required this.dateEnd,
    required this.transactions,
  });
}

class _ParsedTransaction {
  final String type;
  final DateTime datePosted;
  final double amount;
  final String fitId;
  final String memo;

  _ParsedTransaction({
    required this.type,
    required this.datePosted,
    required this.amount,
    required this.fitId,
    required this.memo,
  });
}

class _MerchantInfo {
  final String cleanName;
  final int? installmentCurrent;
  final int? installmentTotal;

  _MerchantInfo({
    required this.cleanName,
    this.installmentCurrent,
    this.installmentTotal,
  });
}

_ParsedOfx _parseOfx(String content) {
  final currency = _extractTag(content, 'CURDEF') ?? 'BRL';
  final dateStart =
      _parseOfxDate(_extractTag(content, 'DTSTART') ?? '') ?? DateTime.now();
  final dateEnd =
      _parseOfxDate(_extractTag(content, 'DTEND') ?? '') ?? DateTime.now();

  final transactions = <_ParsedTransaction>[];

  // Split by STMTTRN blocks
  final stmtTrnPattern = RegExp(r'<STMTTRN>(.*?)</STMTTRN>', dotAll: true);
  for (final match in stmtTrnPattern.allMatches(content)) {
    final block = match.group(1)!;

    final type = _extractTag(block, 'TRNTYPE') ?? 'DEBIT';
    final dateStr = _extractTag(block, 'DTPOSTED') ?? '';
    final amountStr = _extractTag(block, 'TRNAMT') ?? '0';
    final fitId = _extractTag(block, 'FITID') ?? '';
    final memo = _extractTag(block, 'MEMO') ?? '';

    final date = _parseOfxDate(dateStr) ?? DateTime.now();
    final amount = double.tryParse(amountStr) ?? 0;

    transactions.add(_ParsedTransaction(
      type: type,
      datePosted: date,
      amount: amount,
      fitId: fitId,
      memo: memo,
    ));
  }

  return _ParsedOfx(
    currency: currency,
    dateStart: dateStart,
    dateEnd: dateEnd,
    transactions: transactions,
  );
}

/// Extracts the text value of an OFX/SGML tag.
/// Handles both `<TAG>value</TAG>` and `<TAG>value\n` (SGML without closing tag).
String? _extractTag(String content, String tag) {
  // Try with closing tag first
  final closedPattern = RegExp('<$tag>([^<]*)</$tag>');
  final closedMatch = closedPattern.firstMatch(content);
  if (closedMatch != null) return closedMatch.group(1)?.trim();

  // SGML style: value ends at newline or next tag
  final openPattern = RegExp('<$tag>([^<\\n]+)');
  final openMatch = openPattern.firstMatch(content);
  return openMatch?.group(1)?.trim();
}

/// Parses OFX date format: `YYYYMMDDHHMMSS[-3:BRT]` or `YYYYMMDDHHMMSS[0:GMT]`
DateTime? _parseOfxDate(String dateStr) {
  if (dateStr.isEmpty) return null;

  // Strip timezone bracket: "20260331000000[-3:BRT]" -> "20260331000000"
  final raw = dateStr.replaceAll(RegExp(r'\[.*\]'), '');
  if (raw.length < 8) return null;

  final year = int.tryParse(raw.substring(0, 4)) ?? 0;
  final month = int.tryParse(raw.substring(4, 6)) ?? 1;
  final day = int.tryParse(raw.substring(6, 8)) ?? 1;

  return DateTime(year, month, day);
}

/// Parses merchant name, extracting installment info if present.
/// "Msc Cruzeiros - Parcela 9/12" -> cleanName: "Msc Cruzeiros", 9, 12
/// "Pichau Informatica - NuPay - Parcela 9/15" -> cleanName: "Pichau Informatica - NuPay", 9, 15
_MerchantInfo _parseMerchantName(String memo) {
  final installmentPattern = RegExp(r'\s*-\s*Parcela\s+(\d+)/(\d+)\s*$');
  final match = installmentPattern.firstMatch(memo);

  if (match != null) {
    final cleanName = memo.substring(0, match.start).trim();
    final current = int.tryParse(match.group(1)!);
    final total = int.tryParse(match.group(2)!);
    return _MerchantInfo(
      cleanName: cleanName,
      installmentCurrent: current,
      installmentTotal: total,
    );
  }

  return _MerchantInfo(cleanName: memo.trim());
}
