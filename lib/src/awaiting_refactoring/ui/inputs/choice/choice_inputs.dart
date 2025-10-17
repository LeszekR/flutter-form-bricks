import 'package:flutter/material.dart' hide RadioGroup;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shipping_ui/ui/inputs/choice/radio_group.dart';

import '../../../config/objects/abstracts/entity.dart';
import '../../forms/base/entity_popup_form.dart';
import '../../forms/form_manager/form_manager.dart';
import '../base/e_input_name_position.dart';
import '../text/text_inputs_base/basic_text_input.dart';
import 'checkbox_custom.dart';

enum ECheckboxShape { square, round }

class ChoiceInputs {
  ChoiceInputs._();

  static Widget checkbox({
    required final String keyString,
    required final String label,
    required final bool labelLeftOfCheckbox,
    bool? valueControllingVar,
    final ValueChanged<bool?>? onChanged,
    final ECheckboxShape shape = ECheckboxShape.square,
    final bool readOnly = false,
    final double? width,
  }) {
    return CheckboxCustom(
      key: Key(keyString),
      keyString: keyString,
      label: label,
      initialValue: valueControllingVar,
      labelLeftOfCheckbox: labelLeftOfCheckbox,
      onChanged: onChanged,
      shapeType: shape,
      readOnly: readOnly,
      width: width,
    );
  }

  static Widget radio({
    required final String id,
    required final String groupLabel,
    required final bool labelOnTheLeft,
    required final Map<String, String> options,
    final OptionsOrientation orientation = OptionsOrientation.vertical,
    double? width,
    final bool readonly = false,
    final FormFieldValidator<String>? validator,
    final FormManagerOLD? formManager,
    final ValueChanged<String?>? onChanged,
  }) {
    return RadioGroup(
      groupLabel: groupLabel,
      labelOnLeft: labelOnTheLeft,
      options: options,
      width: width,
      readonly: readonly,
    );
  }

  /// Important! T must implement equals in order for this to work!
  static Widget dropdown<T>({
    required final String keyString,
    required final String label,
    required final Map<String, T> choices,
    final T? initialValue,
    final bool readonly = false,
    final bool required = false,
    final FormFieldValidator? validator,
    final FormManagerOLD? formManager,
    final TextEditingController? textEditingController,
    final FocusNode? focusNode,
    final ValueChanged<T?>? onChanged,
  }) {
    // formManager.addInputLabelMapping(keyString/*, label*/);

    final dropdownItems =
        choices.entries.map((entry) => DropdownMenuItem<T>(value: entry.value, child: Text(entry.key))).toList();

    final dropdown = FormBuilderDropdown<T>(
      name: keyString,
      initialValue: initialValue,
      items: dropdownItems,
      validator: validator,
      onChanged: readonly
          ? null
          : (value) {
              onChanged?.call(value);
              formManager?.onFieldChanged(keyString, value);
            },
      enabled: !readonly,
      focusNode: focusNode,
    );

    return SizedBox(width: 400.0, child: dropdown);
  }

  static Widget popup<T extends Entity>({
    required final String keyString,
    required final String label,
    required final List<T> choices,
    required final BuildContext context,
    required final FormManagerOLD formManager,
    final T? initialValue,
    final bool readonly = false,
    final bool required = false,
    final ValueChanged<String?>? onChanged,
    final List<String>? linkedFields,
    final double? inputSize,
  }) {
    final validator = required ? FormBuilderValidators.required(errorText: "Wymagane") : null;

    final TextEditingController controller = TextEditingController(text: initialValue?.shortDescription());

    final chosenItem = SizedBox(
        width: 200,
        child: FormBuilderTextField(
          controller: controller,
          name: "${FormManagerOLD.ignoreFieldKey}.$keyString",
          // decoration: AppStyle.inputDecoration(label),
          readOnly: true,
          validator: validator,
        ));

    final input = Visibility(
      visible: false,
      maintainState: true,
      child: BasicTextInput.basicTextInput(
        keyString: keyString,
        autovalidateMode: AutovalidateMode.disabled,
        label: label,
        labelPosition: ELabelPosition.topLeft,
        initialValue: initialValue?.getId().toString(),
        readonly: readonly,
        validator: validator,
        formManager: formManager,
        onChanged: onChanged,
        linkedFields: linkedFields,
        inputWidth: inputSize,
      ),
    );

    final button = IconButton(
      icon: const Icon(Icons.search_sharp),
      onPressed: () {
        formManager.formKey.currentState?.fields[keyString]?.focus();
        openPopupTable(context: context, form: EntityPopupForm(entities: choices)).then((value) {
          controller.text = value?.shortDescription() ?? "";
          formManager.onFieldChanged(keyString, value);
        });
      },
    );
    return Row(children: [chosenItem, input, button]);
  }

  static Future<Entity?> openPopupTable({required final BuildContext context, required final EntityPopupForm form}) {
    return showDialog(context: context, barrierDismissible: false, builder: (final BuildContext context) => form)
        .then((value) => value);
  }
}
