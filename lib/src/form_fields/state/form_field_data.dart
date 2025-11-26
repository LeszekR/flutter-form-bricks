import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';

final class FormFieldData<I extends Object, V extends Object> {
  final Type inputRuntimeType;
  final Type valueRuntimeType;
  final FieldContent<I, V> fieldContent;
  final I? initialInput;
  final bool isValidating;

  const FormFieldData({
    required this.inputRuntimeType,
    required this.valueRuntimeType,
    required this.fieldContent,
    this.initialInput,
    this.isValidating = false,
  });

  factory FormFieldData.initial({
    required Type inputRuntimeType,
    required Type valueRuntimeType,
    I? initialInput,
  }) =>
      FormFieldData(
        inputRuntimeType: I,
        valueRuntimeType: V,
        fieldContent: FieldContent.of(initialInput),
      );

  FormFieldData<I, V> copyWith({
    bool? isValidating,
    FieldContent<I, V>? fieldContent,
  }) {
    return FormFieldData<I, V>(
      inputRuntimeType: inputRuntimeType,
      valueRuntimeType: valueRuntimeType,
      initialInput: initialInput,
      isValidating: isValidating ?? this.isValidating,
      fieldContent: fieldContent ?? this.fieldContent,
    );
  }

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
