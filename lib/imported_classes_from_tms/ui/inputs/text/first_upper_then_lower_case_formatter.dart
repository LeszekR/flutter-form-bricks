import 'package:flutter/services.dart';

class FirstUpperThenLowerCaseFormatter extends TextInputFormatter {
  static FirstUpperThenLowerCaseFormatter? _singleton;
  static final RegExp _firstAlwaysUppercase = RegExp(r'\b\w+\b', multiLine: true);

  factory FirstUpperThenLowerCaseFormatter() {
    _singleton ??= FirstUpperThenLowerCaseFormatter._();
    return _singleton!;
  }

  FirstUpperThenLowerCaseFormatter._();

  @override
  TextEditingValue formatEditUpdate(final TextEditingValue oldValue, final TextEditingValue newValue) {
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