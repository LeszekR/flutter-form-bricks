import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/base/form_field_brick.dart';

final class FormFieldData<I extends Object, V extends Object, F extends FormFieldBrick<I, V>> {
  // final Type inputRuntimeType;
  // final Type valueRuntimeType;
  final Type fieldType;
  final FieldContent<I, V> fieldContent;
  final I? initialInput;
  final bool isValidating;

  FormFieldData({
    // required this.inputRuntimeType,
    // required this.valueRuntimeType,
    required this.fieldType,
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
        // inputRuntimeType: I,
        // valueRuntimeType: V,
        fieldType: F,
        fieldContent: FieldContent.of(initialInput),
      );

  FormFieldData<I, V, F> copyWith({
    bool? isValidating,
    FieldContent<I, V>? fieldContent,
  }) {
    return FormFieldData<I, V, F>(
      // inputRuntimeType: inputRuntimeType,
      // valueRuntimeType: valueRuntimeType,
      fieldType: fieldType,
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

    return other is FormFieldData<I, V, F> &&
        other.initialInput == initialInput &&
        other.isValidating == isValidating &&
        other.fieldContent == fieldContent;
  }

  @override
  int get hashCode => Object.hash(initialInput, isValidating, fieldContent);
}
