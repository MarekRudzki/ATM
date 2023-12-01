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
  State<CashWithdraw> createState() => _CashWithdrawState();
}

class _CashWithdrawState extends State<CashWithdraw> {
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

  String? _validateInput(String? value, AtmProvider atmProvider) {
    if (value == null || value.isEmpty) {
      return 'Nie podano kwoty';
    } else if (value.startsWith('-')) {
      return 'Podaj liczbę dodatnią';
    } else if (value.contains(',') ||
        value.contains('.') ||
        value.contains(' ') ||
        value.contains('-')) {
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
        const Text(
          'Podaj kwotę do wypłacenia',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 158, 156, 156),
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
                decoration: const InputDecoration(
                  hintText: 'Wprowadź kwotę',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) => _validateInput(value, atmProvider),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        WithdrawButton(
          controller: _controller,
          formKey: formKey,
        ),
      ],
    );
  }
}
