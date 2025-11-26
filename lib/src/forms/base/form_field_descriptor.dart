import '../../inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

class FormFieldDescriptor<I, V> {
  final String keyString;
  final Type inputRuntimeType;
  final Type valueRuntimeType;
  final I? initialInput;
  final FormatterValidatorChain? formatterValidatorChain;

  // TODO what is valueType needed for? Redundant?

  // TODO guarantee validator chain adequate to field type - e.g. checkbox with date-validator throws

  FormFieldDescriptor({
    required this.keyString,
    this.initialInput,
    this.formatterValidatorChain,
  })  : inputRuntimeType = I,
        valueRuntimeType = V {
    assert(I != dynamic, "FormFieldDescriptor<I, V>: Generic type I must not be dynamic.");
    assert(V != dynamic, "FormFieldDescriptor<I, V>: Generic type V must not be dynamic.");
  }
}
