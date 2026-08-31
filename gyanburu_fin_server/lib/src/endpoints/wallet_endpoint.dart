import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/validation.dart';

/// Manual tracking of benefit wallets (Caju), which have no OFX export.
///
/// Each wallet stores an anchor: a balance known to be correct at
/// [BenefitWallet.anchorDate]. The current balance is that anchor plus every
/// wallet transaction that occurred strictly after it, so reconciling with
/// the real Caju app is just moving the anchor — history stays untouched.
class WalletEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const _cajuProvider = 'caju';
  static const _topupMerchant = 'Recarga Caju';

  /// The wallets every user gets lazily on first use. Refeição and
  /// Alimentação are tracked together as "comida"; Home Office alone.
  static const _defaultWallets = [
    (slug: 'comida', name: 'Caju Comida'),
    (slug: 'home-office', name: 'Caju Home Office'),
  ];

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<List<BenefitWallet>> _ensureWallets(Session session) async {
    final userId = _userId(session);
    final existing = await BenefitWallet.db.find(
      session,
      where: (w) =>
          w.userId.equals(userId) & w.provider.equals(_cajuProvider),
      orderBy: (w) => w.id,
    );
    final missing = _defaultWallets
        .where((d) => existing.every((w) => w.slug != d.slug))
        .toList();
    if (missing.isEmpty) return existing;
    final created = await BenefitWallet.db.insert(
      session,
      [
        for (final d in missing)
          BenefitWallet(
            userId: userId,
            provider: _cajuProvider,
            slug: d.slug,
            name: d.name,
            anchorBalance: 0,
            anchorDate: DateTime.utc(1970),
          ),
      ],
    );
    return [...existing, ...created];
  }

  Future<BenefitWallet> _walletBySlug(Session session, String slug) async {
    final wallets = await _ensureWallets(session);
    final wallet = wallets.where((w) => w.slug == slug).firstOrNull;
    if (wallet == null) {
      throw ArgumentError('Unknown wallet: $slug');
    }
    return wallet;
  }

  Future<double> _balance(Session session, BenefitWallet wallet) async {
    final transactions = await FinancialTransaction.db.find(
      session,
      where: (t) =>
          t.userId.equals(wallet.userId) &
          t.walletId.equals(wallet.id) &
          (t.occurredAt > wallet.anchorDate),
    );
    // Amounts are stored positive with the direction in `kind`, matching
    // the OFX import convention.
    return transactions.fold<double>(
      wallet.anchorBalance,
      (total, t) => t.kind == 'expense' ? total - t.amount : total + t.amount,
    );
  }

  Future<List<WalletSummary>> summaries(Session session, DateTime month) async {
    final wallets = await _ensureWallets(session);
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    final monthKey = '${month.year.toString().padLeft(4, '0')}-'
        '${month.month.toString().padLeft(2, '0')}';

    final result = <WalletSummary>[];
    for (final wallet in wallets) {
      final monthTransactions = await FinancialTransaction.db.find(
        session,
        where: (t) =>
            t.userId.equals(wallet.userId) &
            t.walletId.equals(wallet.id) &
            t.occurredAt.between(start, end),
      );
      double spent = 0;
      double toppedUp = 0;
      for (final t in monthTransactions) {
        if (t.kind == 'expense') {
          spent += t.amount;
        } else {
          toppedUp += t.amount;
        }
      }
      result.add(WalletSummary(
        wallet: wallet,
        balance: await _balance(session, wallet),
        month: monthKey,
        monthSpent: spent,
        monthToppedUp: toppedUp,
      ));
    }
    return result;
  }

  Future<List<FinancialTransaction>> monthTransactions(
    Session session,
    DateTime month,
  ) async {
    final wallets = await _ensureWallets(session);
    final walletIds = wallets.map((w) => w.id!).toSet();
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    return FinancialTransaction.db.find(
      session,
      where: (t) =>
          t.userId.equals(_userId(session)) &
          t.walletId.inSet(walletIds) &
          t.occurredAt.between(start, end),
      orderBy: (t) => t.occurredAt,
      orderDescending: true,
    );
  }

  Future<FinancialTransaction> spend(
    Session session,
    String walletSlug,
    double amount,
    String merchantName,
    int? categoryId,
    DateTime? occurredAt,
    String? description,
  ) async {
    Validate.requirePositiveAmount(amount, 'amount');
    Validate.requireString(merchantName, 'merchantName');
    final wallet = await _walletBySlug(session, walletSlug);

    var categoryName = '';
    String? displayName;
    if (categoryId != null) {
      final category = await Category.db.findById(session, categoryId);
      if (category == null || category.userId != wallet.userId) {
        throw ArgumentError('Category not found');
      }
      categoryName = category.name;
    } else {
      final rule = (await CategoryRule.db.find(
        session,
        where: (r) =>
            r.userId.equals(wallet.userId) &
            r.merchantPattern.equals(merchantName),
      ))
          .firstOrNull;
      if (rule?.categoryId != null) {
        final category =
            await Category.db.findById(session, rule!.categoryId!);
        categoryName = category?.name ?? '';
      }
      displayName = rule?.displayName;
    }

    return FinancialTransaction.db.insertRow(
      session,
      FinancialTransaction(
        userId: wallet.userId,
        walletId: wallet.id,
        merchantName: merchantName,
        displayName: displayName,
        category: categoryName,
        amount: amount.abs(),
        currency: 'BRL',
        occurredAt: occurredAt ?? DateTime.now(),
        description: description,
        source: 'caju',
        kind: 'expense',
      ),
    );
  }

  /// Records a top-up. When [amount] is null, falls back to the wallet's
  /// configured [BenefitWallet.monthlyTopupAmount].
  Future<FinancialTransaction> topup(
    Session session,
    String walletSlug,
    double? amount,
    DateTime? occurredAt,
    String? description,
  ) async {
    final wallet = await _walletBySlug(session, walletSlug);
    final effective = amount ?? wallet.monthlyTopupAmount;
    if (effective == null) {
      throw ArgumentError(
        'amount is required: wallet has no monthlyTopupAmount configured',
      );
    }
    Validate.requirePositiveAmount(effective, 'amount');
    return FinancialTransaction.db.insertRow(
      session,
      FinancialTransaction(
        userId: wallet.userId,
        walletId: wallet.id,
        merchantName: _topupMerchant,
        category: '',
        amount: effective.abs(),
        currency: 'BRL',
        occurredAt: occurredAt ?? DateTime.now(),
        description: description,
        source: 'caju',
        kind: 'topup',
      ),
    );
  }

  /// Reconciles the wallet with the balance shown in the Caju app.
  ///
  /// Transactions recorded with an occurredAt after [at] (default: now) keep
  /// counting toward the balance; everything before is covered by the anchor.
  Future<BenefitWallet> setBalance(
    Session session,
    String walletSlug,
    double balance,
    DateTime? at,
  ) async {
    Validate.requireFiniteAmount(balance, 'balance');
    final wallet = await _walletBySlug(session, walletSlug);
    wallet.anchorBalance = balance;
    wallet.anchorDate = at ?? DateTime.now();
    return BenefitWallet.db.updateRow(session, wallet);
  }

  /// Sets the default top-up amount used by [topup] when none is given.
  Future<BenefitWallet> setMonthlyTopup(
    Session session,
    String walletSlug,
    double? amount,
  ) async {
    if (amount != null) {
      Validate.requirePositiveAmount(amount, 'amount');
    }
    final wallet = await _walletBySlug(session, walletSlug);
    wallet.monthlyTopupAmount = amount;
    return BenefitWallet.db.updateRow(session, wallet);
  }

  Future<void> deleteTransaction(Session session, int id) async {
    final wallets = await _ensureWallets(session);
    final walletIds = wallets.map((w) => w.id!).toSet();
    await FinancialTransaction.db.deleteWhere(
      session,
      where: (t) =>
          t.id.equals(id) &
          t.userId.equals(_userId(session)) &
          t.walletId.inSet(walletIds),
    );
  }
}
