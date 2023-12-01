// Flutter imports:
import 'package:flutter/material.dart';

class SummaryDialog extends StatelessWidget {
  final String withdrawnedMoney;
  final Map<int, int> billsUsed;

  const SummaryDialog({
    super.key,
    required this.withdrawnedMoney,
    required this.billsUsed,
  });

  @override
  Widget build(BuildContext context) {
    final List<int> suffixNumbers = [2, 3, 4, 22, 23, 24];

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      title: const Text(
        'Transakcja zatwierdzona',
        textAlign: TextAlign.center,
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
            ),
          ),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Wypłacono $withdrawnedMoney PLN w następujących nominałach:',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Column(
            children: billsUsed.entries.map((entry) {
              final int denomination = entry.key;
              final int count = entry.value;
              final String text = '$denomination PLN - $count sztuk';

              if (suffixNumbers.contains(count)) {
                return Text('${text}i');
              } else if (count > 4) {
                return Text(text);
              } else if (count > 0) {
                return Text('${text}a');
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
