import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/text/vat_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final formatter = VatFormatter();

  test('Valid input: 2 letters followed by 10 numbers', () {
    final oldValue = TextEditingValue.empty;
    final newValue = TextEditingValue(text: 'AB1234567890');
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, 'AB1234567890');
  });

  test('Too many letters: Prevents entering more than 2 letters', () {
    final oldValue = TextEditingValue(text: 'AB');
    final newValue = TextEditingValue(text: 'ABC');
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, 'AB'); // Should ignore the third letter
  });

  test('Entering numbers without letters first', () {
    final oldValue = TextEditingValue.empty;
    final newValue = TextEditingValue(text: '123');
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, ''); // Should ignore numbers at the beginning
  });

  test('Too many numbers: Prevents entering more than 10 numbers', () {
    final oldValue = TextEditingValue(text: 'AB1234567890');
    final newValue = TextEditingValue(text: 'AB12345678901');
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, 'AB1234567890'); // Should ignore the extra digit
  });

  test('Mixed invalid input: Letters after numbers', () {
    final oldValue = TextEditingValue(text: 'AB12345678');
    final newValue = TextEditingValue(text: 'AB12345678C');
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, 'AB12345678'); // Should ignore the letter after numbers
  });

  test('Empty input: Accepts empty string', () {
    final oldValue = TextEditingValue.empty;
    final newValue = TextEditingValue.empty;
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '');
  });
}
