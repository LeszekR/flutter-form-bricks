import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';

/// A pipeline of formatting/validation steps executed for a single field.
///
/// Each step is a [`FormatterValidator<I, V>`] that takes the current
/// [`FieldContent<I, V>`], can **format** the input, and/or **validate** it,
/// and returns a new `FieldContent`.
///
/// Construction guarantees:
/// - Non-empty list of steps.
/// - All steps have the same generic types `I` and `V`.
/// - No duplicate validator *types* (by `runtimeType`) in the chain.
///
/// See also: [FormatterValidatorChainEarlyStop], [FormatterValidatorChainFullRun].
abstract class FormatterValidatorChain<I extends Object, V extends Object> {
  /// Validators executed in order.
  final List<FormatterValidator<I, V>> steps;

  /// Creates an immutable, validated chain.
  FormatterValidatorChain(List<FormatterValidator<I, V>> steps) : steps = List.unmodifiable(_validated<I, V>(steps));

  static List<FormatterValidator<I, V>> _validated<I extends Object, V extends Object>(
    List<FormatterValidator<I, V>> steps,
  ) {
    if (steps.isEmpty) {
      throw ArgumentError('FormatterValidatorChain steps must not be empty.');
    }
    final seen = <Type>{};
    for (final s in steps) {
      if (s.inputType != I) {
        throw ArgumentError('FormatterValidator inputType conflict: ${s.inputType} != $I.');
      }
      if (s.valueType != V) {
        throw ArgumentError('FormatterValidator valueType conflict:  ${s.valueType} != $V.');
      }
      if (!seen.add(s.runtimeType)) {
        throw ArgumentError('Duplicate FormatterValidator kind: ${s.runtimeType}.');
      }
    }
    return steps;
  }

  /// Runs the chain for a given field.
  ///
  /// The [keyString] is always required to keep the API uniform and to aid
  /// composite validators that act on multiple fields and need identification.
  ///
  /// Returns the final [`FieldContent<I, V>`] after the chain execution policy
  /// (see subclasses for details).
  FieldContent<I, V> runChain(
    BricksLocalizations localizations,
    String keyString,
    I? input,
  );
}

/// A chain policy that **stops early** as soon as the running result turns **invalid**.
///
/// Execution:
/// 1) Start with a transient `FieldContent(input)`.
/// 2) For each step, call `run(...)`.
/// 3) If `result.isValid == false` after a step, **return immediately**.
/// 4) Otherwise continue until steps are exhausted.
///
/// Use this when any single successful validator fails to accept
/// the current value (e.g., “first-error-blocks” semantics).
class FormatterValidatorChainEarlyStop<I extends Object, V extends Object> extends FormatterValidatorChain<I, V> {
  FormatterValidatorChainEarlyStop(super.steps);

  @override
  FieldContent<I, V> runChain(
    BricksLocalizations localizations,
    String keyString,
    I? input,
  ) {
    var resultFieldContent = FieldContent<I, V>.transient(input);
    for (final step in steps) {
      resultFieldContent = step.run(localizations, keyString, resultFieldContent);
      // TODO test early stop on invalid field content
      if (!(resultFieldContent.isValid ?? true)) {
        return resultFieldContent;
      }
    }
    return resultFieldContent;
  }
}

/// A chain policy that **always runs all steps** and returns the final result.
///
/// Execution:
/// 1) Start with a transient `FieldContent(input)`.
/// 2) Run every validator in order, feeding the output to the next.
/// 3) Return the **last** `FieldContent`.
///
/// Use this when each validator contributes formatting/validation and you want
/// the **accumulated** effect regardless of intermediate validity.
class FormatterValidatorChainFullRun<I extends Object, V extends Object> extends FormatterValidatorChain<I, V> {
  FormatterValidatorChainFullRun(super.steps);

  @override
  FieldContent<I, V> runChain(
    BricksLocalizations localizations,
    String keyString,
    I? input,
  ) {
    var resultFieldContent = FieldContent<I, V>.transient(input);
    for (final step in steps) {
      resultFieldContent = step.run(localizations, keyString, resultFieldContent);
    }
    return resultFieldContent;
  }
}
