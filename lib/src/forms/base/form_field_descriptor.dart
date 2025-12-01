
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

class FormFieldDescriptor<I extends Object, V extends Object> {
  final String keyString;
  final Type inputRuntimeType;
  final Type valueRuntimeType;
  final I? initialInput;
  final bool? isFocusedOnStart;
  final FormatterValidatorChain Function()? formatterValidatorChainBuilder;

  // TODO guarantee validator chain adequate to field type - e.g. checkbox with date-validator throws

  FormFieldDescriptor({
    required this.keyString,
    this.initialInput,
    this.isFocusedOnStart,
    this.formatterValidatorChainBuilder,
  })  : inputRuntimeType = I,
        valueRuntimeType = V {
    assert(I != dynamic, "FormFieldDescriptor<I, V>: Generic type I must not be dynamic.");
    assert(V != dynamic, "FormFieldDescriptor<I, V>: Generic type V must not be dynamic.");
  }
}
