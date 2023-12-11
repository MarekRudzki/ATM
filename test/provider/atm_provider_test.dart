// Package imports:
import 'package:atm/enums.dart';
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
        () {
          expect(sut.balance, 2000);
        },
      );

      test(
        'should return decreased value',
        () {
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
        () {
          expect(
            sut.availableBills,
            {
              500: 3,
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
        () {
          for (final bill in Denominations.values) {
            sut.decreaseAvailableBills(denomination: bill.denomination);
          }

          expect(
            sut.availableBills,
            {
              500: 2,
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
              for (final bill in Denominations.values) bill.denomination: 0,
            },
          );
        },
      );

      test(
        'should override initial values',
        () async {
          sut.updateBillCount(
            banknotesUsed: {
              500: 1,
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
              500: 1,
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

  group(
    'Withdraw loading status',
    () {
      test(
        'should return correct values',
        () {
          expect(sut.isWithdrawLoading, false);

          sut.toggleWithdrawLoading();
          expect(sut.isWithdrawLoading, true);

          sut.toggleWithdrawLoading();
          expect(sut.isWithdrawLoading, false);
        },
      );
    },
  );

  test(
    'Should check if ATM has appropriate bills for withdrawal',
    () {
      final canWithdraw = sut.canATMwithdrawBanknotes(amount: 370);

      expect(canWithdraw, true);

      for (int i = 0; i < 50; i++) {
        sut.decreaseAvailableBills(denomination: 10);
      }
      final canWithdrawAfterDecreasing =
          sut.canATMwithdrawBanknotes(amount: 10);
      expect(canWithdrawAfterDecreasing, false);
    },
  );

  test(
    'Should get smallest available bill',
    () {
      final int smallestBill = sut.getSmallestBill();

      expect(smallestBill, 10);
    },
  );

  group(
    'Input validation',
    () {
      test(
        'should return error message',
        () {
          final input1 = sut.validateInput('');
          expect(input1, 'Nie podano kwoty');

          final input2 = sut.validateInput('0');
          expect(input2, 'Podaj kwotę większą niż 0');

          final input3 = sut.validateInput('090');
          expect(input3, 'Podaj kwotę większą niż 0');

          final input4 = sut.validateInput('-150');
          expect(input4, 'Podaj liczbę dodatnią');

          final input5 = sut.validateInput('50.50');
          expect(input5, 'Podaj liczbę całkowitą');

          final input6 = sut.validateInput('Twenty');
          expect(input6, 'Podaj liczbę całkowitą');

          final input7 = sut.validateInput('2500');
          expect(input7, 'Brak wystarczających środków');

          final input8 = sut.validateInput('155');
          expect(input8, 'Kwota niezgodna z nominałami');

          for (int i = 0; i < 50; i++) {
            sut.decreaseAvailableBills(denomination: 10);
          }
          final input9 = sut.validateInput('30');
          expect(input9, 'Brak odpowiednich banknotów');
        },
      );

      test(
        'should pass validation',
        () {
          final input = sut.validateInput('180');
          expect(input, null);
        },
      );
    },
  );

  test(
    'Should calculate withdraw',
    () async {
      await sut.calculateWithdraw(amount: 880);
      expect(sut.balance, 1120);
      expect(
        sut.availableBills,
        {
          500: 2,
          200: 3,
          100: 1,
          50: 9,
          20: 39,
          10: 49,
        },
      );
      expect(
        sut.billsUsed,
        {
          for (final bill in Denominations.values) bill.denomination: 1,
        },
      );
    },
  );
}
