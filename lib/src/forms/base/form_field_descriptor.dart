import '../../inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

class FormFieldDescriptor<T> {
  final String keyString;
  final T? initialValue;
  final FormatterValidatorChain? formatterValidatorChain;

  // T  ODO guarantee validator chain adequate to field type - e.g. checkbox with date-validator throws

  const FormFieldDescriptor(this.keyString, [this.initialValue, this.formatterValidatorChain]);

  Type get valueType => T;
}
