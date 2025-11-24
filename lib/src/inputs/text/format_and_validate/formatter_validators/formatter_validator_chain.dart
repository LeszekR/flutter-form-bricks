import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator.dart';

abstract class FormatterValidatorChain<Input, Value> {
  final List<FormatterValidator<Input, Value>> steps;

  FormatterValidatorChain(this.steps);

  /// Runs the formatting-validation chain for a given field.
  ///
  /// The [keyString] is required even in cases where it's not strictly needed,
  /// in order to simplify the overall interface and improve code readability.
  /// While it may be redundant for some `FormatterValidator` implementations,
  /// making it optional or conditional would add unnecessary complexity.
  ///
  /// This is a conscious trade-off favoring clarity and maintainability over minimalism.
  ///
  /// Used in composite validators like `DateTimeRangeFormatterValidator`, where multiple
  /// fields are validated as part of a group and require identification.
  ///
  /// Example: `DateTimeRangeFormatterValidator`
  FieldContent<Input, Value> runChain(
    BricksLocalizations localizations,
    String keyString,
    Input input,
  );
}

// TODO lock field types accepted as clients of each FormatterValidatorChain implementation

abstract class FormatterValidatorChainEarlyStop<Input, Value> extends FormatterValidatorChain<Input, Value> {
  FormatterValidatorChainEarlyStop(super.steps);

  @override
  FieldContent<Input, Value> runChain(
    BricksLocalizations localizations,
    String keyString,
    Input input,
  ) {
    FieldContent<Input, Value> resultFieldContent = FieldContent<Input, Value>.transient(input);

    for (FormatterValidator<Input, Value> step in steps) {
      resultFieldContent = step.run(localizations, keyString, resultFieldContent);
      if (resultFieldContent.isValid ?? false) {
        return resultFieldContent;
      }
    }
    return resultFieldContent;
  }
}

abstract class FormatterValidatorChainFullRun<Input, Value> extends FormatterValidatorChain<Input, Value> {
  FormatterValidatorChainFullRun(super.steps);

  @override
  FieldContent<Input, Value> runChain(
    BricksLocalizations localizations,
    String keyString,
    Input input,
  ) {
    FieldContent<Input, Value> resultFieldContent = FieldContent<Input, Value>.transient(input);

    for (FormatterValidator<Input, Value> step in steps) {
      resultFieldContent = step.run(localizations, keyString, resultFieldContent);
    }
    return resultFieldContent;
  }
}
