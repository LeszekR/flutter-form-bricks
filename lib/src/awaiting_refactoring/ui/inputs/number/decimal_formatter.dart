import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/shelf.dart';

import '../../../../inputs/states_controller/formatter_helper.dart';


class DoubleInputFormatter extends TextInputFormatter {
  static DoubleInputFormatter? _singleton;
  static const _decimalPoint = ",";

  factory DoubleInputFormatter() {
    _singleton ??= DoubleInputFormatter._();
    return _singleton!;
  }

  DoubleInputFormatter._();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,TextEditingValue newValue) {
    final String formattedText = _formatDecimal(oldValue, newValue);
    return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: FormatterHelper.calculateCursorPosition(formattedText, newValue))
    );
  }

  String _formatDecimal(TextEditingValue oldValue,TextEditingValue newValue) {
    if (!newValue.text.contains(_decimalPoint)) {
      return FormatterHelper.formatDigitsWithSpaces(newValue.text);
    }

    final splitByDecimal = newValue.text.split(_decimalPoint);

    final integerPart = FormatterHelper.formatDigitsWithSpaces(splitByDecimal[0]);
    return "${integerPart.trimRight()},${splitByDecimal[1]}";
  }
}