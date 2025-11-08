import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';

final class FormFieldData<I, V> {
  final I? initialInput;
  final bool isValidating;
  final FieldContent<I, V> fieldContent;

  const FormFieldData({
    this.initialInput,
    this.isValidating = false,
    required this.fieldContent,
  });

  factory FormFieldData.initial(I? input) => FormFieldData(fieldContent: FieldContent.of(input));

  FormFieldData<I, V> copyWith({
    bool? isValidating,
    FieldContent<I, V>? fieldContent,
  }) {
    return FormFieldData<I, V>(
      initialInput: initialInput,
      isValidating: isValidating ?? this.isValidating,
      fieldContent: fieldContent ?? this.fieldContent,
    );
  }

  // FormFieldData<I, V> copyWith({
  //   I? input,
  //   V? value,
  //   bool? isValid,
  //   String? error,
  //   bool? isValidating,
  // }) {
  //   return FormFieldData<I, V>(
  //     initialInput: initialInput,
  //     isValidating: isValidating ?? this.isValidating,
  //     fieldContent: fieldContent.of(
  //       input ?? fieldContent.input,
  //       value ?? fieldContent.value,
  //       isValid ?? fieldContent.isValid,
  //       error ?? fieldContent.error,
  //     ),
  //   );
  // }

  bool get dirty => fieldContent.input != initialInput;

  bool get valid => fieldContent.isValid ?? false;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is FormFieldData<I, V> &&
        other.initialInput == initialInput &&
        other.isValidating == isValidating &&
        other.fieldContent == fieldContent;
  }

  @override
  int get hashCode => Object.hash(initialInput, isValidating, fieldContent);
}
