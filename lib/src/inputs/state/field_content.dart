import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/time_stamp.dart';

/// Result of formatting-validation operation by `FormatterValidator`.
///
/// **input** is what the user edits and can / see in the UI.
///
/// **value** is the result of the **Content** parsing into a different type, only used in field types which display
/// different type for content and for value actually yielded from the field.
/// (Examples: `DateFieldBrick`, 'IntegerFieldBrick`, `RadioBrick`, etc.)
///
/// **isValid** - self-explanatory.
///
/// **error** is error message which will be displayed in UI either in `InputDecoration` or in form area dedicated
/// for this purpose.
class FieldContent<Input, Value> {
  final Input? input;
  final Value? value;
  final bool? isValid;
  final String? error;

  /// Creates `fieldContent`.
  const FieldContent.of(this.input, [this.value, this.isValid, this.error]);

  /// Only to be used as **temporary result** carrying transient state of the formatted input in formatting-validating
  /// procedure (e.g. partly formatted date string).
  /// **Never** to be used as a return value of `FormatterValidator`.
  const FieldContent.transient(Input input) : this.of(input, null, null, null);

  /// Use in formatting-validating procedure when the result is valid.
  const FieldContent.ok(Input? input, Value? value) : this.of(input, value, true, null);

  /// Use in formatting-validating procedure when the result is invalid.
  const FieldContent.err(Input? input, String? error) : this.of(input, null, false, error);

  /// Use wherever no result should be returned as a step of the multi-step format-validating procedure.
  const FieldContent.empty() : this.of(null, null, false, null);

  // TODO verify, refactor? - should use of named constructors vs copyWith - ?
  FieldContent<Input, Value> copyWith({
    Input? input,
    Value? value,
    bool? isValid,
    String? error,
  }) {
    return FieldContent.of(
      input ?? this.input,
      value ?? this.value,
      isValid ?? this.isValid,
      error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldContent<Input, Value> &&
          other.input == input &&
          other.value == value &&
          other.isValid == isValid &&
          other.error == error;

  @override
  int get hashCode => Object.hash(input, value, isValid, error);
}

/// Formatting-validation procedure return type for input of type `DateTime`.
///
/// Usage - format-validation of: `DateFieldBrick`.
typedef DateFieldContent = FieldContent<String, Date>;

/// Formatting-validation procedure return type for input of type `DateTime`.
///
/// Usage - format-validation of: `TimeFieldBrick` and its `..Range` fields.
typedef TimeFieldContent = FieldContent<String, Time>;

/// Formatting-validation procedure return type for input of type `DateTime`.
///
/// Usage - format-validation of: `DateTimeFieldBrick`.
typedef DateTimeFieldContent = FieldContent<String, DateTime>;
