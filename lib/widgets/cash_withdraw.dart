// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:atm/provider/atm_provider.dart';
import 'package:atm/widgets/withdraw_button.dart';

class CashWithdraw extends StatefulWidget {
  const CashWithdraw({super.key});

  @override
  State<CashWithdraw> createState() => CashWithdrawState();
}

class CashWithdrawState extends State<CashWithdraw> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool canWithdraw(
      {required int amount, required Map<int, int> availableBills}) {
    final List<int> denominations = [200, 100, 50, 20, 10];
    final Map<int, int> availableBanknotes = availableBills;

    try {
      for (int i = 0; amount != 0; i++) {
        int billCount = availableBanknotes[denominations[i]]!;
        while (billCount > 0 && amount >= denominations[i]) {
          amount -= denominations[i];
          billCount -= 1;
        }
      }
    } catch (e) {
      if (e is RangeError) {
        return false;
      }
    }

    return true;
  }

  String? validateInput(String? value, AtmProvider atmProvider) {
    if (value == null || value.isEmpty) {
      return 'Nie podano kwoty';
    } else if (value == '0' || value.startsWith('0')) {
      return 'Podaj kwotę większą niż 0';
    } else if (value.startsWith('-')) {
      return 'Podaj liczbę dodatnią';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Podaj liczbę całkowitą';
    } else if (int.parse(value) > atmProvider.balance) {
      return 'Brak wystarczających środków';
    } else if (int.parse(value) % 10 != 0) {
      return 'Kwota niezgodna z nominałami';
    } else if (!canWithdraw(
      amount: int.parse(value),
      availableBills: atmProvider.availableBills,
    )) {
      return 'Brak odpowiednich banknotów';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 230, 233, 238),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(10, 10),
                color:
                    const Color.fromARGB(255, 77, 112, 166).withOpacity(0.25),
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
                'Podaj kwotę do wypłacenia',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.5,
                child: Form(
                  key: formKey,
                  child: Consumer<AtmProvider>(
                    builder: (context, atmProvider, child) => TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Wprowadź kwotę',
                        errorMaxLines: 2,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) => validateInput(value, atmProvider),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        WithdrawButton(
          controller: _controller,
          formKey: formKey,
        ),
      ],
    );
  }
}
