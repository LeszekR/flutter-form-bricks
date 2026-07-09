import 'package:flutter_form_bricks/src/form_fields/text/fields/vat/vat_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final formatter = VatFormatter();

  test('Valid input: 2 letters followed by 10 numbers', () {
    const oldValue = TextEditingValue.empty;
    const newValue = TextEditingValue(text: 'AB1234567890');
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, 'AB1234567890');
  });

  test('Too many letters: Prevents entering more than 2 letters', () {
    const oldValue = TextEditingValue(text: 'AB');
    const newValue = TextEditingValue(text: 'ABC');
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, 'AB'); // Should ignore the third letter
  });

  test('Entering numbers without letters first', () {
    const oldValue = TextEditingValue.empty;
    const newValue = TextEditingValue(text: '123');
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, ''); // Should ignore numbers at the beginning
  });

  test('Too many numbers: Prevents entering more than 10 numbers', () {
    const oldValue = TextEditingValue(text: 'AB1234567890');
    const newValue = TextEditingValue(text: 'AB12345678901');
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, 'AB1234567890'); // Should ignore the extra digit
  });

  test('Mixed invalid input: Letters after numbers', () {
    const oldValue = TextEditingValue(text: 'AB12345678');
    const newValue = TextEditingValue(text: 'AB12345678C');
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, 'AB12345678'); // Should ignore the letter after numbers
  });

  test('Empty input: Accepts empty string', () {
    const oldValue = TextEditingValue.empty;
    const newValue = TextEditingValue.empty;
    final result = formatter.formatEditUpdate(oldValue, newValue);
    expect(result.text, '');
  });
}
