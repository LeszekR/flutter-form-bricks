import '../../inputs/text/format_and_validate/formatter_validator_chain.dart';

class BrickFieldDescriptor<T> {
  final String keyString;
  final T? initialValue;
  final FormatterValidatorChain? formatterValidatorChain;

  const BrickFieldDescriptor(this.keyString, this.initialValue, this.formatterValidatorChain);
}
