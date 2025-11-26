import 'package:flutter/services.dart';

import '../../../../form_fields/states_controller/formatter_helper.dart';

class IntegerInputFormatter extends TextInputFormatter {
  static IntegerInputFormatter? _singleton;

  factory IntegerInputFormatter() {
    _singleton ??= IntegerInputFormatter._();
    return _singleton!;
  }

  IntegerInputFormatter._();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,TextEditingValue newValue) {
    final String formattedText = FormatterHelper.formatDigitsWithSpaces(newValue.text);
    return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: FormatterHelper.calculateCursorPosition(formattedText, newValue))
    );
  }
}
