import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/input_value_error.dart';

final class FormFieldData<I, V> {
  final I? initialInput;
  final bool isValidating;
  final InputValueError<I, V> inputValueError;

  const FormFieldData({
    this.initialInput,
    this.isValidating = false,
    required this.inputValueError,
  });

  factory FormFieldData.initial(I? input) => FormFieldData(inputValueError: InputValueError.of(input));

  FormFieldData<I, V> copyWith({
    I? input,
    V? value,
    bool? isValid,
    String? error,
    bool? isValidating,
  }) {
    return FormFieldData<I, V>(
      initialInput: initialInput,
      isValidating: isValidating ?? this.isValidating,
      inputValueError: InputValueError.of(
        input ?? inputValueError.input,
        value ?? inputValueError.value,
        isValid ?? inputValueError.isValid,
        error ?? inputValueError.error,
      ),
    );
  }

  bool get dirty => inputValueError.input != initialInput;

  bool get valid => inputValueError.isValid ?? false;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is FormFieldData<I, V> &&
        other.initialInput == initialInput &&
        other.isValidating == isValidating &&
        other.inputValueError == inputValueError;
  }

  @override
  int get hashCode => Object.hash(initialInput, isValidating, inputValueError);
}
