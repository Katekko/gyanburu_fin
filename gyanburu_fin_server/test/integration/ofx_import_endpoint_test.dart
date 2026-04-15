import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Minimal valid OFX structure for testing.
/// Defaults to credit-card wrapper so existing tests keep working;
/// pass [isBank] = true to produce a checking-account OFX.
String _buildOfx({
  String currency = 'BRL',
  String dtStart = '20260301',
  String dtEnd = '20260331',
  bool isBank = false,
  List<String> transactions = const [],
}) {
  final txnBlocks = transactions.join('\n');
  if (isBank) {
    return '''
<OFX>
<BANKMSGSRSV1>
<STMTTRNRS>
<STMTRS>
<CURDEF>$currency</CURDEF>
<BANKACCTFROM>
<ACCTTYPE>CHECKING</ACCTTYPE>
</BANKACCTFROM>
<BANKTRANLIST>
<DTSTART>$dtStart</DTSTART>
<DTEND>$dtEnd</DTEND>
$txnBlocks
</BANKTRANLIST>
</STMTRS>
</STMTTRNRS>
</BANKMSGSRSV1>
</OFX>
''';
  }
  return '''
<OFX>
<CREDITCARDMSGSRSV1>
<CCSTMTTRNRS>
<CCSTMTRS>
<CURDEF>$currency</CURDEF>
<BANKTRANLIST>
<DTSTART>$dtStart</DTSTART>
<DTEND>$dtEnd</DTEND>
$txnBlocks
</BANKTRANLIST>
</CCSTMTRS>
</CCSTMTTRNRS>
</CREDITCARDMSGSRSV1>
</OFX>
''';
}

String _txn({
  String type = 'DEBIT',
  String date = '20260315',
  String amount = '-42.90',
  required String fitId,
  String memo = 'STORE PURCHASE',
}) =>
    '''
<STMTTRN>
<TRNTYPE>$type</TRNTYPE>
<DTPOSTED>$date</DTPOSTED>
<TRNAMT>$amount</TRNAMT>
<FITID>$fitId</FITID>
<MEMO>$memo</MEMO>
</STMTTRN>
''';

void main() {
  final userId = const Uuid().v4();

  withServerpod('Given OFX Import endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder authed;

    setUp(() {
      authed = sessionBuilder.copyWith(
          authentication:
              AuthenticationOverride.authenticationInfo(userId, {}),
      );
    });

    test('imports a simple OFX with one debit transaction', () async {
      final ofx = _buildOfx(transactions: [
        _txn(fitId: 'TX001', memo: 'UBER EATS', amount: '-35.00'),
      ]);

      final result =
          await endpoints.ofxImport.importOfx(authed, ofx, 'test.ofx');

      expect(result.newTransactions, 1);
      expect(result.skippedDuplicates, 0);
      expect(result.skippedCredits, 0);
      expect(result.fileName, 'test.ofx');
    });

    test('skips credit-card CREDIT transactions', () async {
      final ofx = _buildOfx(transactions: [
        _txn(
            fitId: 'TX010',
            type: 'CREDIT',
            memo: 'PAYMENT',
            amount: '500.00'),
      ]);

      final result =
          await endpoints.ofxImport.importOfx(authed, ofx, 'credits.ofx');

      expect(result.newTransactions, 0);
      expect(result.skippedCredits, 1);
    });

    test('deduplicates by fitId on second import', () async {
      final ofx = _buildOfx(transactions: [
        _txn(fitId: 'TX020', memo: 'SPOTIFY', amount: '-21.90'),
      ]);

      await endpoints.ofxImport.importOfx(authed, ofx, 'first.ofx');
      final second =
          await endpoints.ofxImport.importOfx(authed, ofx, 'second.ofx');

      expect(second.newTransactions, 0);
      expect(second.skippedDuplicates, 1);
    });

    test('rejects content without OFX tag', () async {
      expect(
        () => endpoints.ofxImport
            .importOfx(authed, 'not an ofx file', 'bad.txt'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
        'groups credit-card imported transactions by DTEND month (fatura), '
        'not by individual DTPOSTED date', () async {
      final faturaUserId = const Uuid().v4();
      final faturaAuthed = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
            faturaUserId, {}),
      );

      // Simulates a Nubank "fatura de maio" export: DTEND = Apr 30,
      // with transactions spanning the end of March through April.
      final ofx = _buildOfx(
        dtStart: '20260331',
        dtEnd: '20260430',
        transactions: [
          _txn(fitId: 'FAT-1', date: '20260331', memo: 'LATE MARCH BUY'),
          _txn(fitId: 'FAT-2', date: '20260401', memo: 'EARLY APRIL BUY'),
          _txn(fitId: 'FAT-3', date: '20260420', memo: 'MID APRIL BUY'),
        ],
      );

      await endpoints.ofxImport.importOfx(faturaAuthed, ofx, 'maio.ofx');

      final aprilList = await endpoints.transaction
          .listByMonth(faturaAuthed, DateTime(2026, 4));
      expect(aprilList, hasLength(3));
      expect(
        aprilList.map((t) => t.billingMonth).toSet(),
        equals({'2026-04'}),
      );
      expect(aprilList.every((t) => t.source == 'credit_card'), isTrue);
      expect(aprilList.every((t) => t.kind == 'expense'), isTrue);

      final marchList = await endpoints.transaction
          .listByMonth(faturaAuthed, DateTime(2026, 3));
      expect(marchList, isEmpty,
          reason: 'Mar 31 transaction belongs to the April fatura, '
              'not the March tab');
    });

    test('records import in history', () async {
      final ofx = _buildOfx(transactions: [
        _txn(fitId: 'TX030', memo: 'AMAZON', amount: '-299.90'),
        _txn(fitId: 'TX031', memo: 'NETFLIX', amount: '-55.90'),
        _txn(
            fitId: 'TX032',
            type: 'CREDIT',
            memo: 'REFUND',
            amount: '100.00'),
      ]);

      await endpoints.ofxImport.importOfx(authed, ofx, 'mixed.ofx');

      final history = await endpoints.importHistory.list(authed);
      expect(history, hasLength(1));
      expect(history.first.totalTransactions, 3);
      expect(history.first.newTransactions, 2);
      expect(history.first.skippedCredits, 1);
    });

    group('Bank statement import', () {
      test(
          'imports bank debits as expense and bank credits as income, '
          'tagged with source=bank and no billingMonth', () async {
        final bankUserId = const Uuid().v4();
        final bankAuthed = sessionBuilder.copyWith(
          authentication:
              AuthenticationOverride.authenticationInfo(bankUserId, {}),
        );

        final ofx = _buildOfx(
          isBank: true,
          dtStart: '20260401',
          dtEnd: '20260414',
          transactions: [
            _txn(
              fitId: 'BANK-IN-1',
              type: 'CREDIT',
              amount: '150.00',
              date: '20260401',
              memo:
                  'Transferência recebida pelo Pix - CODE AND APP TECNOLOGIA '
                  'LTDA - 35.423.126/0001-53 - ITAÚ UNIBANCO S.A.',
            ),
            _txn(
              fitId: 'BANK-OUT-1',
              type: 'DEBIT',
              amount: '-45.00',
              date: '20260402',
              memo: 'Compra no débito via NuPay - iFood',
            ),
            _txn(
              fitId: 'BANK-OUT-2',
              type: 'DEBIT',
              amount: '-800.00',
              date: '20260405',
              memo:
                  'Transferência enviada pelo Pix - FAST BEER BELA VISTA - '
                  '47.735.682/0001-44 - SICOOB',
            ),
          ],
        );

        final result =
            await endpoints.ofxImport.importOfx(bankAuthed, ofx, 'extrato.ofx');
        expect(result.newTransactions, 3,
            reason: 'CREDITs on bank OFX must NOT be skipped');
        expect(result.skippedCredits, 0);

        final list = await endpoints.transaction
            .listByMonth(bankAuthed, DateTime(2026, 4));
        expect(list, hasLength(3));
        expect(list.every((t) => t.source == 'bank'), isTrue);
        expect(list.every((t) => t.billingMonth == null), isTrue);

        final kinds = {for (final t in list) t.externalId: t.kind};
        expect(kinds['BANK-IN-1'], 'income');
        expect(kinds['BANK-OUT-1'], 'expense');
        expect(kinds['BANK-OUT-2'], 'expense');

        final merchants = {
          for (final t in list) t.externalId: t.merchantName,
        };
        expect(merchants['BANK-IN-1'], 'CODE AND APP TECNOLOGIA LTDA');
        expect(merchants['BANK-OUT-1'], 'iFood');
        expect(merchants['BANK-OUT-2'], 'FAST BEER BELA VISTA');
      });

      test('detects fatura payment on bank DEBIT and tags kind=fatura_payment',
          () async {
        final userId = const Uuid().v4();
        final a = sessionBuilder.copyWith(
          authentication:
              AuthenticationOverride.authenticationInfo(userId, {}),
        );

        final ofx = _buildOfx(
          isBank: true,
          transactions: [
            _txn(
              fitId: 'FP-1',
              type: 'DEBIT',
              amount: '-1234.56',
              date: '20260410',
              memo: 'Pagamento de fatura do cartão Nubank',
            ),
          ],
        );

        await endpoints.ofxImport.importOfx(a, ofx, 'extrato.ofx');
        final list =
            await endpoints.transaction.listByMonth(a, DateTime(2026, 4));
        expect(list, hasLength(1));
        expect(list.first.kind, 'fatura_payment');
        expect(list.first.source, 'bank');
      });

      test(
          'allows back-to-back imports (no per-user rate limit)',
          () async {
        final userId = const Uuid().v4();
        final a = sessionBuilder.copyWith(
          authentication:
              AuthenticationOverride.authenticationInfo(userId, {}),
        );

        final card = _buildOfx(
          transactions: [_txn(fitId: 'CARD-1', memo: 'Store', amount: '-10')],
        );
        final bank = _buildOfx(
          isBank: true,
          transactions: [
            _txn(
                fitId: 'BANK-1',
                type: 'DEBIT',
                amount: '-10',
                memo: 'Compra no débito - Shop'),
          ],
        );

        await endpoints.ofxImport.importOfx(a, card, 'card.ofx');
        await endpoints.ofxImport.importOfx(a, bank, 'bank.ofx');
        // Reaches here without throwing; both imports accepted immediately.
      });
    });
  });
}
