import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_input_base/formatter_validator_defaults.dart';

class FormFieldDescriptor<I extends Object, V extends Object> {
  final String keyString;
  final Type inputRuntimeType = I;
  final Type valueRuntimeType = V;
  final I? initialInput;
  final bool? isFocusedOnStart;
  final FormatterValidatorListMaker<I, V>? defaultFormatterValidatorListMaker;
  final FormatterValidatorListMaker<I, V>? addFormatterValidatorListMaker;

  // TODO guarantee validator chain adequate to field type - e.g. checkbox with date-validator throws

  FormFieldDescriptor({
    required this.keyString,
    this.initialInput,
    this.isFocusedOnStart,
    this.defaultFormatterValidatorListMaker,
    this.addFormatterValidatorListMaker,
  })  : assert(I != dynamic, "FormFieldDescriptor<I, V>: Generic type I must not be dynamic."),
        assert(V != dynamic, "FormFieldDescriptor<I, V>: Generic type V must not be dynamic.");

  static FormatterValidatorChainFullRun<I, V>? makeFormatterValidatorChain<I extends Object, V extends Object>(
      FormFieldDescriptor<I, V> d) {
    final List<FormatterValidator<I, V>>? defaultFormatterValidatorList =
        d.defaultFormatterValidatorListMaker == null ? null : d.defaultFormatterValidatorListMaker!();
    final List<FormatterValidator<I, V>>? addFormatterValidatorList =
        d.addFormatterValidatorListMaker == null ? null : d.addFormatterValidatorListMaker!();

    if (defaultFormatterValidatorList != null && addFormatterValidatorList != null) {
      defaultFormatterValidatorList.addAll(addFormatterValidatorList);
      return FormatterValidatorChainFullRun<I, V>(defaultFormatterValidatorList);
    }
    if (addFormatterValidatorList != null) {
      return FormatterValidatorChainFullRun(addFormatterValidatorList);
    }
    if (defaultFormatterValidatorList != null) {
      // TU PRZERWAŁEM - fix: Invalid argument(s): FormatterValidator inputType String != Object.
      return FormatterValidatorChainFullRun(defaultFormatterValidatorList);
    }
    return null;
  }
}
