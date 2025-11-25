import '../../inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

class FormFieldDescriptor<I, V> {
  final String keyString;
  final I? initialInput;
  final FormatterValidatorChain? formatterValidatorChain;

  // TODO what is valueType needed for? Redundant?

  // TODO guarantee validator chain adequate to field type - e.g. checkbox with date-validator throws

  const FormFieldDescriptor(this.keyString, [this.initialInput, this.formatterValidatorChain]);

  Type get inputRuntimeType => I;

  Type get valueRuntimeType => V;
}
