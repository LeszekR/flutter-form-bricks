import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_payload.dart';


// =================================================================================
// Formatter-validator chain - chain of formatter-validators
// =================================================================================
abstract class FormatterValidatorChain<I, V, P extends FormatValidatePayload> {
  final List<FormatterValidator<I, V, P>> steps;

  FormatterValidatorChain(this.steps);

  FieldContent<I, V> runChain(
    BricksLocalizations localizations,
    I input, [
    P? payload,
  ]);
}

// TODO lock field types accepted as clients of each FormatterValidatorChain

abstract class FormatterValidatorChainEarlyStop<I, V, P extends FormatValidatePayload>
    extends FormatterValidatorChain<I, V, P> {
  FormatterValidatorChainEarlyStop(super.steps);

  @override
  FieldContent<I, V> runChain(
    BricksLocalizations localizations,
    I inputString, [
    P? payload,
  ]) {
    FieldContent<I, V> result = FieldContent<I, V>.transient(inputString);

    for (FormatterValidator<I, V, P> step in steps) {
      result = step.run(localizations, result, payload);
      if (result.isValid != null && result.isValid!) {
        return result;
      }
    }
    return result;
  }
}

abstract class FormatterValidatorChainFullRun<I, V, P extends FormatValidatePayload>
    extends FormatterValidatorChain<I, V, P> {
  FormatterValidatorChainFullRun(super.steps);

  @override
  FieldContent<I, V> runChain(
    BricksLocalizations localizations,
    I inputString, [
    P? payload,
  ]) {
    FieldContent<I, V> result = FieldContent<I, V>.transient(inputString);

    for (FormatterValidator<I, V, P> step in steps) {
      result = step.run(localizations, result, payload);
    }
    return result;
  }
}
