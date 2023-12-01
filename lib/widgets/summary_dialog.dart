// Flutter imports:
import 'package:flutter/material.dart';

class SummaryDialog extends StatelessWidget {
  final String withdrawMoney;
  final Map<int, int> billsUsed;

  const SummaryDialog({
    super.key,
    required this.withdrawMoney,
    required this.billsUsed,
  });

  @override
  Widget build(BuildContext context) {
    final List<int> suffixNumbers = [2, 3, 4, 22, 23, 24];

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text(
        'Transakcja zatwierdzona',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        Center(
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.check,
              color: Colors.green,
              size: 30,
            ),
          ),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Wypłacono $withdrawMoney PLN w następujących nominałach:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: billsUsed.entries.map((entry) {
              final int denomination = entry.key;
              final int count = entry.value;
              final String text = '$denomination PLN - $count sztuk';

              if (suffixNumbers.contains(count)) {
                return MoneyDispenseText(text: '${text}i');
              } else if (count > 4) {
                return MoneyDispenseText(text: text);
              } else if (count > 0) {
                return MoneyDispenseText(text: '${text}a');
              } else {
                return const SizedBox.shrink();
              }
            }).toList(),
          )
        ],
      ),
    );
  }
}

class MoneyDispenseText extends StatelessWidget {
  final String text;

  const MoneyDispenseText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
