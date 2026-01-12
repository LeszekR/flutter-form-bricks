import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator_chain.dart';

import 'mock_formatter_validator.dart';
import '../src/tools/test_constants.dart';

/// Mocked [FormatterValidatorChain] that returns a fixed validation result.
/// For use in all value-change tests to simulate both valid and invalid responses.
class MockFormatterValidatorChain extends FormatterValidatorChainFullRun<String, TextEditingValue> {
  final bool shouldRunChain;
  final String? mockInput;
  final String? mockError;

  MockFormatterValidatorChain({
    required this.shouldRunChain,
    this.mockInput,
    this.mockError,
  }) : super([MockTextFormatterValidator(mockInput: mockInput, mockError: mockError)]);

  @override
  FieldContent<String, TextEditingValue> runChain(
    BricksLocalizations localizations,
    String keyString,
    String? inputValue,
  ) {
    if (shouldRunChain) {
      return super.runChain(localizations, keyString, inputValue);
    }
    return TextFieldContent.of(
      stringInput1,
      TextEditingValue(text: stringInput1),
      mockError == null,
      mockError,
    );
  }
}
