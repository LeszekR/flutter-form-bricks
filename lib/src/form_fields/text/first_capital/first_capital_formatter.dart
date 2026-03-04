import 'package:flutter/services.dart';

class FirstCapitalFormatter extends TextInputFormatter {
  static FirstCapitalFormatter? _singleton;
  static final RegExp _firstAlwaysUppercase = RegExp(r'\b\w+\b', multiLine: true);

  factory FirstCapitalFormatter() {
    _singleton ??= FirstCapitalFormatter._();
    return _singleton!;
  }

  FirstCapitalFormatter._();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,TextEditingValue newValue) {
    final String formattedText = newValue.text.replaceAllMapped(_firstAlwaysUppercase, _capitalize);

    return TextEditingValue(
      text: formattedText,
      selection: newValue.selection,
    );
  }

  String _capitalize(Match match) {
    final String matchStr = match[0]!;
    return '${matchStr[0].toUpperCase()}${matchStr.substring(1).toLowerCase()}';
  }
}