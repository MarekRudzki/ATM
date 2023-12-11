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

  @override
  Widget build(BuildContext context) {
    return Consumer<AtmProvider>(
      builder: (context, atmProvider, child) => ElevatedButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (formKey.currentState!.validate()) {
            await atmProvider.calculateWithdraw(
              amount: int.parse(controller.text),
            );

            if (!context.mounted) return;

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
        child: SizedBox(
          height: 50,
          width: 100,
          child: Align(
            child: atmProvider.isWithdrawLoading
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : const Text(
                    'Wypłać',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
