// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:atm/provider/atm_provider.dart';
import 'package:atm/widgets/summary_dialog.dart';

class WithdrawButton extends StatelessWidget {
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  const WithdrawButton({
    super.key,
    required this.controller,
    required this.formKey,
  });

  Map<int, int> calculateWithdraw({
    required int amount,
    required AtmProvider provider,
  }) {
    final List<int> denominations = [200, 100, 50, 20, 10];
    final Map<int, int> banknotesUsed = {200: 0, 100: 0, 50: 0, 20: 0, 10: 0};

    for (int i = 0; amount != 0; i++) {
      int billCount = provider.availableBills[denominations[i]]!;

      while (billCount > 0 && amount >= denominations[i]) {
        amount -= denominations[i];
        provider.decreaseAvailableBills(denomination: denominations[i]);
        banknotesUsed[denominations[i]] = banknotesUsed[denominations[i]]! + 1;
        billCount -= 1;
      }
    }
    return banknotesUsed;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AtmProvider>(
      builder: (context, atmProvider, child) => ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (formKey.currentState!.validate()) {
            final int withdrawAmount = int.parse(controller.text);
            final Map<int, int> banknotesUsed = calculateWithdraw(
              amount: withdrawAmount,
              provider: atmProvider,
            );

            atmProvider.updateBillCount(banknotesUsed: banknotesUsed);
            atmProvider.decreaseBalance(amount: withdrawAmount);

            showDialog(
              context: context,
              builder: (context) {
                return SummaryDialog(
                  withdrawMoney: controller.text,
                  billsUsed: atmProvider.billsUsed,
                );
              },
            ).then((_) {
              controller.clear();
            });
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.primary,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 26,
            vertical: 12,
          ),
          child: Text(
            'Wypłać',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
