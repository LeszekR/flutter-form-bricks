import 'package:flutter/services.dart';

/*
Default formatter for text inputs
*/
class ForbiddenWhitespacesFormatter extends TextInputFormatter {
  static ForbiddenWhitespacesFormatter? _singleton;
  static final RegExp _noLeadingSpace = RegExp(r'^\s+');
  static final RegExp _noDoubleSpace = RegExp(r'\s{2,}');

  factory ForbiddenWhitespacesFormatter() {
    _singleton ??= ForbiddenWhitespacesFormatter._();
    return _singleton!;
  }

  ForbiddenWhitespacesFormatter._();

  @override
  TextEditingValue formatEditUpdate(
      final TextEditingValue oldValue, final TextEditingValue newValue) {
    final String formattedText = newValue.text
        .replaceFirst(_noLeadingSpace, '')
        .replaceAll(_noDoubleSpace, ' ');

    if (newValue.text == formattedText) {
      return newValue;
    }

    return TextEditingValue(
      text: formattedText,
      selection: _updateCursorPosition(newValue.selection, formattedText),
    );
  }

  TextSelection _updateCursorPosition(
      TextSelection oldSelection, String newText) {
    int textLength = newText.length;
    int newOffset = oldSelection.baseOffset;
    if (newOffset > textLength) {
      newOffset =
          textLength; // Set cursor at the end of the text if it goes beyond.
    }
    return TextSelection.fromPosition(TextPosition(offset: newOffset));
  }
}
