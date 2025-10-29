import 'package:flutter/services.dart';

class DigitsAndHyphenFormatter extends TextInputFormatter {
  static final _requiredRegex =  RegExp(r'^[\d-]+$');
  static DigitsAndHyphenFormatter? _singleton;

  factory DigitsAndHyphenFormatter() {
    _singleton ??= DigitsAndHyphenFormatter._();
    return _singleton!;
  }

  DigitsAndHyphenFormatter._();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,TextEditingValue newValue) {
    return _requiredRegex.hasMatch(newValue.text) ? newValue : oldValue;
  }
}