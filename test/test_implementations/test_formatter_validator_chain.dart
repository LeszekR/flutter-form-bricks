import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

/// Mocked FormatterValidatorChain that returns a fixed validation result.
/// Used in all value-change tests to simulate both valid and invalid responses.
class TestFormatterValidatorChain extends FormatterValidatorChain<String, TextEditingValue> {
  final String? mockError;

  TestFormatterValidatorChain([this.mockError]) : super([]);

  @override
  FieldContent<String, TextEditingValue> runChain(BricksLocalizations localizations, String keyString,
      String? inputValue) {
    return TextFieldContent.of('ala', TextEditingValue(text: 'ala'), true, '');
  }
}
