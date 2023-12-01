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
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.04,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 230, 233, 238),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(10, 10),
                        color: const Color.fromARGB(255, 77, 112, 166)
                            .withOpacity(0.25),
                        blurRadius: 36,
                      ),
                      const BoxShadow(
                        offset: Offset(-10, -10),
                        color: Color.fromARGB(170, 255, 255, 255),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Dostępne środki',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Consumer<AtmProvider>(
                        builder: (context, atmProvider, child) => Text(
                          '${atmProvider.balance} PLN',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.04,
                ),
                const CashWithdraw(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
