import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_payload.dart';

abstract class FormatterValidatorChain<Input, Value, Payload extends FormatterValidatorPayload> {
  final List<FormatterValidator<Input, Value, Payload>> steps;

  FormatterValidatorChain(this.steps);

  FieldContent<Input, Value> runChain(
    BricksLocalizations localizations,
    Input input, [
    String? keyString,
    Payload? payload,
  ]);
}

// TODO lock field types accepted as clients of each FormatterValidatorChain implementation

abstract class FormatterValidatorChainEarlyStop<I, V, P extends FormatterValidatorPayload>
    extends FormatterValidatorChain<I, V, P> {
  FormatterValidatorChainEarlyStop(super.steps);

  @override
  FieldContent<I, V> runChain(
    BricksLocalizations localizations,
    I inputString, [
    String? keyString,
    P? payload,
  ]) {
    FieldContent<I, V> result = FieldContent<I, V>.transient(inputString);

    for (FormatterValidator<I, V, P> step in steps) {
      result = step.run(localizations, result, payload, keyString);
      if (result.isValid != null && result.isValid!) {
        return result;
      }
    }
    return result;
  }
}

abstract class FormatterValidatorChainFullRun<I, V, P extends FormatterValidatorPayload>
    extends FormatterValidatorChain<I, V, P> {
  FormatterValidatorChainFullRun(super.steps);

  @override
  FieldContent<I, V> runChain(
    BricksLocalizations localizations,
    I inputString, [
    String? keyString,
    P? payload,
  ]) {
    FieldContent<I, V> result = FieldContent<I, V>.transient(inputString);

    for (FormatterValidator<I, V, P> step in steps) {
      result = step.run(localizations, result, payload, keyString);
    }
    return result;
  }
}
