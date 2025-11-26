import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/time_stamp.dart';

/// Represents the result of a formatting and validation operation performed by a `FormatterValidator`.
///
/// This class encapsulates:
/// - the **raw input** entered or visible in the UI,
/// - the **parsed value** of the desired output type,
/// - a flag indicating whether the value is valid,
/// - and an optional **error message** to display if invalid.
///
/// ### Why formatting and validation are combined
/// Formatting and validation are executed together to avoid redundant computation.
/// If formatting fails (e.g. an incomplete or malformed date), validation is skipped,
/// and a precise error message is returned early. If these were separate,
/// the input would have to be parsed and verified twice.
///
/// ### Generic Parameters:
/// - `Input`: The user-facing input type, e.g. `String`
/// - `Value`: The parsed output value type, e.g. `int`, `DateTime`, etc.
///
/// ### Field Notes:
/// - `input` – The UI-editable value (e.g. text in a `TextField`)
/// - `value` – The parsed, typed value (only set if parsing and validation succeed)
/// - `isValid` – Indicates whether the input was considered valid
/// - `error` – A user-visible error message, suitable for display in `InputDecoration.errorText` or similar
///
/// Used across field bricks where the internal content type differs from the parsed data type,
/// such as `DateFieldBrick`, `IntegerFieldBrick`, and `RadioBrick`.
class FieldContent<I extends Object, V extends Object> {
  final I? input;
  final V? value;
  final bool? isValid;
  final String? error;

  /// Creates `fieldContent`.
  const FieldContent.of(this.input, [this.value, this.isValid, this.error]);

  /// Only to be used as **temporary result** carrying transient state of the formatted input in formatting-validating
  /// procedure (e.g. partly formatted date string).
  /// **Never** to be used as a return value of `FormatterValidator`.
  const FieldContent.transient(I input) : this.of(input, null, null, null);

  /// Use in formatting-validating procedure when the result is valid.
  const FieldContent.ok(I? input, V? value) : this.of(input, value, true, null);

  /// Use in formatting-validating procedure when the result is invalid.
  const FieldContent.err(I? input, String? error) : this.of(input, null, false, error);

  /// Use wherever no result should be returned as a step of the multi-step format-validating procedure.
  const FieldContent.empty() : this.of(null, null, false, null);

  // TODO verify, refactor? - should use of named constructors vs copyWith - ?
  FieldContent<I, V> copyWith({
    I? input,
    V? value,
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
      other is FieldContent<I, V> &&
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
