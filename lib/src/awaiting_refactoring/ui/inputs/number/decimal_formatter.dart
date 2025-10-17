import 'package:flutter/services.dart';

import '../base/formatter_helper.dart';


class DoubleInputFormatter extends TextInputFormatter {
  static DoubleInputFormatter? _singleton;
  static const _decimalPoint = ",";

  factory DoubleInputFormatter() {
    _singleton ??= DoubleInputFormatter._();
    return _singleton!;
  }

  DoubleInputFormatter._();

  @override
  TextEditingValue formatEditUpdate(final TextEditingValue oldValue, final TextEditingValue newValue) {
    final String formattedText = _formatDecimal(oldValue, newValue);
    return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: FormatterHelper.calculateCursorPosition(formattedText, newValue))
    );
  }

  String _formatDecimal(final TextEditingValue oldValue, final TextEditingValue newValue) {
    if (!newValue.text.contains(_decimalPoint)) {
      return FormatterHelper.formatDigitsWithSpaces(newValue.text);
    }

    final splitByDecimal = newValue.text.split(_decimalPoint);

    final integerPart = FormatterHelper.formatDigitsWithSpaces(splitByDecimal[0]);
    return "${integerPart.trimRight()},${splitByDecimal[1]}";
  }
}