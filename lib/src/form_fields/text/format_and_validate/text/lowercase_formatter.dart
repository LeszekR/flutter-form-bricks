import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

class LowercaseFormatter extends FormatterValidator<String, TextEditingValue> {
  static LowercaseFormatter? _singleton;

  factory LowercaseFormatter() {
    _singleton ??= LowercaseFormatter._();
    return _singleton!;
  }

  LowercaseFormatter._();

  @override
  TextFieldContent run(
    BricksLocalizations localizations,
    String keyString,
    FieldContent<String, TextEditingValue> fieldContent,
  ) {
    if (fieldContent.input == null) return fieldContent;

    // if (!fieldContent.input!.contains(_upperCase)) return fieldContent;

    final String lowerCaseInput = fieldContent.input!.toLowerCase();
    return TextFieldContent.ok(
        lowerCaseInput,
        TextEditingValue(
          text: lowerCaseInput,
          selection: fieldContent.value!.selection,
        ));
  }
}
