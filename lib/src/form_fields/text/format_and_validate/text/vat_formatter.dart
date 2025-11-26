import 'package:flutter/services.dart';

class VatFormatter extends TextInputFormatter {
  static VatFormatter? _singleton;

  factory VatFormatter() {
    _singleton ??= VatFormatter._();
    return _singleton!;
  }

  VatFormatter._();

  @override
  TextEditingValue formatEditUpdate(
      final TextEditingValue oldValue,TextEditingValue newValue) {
    final String input = newValue.text;
    final RegExp lettersRegex = RegExp(r'^[A-Z]{0,2}');
    final RegExp numbersRegex = RegExp(r'^\d{0,10}');
    String lettersPart = '';
    String numbersPart = '';

    String formattedText = _getFormattedTextForVatNumber(input, lettersRegex, lettersPart, numbersRegex, numbersPart);

    if (formattedText == newValue.text) {
      return newValue;
    }
    return TextEditingValue(
      text: formattedText,
      selection: _updateCursorPosition(newValue.selection, formattedText)
    );
  }

  String _getFormattedTextForVatNumber(String input, RegExp lettersRegex, String lettersPart, RegExp numbersRegex, String numbersPart) {
    if (input.isNotEmpty) {
      final lettersMatch = lettersRegex.firstMatch(input);
      if (lettersMatch != null) {
        lettersPart = lettersMatch.group(0) ?? '';
      }

      final remainingText = input.substring(lettersPart.length);

      if(lettersPart.length == 2){
        final numbersMatch = numbersRegex.firstMatch(remainingText);
        if (numbersMatch != null) {
          numbersPart = numbersMatch.group(0) ?? '';
        }
      }
    }

    final String formattedText = lettersPart + numbersPart;
    return formattedText;
  }

  TextSelection _updateCursorPosition(
      TextSelection oldSelection, String newText) {
    int textLength = newText.length;
    int newOffset = oldSelection.baseOffset;
    if (newOffset > textLength) {
      newOffset =
          textLength;
    }
    return TextSelection.fromPosition(TextPosition(offset: newOffset));
  }
}
