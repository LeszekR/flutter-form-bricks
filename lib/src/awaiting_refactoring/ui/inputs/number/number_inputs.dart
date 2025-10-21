import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

import '../../forms/form_manager/form_manager.dart';
import 'decimal_formatter.dart';
import 'integer_formatter.dart';
import 'number_validators.dart';

class NumberInputs {
  NumberInputs._();

  static Widget id({
    required BuildContext context,
    required FormManagerOLD formManager,
    required int? initialValue,
    required LabelPosition labelPosition,
    final String keyString = "id",
    final String label = "ID",
  }) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;

    final id = BasicTextInput.basicTextInput(
        context: context,
        keyString: keyString,
        label: label,
        labelPosition: labelPosition,
        formManager: formManager,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        readonly: true,
        initialValue: initialValue,
        valueTransformer: (val) => intTransformer(val),
        inputWidth: appSize.textFieldWidth);

    return Opacity(
      opacity: 0,
      child: id,
    );
  }

  static Widget textInteger(
      {required BuildContext context,
      required String keyString,
      required String label,
      required LabelPosition labelPosition,
      required FormManagerOLD formManager,
      final int? initialValue,
      final bool readonly = false,
      final FormFieldValidator<String>? validator,
      final double? inputSize,
      final VoidCallback? onEditingComplete,
      // final TextEditingController? textEditingController,
      // final FocusNode? focusNode,
      final TextInputAction? textInputAction}) {
    //
    var integerValidator = NumberValidators.integerValidator(BricksLocalizations.of(context));

    return BasicTextInput.basicTextInput(
      context: context,
      formManager: formManager,
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initialValue,
      readonly: readonly,
      keyboardType: TextInputType.number,
      validator: validator != null
          ? ValidatorProvider.compose(context: context, validatorsList: [validator, integerValidator])
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
      {required BuildContext context,
      required String keyString,
      required String label,
      required LabelPosition labelPosition,
      required FormManagerOLD formManager,
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
    final decimalValidator = NumberValidators.decimalValidator(BricksLocalizations.of(context), decimalPoints);

    return BasicTextInput.basicTextInput(
      context: context,
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      formManager: formManager,
      initialValue: initialValue,
      readonly: readonly,
      keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
      validator: validator != null
          ? ValidatorProvider.compose(context: context, validatorsList: [validator, decimalValidator])
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
