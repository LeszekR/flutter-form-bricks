import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/formatter_validators/formatter_validator.dart';

abstract class FormatterValidatorChain<I extends Object, V extends Object> {
  final List<FormatterValidator<I, V>> steps;

  // TODO throw on any step with different I or V types
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
  FieldContent<I, V> runChain(
    BricksLocalizations localizations,
    String keyString,
    I input,
  );
}

// TODO lock field types accepted as clients of each FormatterValidatorChain implementation

abstract class FormatterValidatorChainEarlyStop<I extends Object, V extends Object>
    extends FormatterValidatorChain<I, V> {
  FormatterValidatorChainEarlyStop(super.steps);

  @override
  FieldContent<I, V> runChain(
    BricksLocalizations localizations,
    String keyString,
    I input,
  ) {
    FieldContent<I, V> resultFieldContent = FieldContent<I, V>.transient(input);

    for (FormatterValidator<I, V> step in steps) {
      resultFieldContent = step.run(localizations, keyString, resultFieldContent);
      if (resultFieldContent.isValid ?? false) {
        return resultFieldContent;
      }
    }
    return resultFieldContent;
  }
}

abstract class FormatterValidatorChainFullRun<I extends Object, V extends Object>
    extends FormatterValidatorChain<I, V> {
  FormatterValidatorChainFullRun(super.steps);

  @override
  FieldContent<I, V> runChain(
    BricksLocalizations localizations,
    String keyString,
    I input,
  ) {
    FieldContent<I, V> resultFieldContent = FieldContent<I, V>.transient(input);

    for (FormatterValidator<I, V> step in steps) {
      resultFieldContent = step.run(localizations, keyString, resultFieldContent);
    }
    return resultFieldContent;
  }
}
