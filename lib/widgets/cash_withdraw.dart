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
                      validator: (value) => atmProvider.validateInput(value),
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
