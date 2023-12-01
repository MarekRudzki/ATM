// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:atm/provider/atm_provider.dart';
import 'package:atm/widgets/withdraw_button.dart';

void main() {
  group(
    'WithdrawButton calculateWithdraw',
    () {
      test(
        'should retrun correct banknotes denominations',
        () {
          final atmProvider = AtmProvider();
          final withdrawButton = WithdrawButton(
            controller: TextEditingController(),
            formKey: GlobalKey<FormState>(),
          );
          final result = withdrawButton.calculateWithdraw(
            amount: 270,
            provider: atmProvider,
          );

          expect(
            result,
            {
              200: 1,
              100: 0,
              50: 1,
              20: 1,
              10: 0,
            },
          );
        },
      );

      test(
        'should retrun correct banknotes denominations with larger withdraw amount',
        () {
          final atmProvider = AtmProvider();
          final withdrawButton = WithdrawButton(
            controller: TextEditingController(),
            formKey: GlobalKey<FormState>(),
          );
          final result = withdrawButton.calculateWithdraw(
            amount: 1790,
            provider: atmProvider,
          );

          expect(
            result,
            {
              200: 4,
              100: 2,
              50: 10,
              20: 14,
              10: 1,
            },
          );
        },
      );

      test(
        'should retrun correct banknotes denominations twice',
        () {
          final atmProvider = AtmProvider();
          final withdrawButton = WithdrawButton(
            controller: TextEditingController(),
            formKey: GlobalKey<FormState>(),
          );
          final result = withdrawButton.calculateWithdraw(
            amount: 920,
            provider: atmProvider,
          );

          expect(result, {
            200: 4,
            100: 1,
            50: 0,
            20: 1,
            10: 0,
          });

          final secondResult = withdrawButton.calculateWithdraw(
            amount: 480,
            provider: atmProvider,
          );

          expect(
            secondResult,
            {
              200: 0,
              100: 1,
              50: 7,
              20: 1,
              10: 1,
            },
          );
        },
      );
    },
  );
}
