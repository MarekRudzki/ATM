// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:atm/provider/atm_provider.dart';
import 'package:atm/widgets/cash_withdraw.dart';

class AtmProviderMock extends Mock implements AtmProvider {}

void main() {
  late AtmProvider atmProvider;

  setUp(() {
    atmProvider = AtmProviderMock();
  });

  group('CashWithdraw validateInput', () {
    setUp(() {
      when(() => atmProvider.availableBills).thenReturn({
        200: 4,
        100: 2,
        50: 10,
        20: 40,
        10: 50,
      });

      when(() => atmProvider.balance).thenReturn(2000);
    });

    final cashWithdraw = const CashWithdraw();
    final element = cashWithdraw.createElement();
    final state = element.state as CashWithdrawState;

    test('should return error message for null or empty value', () {
      final emptyValue = state.validateInput('', atmProvider);
      expect(emptyValue, 'Nie podano kwoty');

      final nullValue = state.validateInput(null, atmProvider);
      expect(nullValue, 'Nie podano kwoty');
    });

    test('should return error message for value that starts with or contain 0',
        () {
      final valueContainsZero = state.validateInput('0', atmProvider);
      expect(valueContainsZero, 'Podaj kwotę większą niż 0');

      final valueStartsWithZero = state.validateInput('050', atmProvider);
      expect(valueStartsWithZero, 'Podaj kwotę większą niż 0');
    });

    test('should return error message for value that starts with negative sign',
        () {
      final value = state.validateInput('-10', atmProvider);
      expect(value, 'Podaj liczbę dodatnią');
    });

    test('should return error message for value that is not int type', () {
      final value = state.validateInput('qwe123%', atmProvider);
      expect(value, 'Podaj liczbę całkowitą');
    });

    test(
        'should return error message for value that is greater than current balance',
        () {
      final value = state.validateInput('2500', atmProvider);
      expect(value, 'Brak wystarczających środków');
    });

    test(
        'should return error message for value that is inconsistent with denominations',
        () {
      final value = state.validateInput('1855', atmProvider);
      expect(value, 'Kwota niezgodna z nominałami');
    });

    test(
        'should return error message for scenario with lack of appropriate banknotes',
        () {
      when(() => atmProvider.availableBills).thenReturn({
        200: 4,
        100: 2,
        50: 10,
        20: 40,
        10: 0,
      });
      final value = state.validateInput('10', atmProvider);
      expect(value, 'Brak odpowiednich banknotów');
    });

    test('should return null for valid input', () {
      final value = state.validateInput('300', atmProvider);
      expect(value, null);
    });
  });
}
