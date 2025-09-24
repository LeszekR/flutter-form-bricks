import '../../inputs/text/format_and_validate/formatter_validator_chain.dart';

class FormFieldDescriptor<T> {
  final String keyString;
  final T? initialValue;
  final FormatterValidatorChain? formatterValidatorChain;

  const FormFieldDescriptor(this.keyString, this.initialValue, this.formatterValidatorChain);
}
