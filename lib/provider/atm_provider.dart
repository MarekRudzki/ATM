// Flutter imports:
import 'package:flutter/material.dart';

class AtmProvider extends ChangeNotifier {
  int _balance = 2000;
  int get balance => _balance;

  void decreaseBalance({required int amount}) {
    _balance -= amount;
    notifyListeners();
  }

  final Map<int, int> _availableBills = {
    200: 4,
    100: 2,
    50: 10,
    20: 40,
    10: 50,
  };

  Map<int, int> get availableBills => _availableBills;

  void decreaseAvailableBills({required int denomination}) {
    _availableBills[denomination] = _availableBills[denomination]! - 1;
    notifyListeners();
  }

  Map<int, int> _billsUsed = {
    200: 0,
    100: 0,
    50: 0,
    20: 0,
    10: 0,
  };

  Map<int, int> get billsUsed => _billsUsed;

  void updateBillCount({required Map<int, int> banknotesUsed}) {
    _billsUsed = banknotesUsed;
    notifyListeners();
  }
}
