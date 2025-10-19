import 'package:flutter/cupertino.dart';

class FormatterHelper {
  static final _regexToPutSpaceBetweenChars = RegExp(r'(.{3})(?!$)');

  FormatterHelper._();

  static void onSubmittedTrimming(String? value, TextEditingController controller) {
    String trimmedValue  = value!.trim();
    controller.text = trimmedValue;
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: trimmedValue.length)
    );
  }

  static String formatDigitsWithSpaces(final String originalText) {
    final withoutSpaces = originalText.replaceAll(' ', '');

    if (withoutSpaces.length <= 3) {
      return withoutSpaces;
    }

    final firstSegmentLength = _determineFirstSegment(withoutSpaces);

    final leadingSegment = withoutSpaces.substring(0, firstSegmentLength);
    final otherSegments = _putSpaceBetweenChars(withoutSpaces.substring(firstSegmentLength));

    return "$leadingSegment $otherSegments";
  }

  static int _determineFirstSegment(final String text) {
    final modulo = text.length % 3;
    return modulo == 0 ? 3 : modulo;
  }

  static String _putSpaceBetweenChars(final String text) {
    return text.replaceAllMapped(_regexToPutSpaceBetweenChars, (Match m) => '${m[1]} ');
  }

  static calculateCursorPosition(final String formattedText,TextEditingValue newValue) {
    int newCursorPosition =  newValue.selection.baseOffset;

    // Adjust cursor position based on formatting changes
    if (formattedText.length > newValue.text.length) {
      // If formatting added spaces, move cursor forward
      newCursorPosition += formattedText.length - newValue.text.length;
    } else if (formattedText.length < newValue.text.length) {
      // If formatting removed spaces, move cursor back
      newCursorPosition -= newValue.text.length - formattedText.length;
    }

    // Ensure the new cursor position is within the valid range
    newCursorPosition = newCursorPosition.clamp(0, formattedText.length);

    return newCursorPosition;
  }
}