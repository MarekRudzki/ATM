// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:atm/provider/atm_provider.dart';

void main() {
  late AtmProvider sut;

  setUp(() {
    sut = AtmProvider();
  });
  group(
    'Balance tests',
    () {
      test(
        'should return initial value',
        () async {
          expect(sut.balance, 2000);
        },
      );

      test(
        'should return decreased value',
        () async {
          sut.decreaseBalance(amount: 500);

          expect(sut.balance, 1500);
        },
      );
    },
  );

  group(
    'Bills availibility tests',
    () {
      test(
        'should return initial values',
        () async {
          expect(
            sut.availableBills,
            {
              200: 4,
              100: 2,
              50: 10,
              20: 40,
              10: 50,
            },
          );
        },
      );

      test(
        'should decrease selected denomination',
        () async {
          sut.decreaseAvailableBills(denomination: 200);
          sut.decreaseAvailableBills(denomination: 100);
          sut.decreaseAvailableBills(denomination: 50);
          sut.decreaseAvailableBills(denomination: 20);
          sut.decreaseAvailableBills(denomination: 10);
          expect(
            sut.availableBills,
            {
              200: 3,
              100: 1,
              50: 9,
              20: 39,
              10: 49,
            },
          );
        },
      );
    },
  );

  group(
    'Used bills tests',
    () {
      test(
        'should return initial values',
        () async {
          expect(
            sut.billsUsed,
            {
              200: 0,
              100: 0,
              50: 0,
              20: 0,
              10: 0,
            },
          );
        },
      );

      test(
        'should override initial values',
        () async {
          sut.updateBillCount(
            banknotesUsed: {
              200: 2,
              100: 0,
              50: 1,
              20: 1,
              10: 1,
            },
          );
          expect(
            sut.billsUsed,
            {
              200: 2,
              100: 0,
              50: 1,
              20: 1,
              10: 1,
            },
          );
        },
      );
    },
  );
}
