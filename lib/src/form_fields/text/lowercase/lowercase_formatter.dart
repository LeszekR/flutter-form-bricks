import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/form_fields/components/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

LowercaseFormatter lowercaseFormatter = LowercaseFormatter();

class LowercaseFormatter extends FormatterValidator<TextEditingValue, String> {
  final _upperCase = RegExp(r'[A-Z]');

  LowercaseFormatter();

  @override
  TextFieldContent run(
    BricksLocalizations localizations,
    String keyString,
    TextEditingValue? input,
  ) {
    if (input == null) return const TextFieldContent.ok(null, null);

    if (!input.text.contains(_upperCase)) return TextFieldContent.ok(input, input.text);

    final String lowerCaseInput = input.text.toLowerCase();
    final TextSelection selection = input.selection ?? TextSelection.collapsed(offset: input.text.length);

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
