import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/imported_classes_from_tms/ui/inputs/text/uppercase_formatter.dart';
import 'package:flutter_form_bricks/imported_classes_from_tms/ui/inputs/text/vat_formatter.dart';

import '../../buttons/buttons.dart';
import '../../forms/form_manager/form_manager.dart';

import 'text_inputs_base/basic_text_input.dart';
import '../base/e_input_name_position.dart';
import '../base/double_widget_states_controller.dart';
import '../base/input_validator_provider.dart';
import 'first_upper_then_lower_case_formatter.dart';
import 'forbidden_whitespaces_formatter.dart';
import 'lowercase_formatter.dart';

class TextInputs {
  TextInputs._();

  static Widget textSimple({
    required final String keyString,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
    final String? initialValue,
    final bool readonly = false,
    final TextInputFormatter? inputFormatter,
    final FormFieldValidator<String>? validator,
    final ValueChanged<String?>? onChanged,
    final List<String>? linkedFields,
    final bool? withTextEditingController,
    final TextInputAction? textInputAction,
    final VoidCallback? onEditingComplete,
    final double? inputWidth,
  }) {
    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      formManager: formManager,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputWidth: inputWidth,
      initialValue: initialValue,
      readonly: readonly,
      inputFormatters: _mergeWithDefault(inputFormatter: inputFormatter),
      validator: validator,
      onChanged: onChanged,
      linkedFields: linkedFields,
      withTextEditingController: withTextEditingController,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
    );
  }

  static Widget textLowercase({
    required final String keyString,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
    final String? initialValue,
    final bool readonly = false,
    final FormFieldValidator<String>? validator,
    final ValueChanged<String?>? onChanged,
    final List<String>? linkedFields,
    final double? inputWidth,
    final bool? withTextEditingController,
    final TextInputAction? textInputAction,
    final VoidCallback? onEditingComplete,
  }) {
    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      formManager: formManager,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputWidth: inputWidth,
      initialValue: initialValue,
      readonly: readonly,
      inputFormatters: _mergeWithDefault(inputFormatter: LowercaseFormatter()),
      validator: validator,
      onChanged: onChanged,
      linkedFields: linkedFields,
      withTextEditingController: withTextEditingController,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
    );
  }

  static Widget textUppercase({
    required final String keyString,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
    final String? initialValue,
    final bool readonly = false,
    final FormFieldValidator<String>? validator,
    final ValueChanged<String?>? onChanged,
    final List<String>? linkedFields,
    final double? inputWidth,
    final bool? withTextEditingController,
    final TextInputAction? textInputAction,
    final VoidCallback? onEditingComplete,
  }) {
    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      formManager: formManager,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputWidth: inputWidth,
      initialValue: initialValue,
      readonly: readonly,
      inputFormatters: _mergeWithDefault(inputFormatter: UppercaseFormatter()),
      validator: validator,
      onChanged: onChanged,
      linkedFields: linkedFields,
      withTextEditingController: withTextEditingController,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
    );
  }

  static Widget textFirstUppercaseThenLowercase({
    required final String keyString,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
    final String? initialValue,
    final bool readonly = false,
    final FormFieldValidator<String>? validator,
    final ValueChanged<String?>? onChanged,
    final List<String>? linkedFields,
    final double? inputWidth,
    final bool? withTextEditingController,
    final TextInputAction? textInputAction,
    final VoidCallback? onEditingComplete,
  }) {
    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      formManager: formManager,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputWidth: inputWidth,
      initialValue: initialValue,
      readonly: readonly,
      inputFormatters: _mergeWithDefault(inputFormatter: FirstUpperThenLowerCaseFormatter()),
      validator: validator,
      onChanged: onChanged,
      linkedFields: linkedFields,
      withTextEditingController: withTextEditingController,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
    );
  }

  static Widget textVat({
    required final String keyString,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
    final String? initialValue,
    final bool readonly = false,
    final TextInputFormatter? inputFormatter,
    final ValueChanged<String?>? onChanged,
    final List<String>? linkedFields,
    final double? inputWidth,
    final TextInputAction? textInputAction,
    final VoidCallback? onEditingComplete,
  }) {
    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      formManager: formManager,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputWidth: inputWidth,
      initialValue: initialValue,
      readonly: readonly,
      inputFormatters: [UppercaseFormatter(), VatFormatter()],
      validator: ValidatorProvider.compose(isRequired: true, customValidator: ValidatorProvider.validatorVAT),
      onChanged: onChanged,
      withTextEditingController: true,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      linkedFields: linkedFields,
    );
  }

  static Widget textMultiline({
    required final String keyString,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
    final String? initialValue,
    final int? inputHeightMultiplier,
    final double? inputWidth,
    final FormFieldValidator<String>? validator,
    final bool? withTextEditingController,
    final TextInputAction? textInputAction,
    final VoidCallback? onEditingComplete,
  }) {
    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      formManager: formManager,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initialValue,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      inputWidth: inputWidth,
      inputHeightMultiplier: inputHeightMultiplier,
      validator: validator,
      withTextEditingController: withTextEditingController,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
    );
  }

  static Widget textMultilineWithButton({
    required final String keyString,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
    required final IconData iconData,
    required final void Function() onPressed,
    required final String tooltip,
    final String? initialValue,
    final int? inputHeightMultiplier,
    final double? inputWidth,
    final FormFieldValidator<String>? validator,
    final bool? withTextEditingController,
    final TextInputAction? textInputAction,
    final VoidCallback? onEditingComplete,
  }) {
    DoubleWidgetStatesController statesController = DoubleWidgetStatesController();

    final ValueListenableBuilder button = Buttons.iconButtonStateAware(
      iconData: iconData,
      tooltip: tooltip,
      onPressed: onPressed,
      statesController: statesController,
    );

    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      formManager: formManager,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initialValue,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      inputWidth: inputWidth,
      inputHeightMultiplier: inputHeightMultiplier,
      validator: validator,
      button: button,
      statesController: statesController,
      withTextEditingController: withTextEditingController,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
    );
  }

  static Widget textSecured({
    required String keyString,
    required String label,
    required EInputLabelPosition labelPosition,
    required FormManager formManager,
    required bool withTextEditingController,
    required FormFieldValidator<String> validator,
    String? initialValue,
    bool readonly = false,
    TextInputFormatter? inputFormatter,
    ValueChanged<String?>? onChanged,
    List<String>? linkedFields,
    double? inputSize,
    TextInputAction? textInputAction,
    VoidCallback? onEditingComplete,
  }) {
    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      formManager: formManager,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initialValue,
      readonly: readonly,
      inputFormatters: _mergeWithDefault(inputFormatter: inputFormatter),
      validator: validator,
      obscureText: true,
      maxLines: 1,
      expands: false,
      onChanged: onChanged,
      linkedFields: linkedFields,
      inputWidth: inputSize,
      withTextEditingController: withTextEditingController,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
    );
  }

  static List<TextInputFormatter> _mergeWithDefault({final TextInputFormatter? inputFormatter}) {
    return inputFormatter != null
        ? [ForbiddenWhitespacesFormatter(), inputFormatter]
        : [ForbiddenWhitespacesFormatter()];
  }
}
