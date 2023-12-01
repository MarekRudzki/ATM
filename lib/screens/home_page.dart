// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:atm/provider/atm_provider.dart';
import 'package:atm/widgets/cash_withdraw.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bankomat',
          ),
          backgroundColor: const Color.fromARGB(255, 49, 189, 232),
          centerTitle: true,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.07,
              ),
              const Text(
                'Dostępne środki',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 158, 156, 156),
                ),
              ),
              const SizedBox(height: 15),
              Consumer<AtmProvider>(
                builder: (context, atmProvider, child) => Text(
                  '${atmProvider.balance} PLN',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.07,
              ),
              const CashWithdraw(),
            ],
          ),
        ),
      ),
    );
  }
}
