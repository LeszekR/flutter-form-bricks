import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/text/text_input_base/basic_text_input.dart';
import 'package:flutter_form_bricks/src/form_fields/states_controller/double_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/text/first_upper_then_lower_case_formatter.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/text/forbidden_whitespaces_formatter.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/text/lowercase_formatter.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/text/uppercase_formatter.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/text/vat_formatter.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';

import '../../../../../shelf.dart';
import '../../buttons/buttons.dart';
import '../../forms/form_manager/form_manager_OLD.dart';

class TextInputs {
  TextInputs._();

  static Widget textSimple({
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManager formManager,
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
      context: context,
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
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManager formManager,
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
      context: context,
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      formManager: formManager,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputWidth: inputWidth,
      initialValue: initialValue,
      readonly: readonly,
      inputFormatters: null, //_mergeWithDefault(inputFormatter: LowercaseFormatter()),
      validator: validator,
      onChanged: onChanged,
      linkedFields: linkedFields,
      withTextEditingController: withTextEditingController,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
    );
  }

  static Widget textUppercase({
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManager formManager,
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
      context: context,
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
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManager formManager,
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
      context: context,
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
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManager formManager,
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
      context: context,
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      formManager: formManager,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputWidth: inputWidth,
      initialValue: initialValue,
      readonly: readonly,
      inputFormatters: [UppercaseFormatter(), VatFormatter()],
      validator: ValidatorProvider.compose(
        context: context,
        isRequired: true,
        customValidator: ValidatorProvider.validatorVAT(BricksLocalizations.of(context)),
      ),
      onChanged: onChanged,
      withTextEditingController: true,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      linkedFields: linkedFields,
    );
  }

  static Widget textMultiline({
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManager formManager,
    final String? initialValue,
    final int? inputHeightMultiplier,
    final double? inputWidth,
    final FormFieldValidator<String>? validator,
    final bool? withTextEditingController,
    final TextInputAction? textInputAction,
    final VoidCallback? onEditingComplete,
  }) {
    return BasicTextInput.basicTextInput(
      context: context,
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
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManager formManager,
    required IconData iconData,
    required void Function() onPressed,
    required String tooltip,
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
      context: context,
      iconData: iconData,
      tooltip: tooltip,
      onPressed: onPressed,
      statesController: statesController,
    );

    return BasicTextInput.basicTextInput(
      context: context,
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
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
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
      context: context,
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
