import 'package:flutter/services.dart';

class LowercaseFormatter extends TextInputFormatter {
  static final _upperCase = RegExp(r'[A-Z]');
  static LowercaseFormatter? _singleton;

  factory LowercaseFormatter() {
    _singleton ??= LowercaseFormatter._();
    return _singleton!;
  }

  LowercaseFormatter._();

  @override
  TextEditingValue formatEditUpdate(final TextEditingValue oldValue,TextEditingValue newValue) {
    if (newValue.text.contains(_upperCase)) {
      return TextEditingValue(
        text: newValue.text.toLowerCase(),
        selection: newValue.selection,
      );
    }
    return newValue;
  }
}