import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

LowercaseFormatter lowercaseFormatter = LowercaseFormatter();

class LowercaseFormatter extends FormatterValidator<TextEditingValue, String> {
  final _upperCase = RegExp(r'[A-Z]');

  LowercaseFormatter();

  @override
  TextFieldContent run(BricksLocalizations localizations,
      String keyString,
      FieldContent<TextEditingValue, String> fieldContent,) {
    if (fieldContent.input == null) return fieldContent;
    if (!fieldContent.input!.text.contains(_upperCase)) return fieldContent;

    final String lowerCaseInput = fieldContent.input!.text.toLowerCase();
    final TextSelection selection =
        fieldContent.input?.selection ?? TextSelection.collapsed(offset: fieldContent.input!.text.length);

    // TU PRZERWAŁEM - finish correct support for text selection - now it selects the whole text
    return TextFieldContent.ok(
      TextEditingValue(
        text: lowerCaseInput,
        selection: selection,
        composing: TextRange.empty, // important when transforming text
      ),
      lowerCaseInput,
    );
  }
// final raw = fieldContent.input;
// if (raw == null || raw.isEmpty) return fieldContent;
// if (!raw.contains(_upperCase)) return fieldContent;
//
// final lower = raw.toLowerCase();
//
// final incomingSel = fieldContent.value?.selection;
// final selection = _safeSelection(incomingSel, lower.length);
//
// return TextFieldContent.ok(
//   lower,
//   TextEditingValue(
//     text: lower,
//     selection: selection,
//     composing: TextRange.empty, // important when transforming text
//   ),
// );
// TextSelection _safeSelection(TextSelection? sel, int len) {
//   if (sel == null || !sel.isValid) {
//     return TextSelection.collapsed(offset: len);
//   }
//   final base = sel.baseOffset.clamp(0, len);
//   final extent = sel.extentOffset.clamp(0, len);
//   if (base == extent) return TextSelection.collapsed(offset: extent);
//   return TextSelection(baseOffset: base, extentOffset: extent);
// }
}

