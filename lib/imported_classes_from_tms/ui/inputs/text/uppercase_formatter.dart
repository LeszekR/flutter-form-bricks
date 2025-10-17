import 'package:flutter/services.dart';

class UppercaseFormatter extends TextInputFormatter {
  static final _lowerCase = RegExp(r'[a-z]');
  static UppercaseFormatter? _singleton;

  factory UppercaseFormatter() {
    _singleton ??= UppercaseFormatter._();
    return _singleton!;
  }

  UppercaseFormatter._();

  @override
  TextEditingValue formatEditUpdate(final TextEditingValue oldValue, final TextEditingValue newValue) {
    if (newValue.text.contains(_lowerCase)) {
      return TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
    }
    return newValue;
  }
}