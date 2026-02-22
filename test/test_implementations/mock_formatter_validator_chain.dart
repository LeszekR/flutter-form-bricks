import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_field_base/string_extension.dart';

import 'mock_formatter_validator.dart';
import '../src/tools/test_constants.dart';

/// Mocked [FormatterValidatorChain] that returns a fixed validation result.
/// For use in all value-change tests to simulate both valid and invalid responses.
class MockFormatterValidatorChain extends FormatterValidatorChainFullRun<TextEditingValue, String> {
  final bool shouldRunChain;
  final String? mockInputString;
  final String? mockError;

  MockFormatterValidatorChain({
    required this.shouldRunChain,
    this.mockInputString,
    this.mockError,
  }) : super([MockTextFormatterValidator(returnInputTxEdVal: mockInputString?.txtEditVal(), mockError: mockError)]);

  @override
  FieldContent<TextEditingValue, String> runChain(
    BricksLocalizations localizations,
    String keyString,
    TextEditingValue? inputValue,
  ) {
    if (shouldRunChain) {
      return super.runChain(localizations, keyString, inputValue);
    }
    return TextFieldContent.of(
      TextEditingValue(text: stringInput1),
      stringInput1,
      mockError == null,
      mockError,
    );
  }
}
