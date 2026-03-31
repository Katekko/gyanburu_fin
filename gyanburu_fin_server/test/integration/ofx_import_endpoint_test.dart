import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Minimal valid OFX structure for testing.
String _buildOfx({
  String currency = 'BRL',
  String dtStart = '20260301',
  String dtEnd = '20260331',
  List<String> transactions = const [],
}) {
  final txnBlocks = transactions.join('\n');
  return '''
<OFX>
<BANKMSGSRSV1>
<STMTTRNRS>
<STMTRS>
<CURDEF>$currency</CURDEF>
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

    test('skips credit transactions', () async {
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
  });
}
