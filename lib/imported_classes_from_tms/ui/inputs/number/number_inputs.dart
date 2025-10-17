import 'package:flutter/material.dart';

import '../../forms/form_manager/form_manager.dart';
import '../base/e_input_name_position.dart';
import '../base/input_validator_provider.dart';
import '../text/text_inputs_base/basic_text_input.dart';
import 'decimal_formatter.dart';
import 'integer_formatter.dart';
import 'number_validators.dart';

class NumberInputs {
  NumberInputs._();

  static Widget id({
    required final FormManager formManager,
    required final int? initialValue,
    required final EInputLabelPosition labelPosition,
    final String keyString = "id",
    final String label = "ID",
  }) {
    final id = BasicTextInput.basicTextInput(
        keyString: keyString,
        label: label,
        labelPosition: labelPosition,
        formManager: formManager,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        readonly: true,
        initialValue: initialValue,
        valueTransformer: (val) => intTransformer(val),
        inputWidth: AppSize.inputNumberWidth);

    return Opacity(
      opacity: 0,
      child: id,
    );
  }

  static Widget textInteger(
      {required final String keyString,
      required final String label,
      required final EInputLabelPosition labelPosition,
      required final FormManager formManager,
      final int? initialValue,
      final bool readonly = false,
      final FormFieldValidator<String>? validator,
      final double? inputSize,
      final VoidCallback? onEditingComplete,
      // final TextEditingController? textEditingController,
      // final FocusNode? focusNode,
      final TextInputAction? textInputAction}) {
    //
    var integerValidator = NumberValidators.integerValidator();

    return BasicTextInput.basicTextInput(
      formManager: formManager,
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initialValue,
      //initialValue?.toString() ?? "",
      readonly: readonly,
      keyboardType: TextInputType.number,
      validator: validator != null
          ? ValidatorProvider.compose(validatorsList: [validator, integerValidator])
          : integerValidator,
      inputFormatters: [IntegerInputFormatter()],
      valueTransformer: (val) => intTransformer(val),
      inputWidth: inputSize,
      withTextEditingController: true,
      textInputAction: textInputAction ?? TextInputAction.none,
      onEditingComplete: onEditingComplete ?? () {},
    );
  }

  static int? intTransformer(final String? input) {
    if (input == null || input.isEmpty) {
      return null;
    }
    return int.tryParse(input.replaceAll(" ", ""));
  }

  static textDouble(
      {required final String keyString,
      required final String label,
      required final EInputLabelPosition labelPosition,
      required final FormManager formManager,
      final double? initialValue,
      final int decimalPoints = 2,
      final bool readonly = false,
      final FormFieldValidator<String>? validator,
      final double? inputSize,
      final VoidCallback? onEditingComplete,
      // final TextEditingController? textEditingController,
      // final FocusNode? focusNode,
      final TextInputAction? textInputAction}) {
    //
    final decimalValidator = NumberValidators.decimalValidator(decimalPoints);

    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      formManager: formManager,
      initialValue: initialValue,
      //initialValue?.toString() ?? "",
      readonly: readonly,
      keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
      validator: validator != null
          ? ValidatorProvider.compose(validatorsList: [validator, decimalValidator])
          : decimalValidator,
      inputFormatters: [DoubleInputFormatter()],
      valueTransformer: (val) => _decimalTransformer(val),
      inputWidth: inputSize,
      withTextEditingController: true,
      textInputAction: textInputAction ?? TextInputAction.none,
      onEditingComplete: onEditingComplete ?? () {},
    );
  }

  static double? _decimalTransformer(final String? input) {
    if (input == null || input.isEmpty) {
      return null;
    }
    return double.tryParse(input.replaceAll(" ", ""));
  }
}
