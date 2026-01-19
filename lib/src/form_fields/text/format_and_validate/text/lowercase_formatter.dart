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

    return TextFieldContent.ok(
      TextEditingValue(
        text: lowerCaseInput,
        selection: selection,
        composing: TextRange.empty, // important when transforming text
      ),
      lowerCaseInput,
    );
  }
}

