import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

/// Mocked FormatterValidatorChain that returns a fixed validation result.
/// Used in all value-change tests to simulate both valid and invalid responses.
class TestFormatterValidatorChain extends FormatterValidatorChain {
  final String? mockError;

  TestFormatterValidatorChain([this.mockError]) : super([]);

  @override
  String? getError(Object? value) => mockError;

  @override
  runChain(inputValue) {
    // no op
  }
}
