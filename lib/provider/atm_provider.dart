// Flutter imports:
import 'package:atm/enums.dart';
import 'package:flutter/material.dart';

class AtmProvider extends ChangeNotifier {
  int _balance = 2000;
  int get balance => _balance;

  void decreaseBalance({required int amount}) {
    _balance -= amount;
    notifyListeners();
  }

  final Map<int, int> _availableBills = {
    500: 3,
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
    for (final bill in Denominations.values) bill.denomination: 0
  };

  Map<int, int> get billsUsed => _billsUsed;

  void updateBillCount({required Map<int, int> banknotesUsed}) {
    _billsUsed = banknotesUsed;
    notifyListeners();
  }

  bool _isWithdrawLoading = false;

  bool get isWithdrawLoading => _isWithdrawLoading;

  void toggleWithdrawLoading() {
    _isWithdrawLoading = !_isWithdrawLoading;
    notifyListeners();
  }

  bool canATMwithdrawBanknotes({required int amount}) {
    final List<int> denominations =
        Denominations.values.map((e) => e.denomination).toList();

    try {
      for (int i = 0; amount != 0; i++) {
        int billCount = availableBills[denominations[i]]!;
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

  int getSmallestBill() {
    final List<int> denominations = availableBills.keys.toList();
    int smallest = denominations[0];
    for (final denomination in denominations) {
      if (denomination < smallest) {
        smallest = denomination;
      }
    }
    return smallest;
  }

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nie podano kwoty';
    } else if (value == '0' || value.startsWith('0')) {
      return 'Podaj kwotę większą niż 0';
    } else if (value.startsWith('-')) {
      return 'Podaj liczbę dodatnią';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Podaj liczbę całkowitą';
    } else if (int.parse(value) > balance) {
      return 'Brak wystarczających środków';
    } else if (int.parse(value) % getSmallestBill() != 0) {
      return 'Kwota niezgodna z nominałami';
    } else if (!canATMwithdrawBanknotes(
      amount: int.parse(value),
    )) {
      return 'Brak odpowiednich banknotów';
    }
    return null;
  }

  Future<void> calculateWithdraw({
    required int amount,
  }) async {
    final List<int> denominations =
        Denominations.values.map((e) => e.denomination).toList();
    final Map<int, int> banknotesUsed = {
      for (final bill in Denominations.values) bill.denomination: 0
    };

    toggleWithdrawLoading();
    await Future.delayed(const Duration(seconds: 3));
    decreaseBalance(amount: amount);
    for (int i = 0; amount != 0; i++) {
      int billCount = availableBills[denominations[i]]!;

      while (billCount > 0 && amount >= denominations[i]) {
        amount -= denominations[i];
        decreaseAvailableBills(denomination: denominations[i]);
        banknotesUsed[denominations[i]] = banknotesUsed[denominations[i]]! + 1;
        billCount -= 1;
      }
    }
    updateBillCount(banknotesUsed: banknotesUsed);
    toggleWithdrawLoading();
  }
}
