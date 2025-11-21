import 'package:flutter/material.dart' hide RadioGroup;
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/choice/radio_group.dart';

import '../../forms/form_manager/form_manager_OLD.dart';
import '../text/text_input_base/basic_text_input.dart';
import 'checkbox_custom.dart';

enum ECheckboxShape { square, round }

class ChoiceInputs {
  ChoiceInputs._();

  static Widget checkbox({
    required String keyString,
    required String label,
    required bool labelLeftOfCheckbox,
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
    required String id,
    required String groupLabel,
    required bool labelOnTheLeft,
    required Map<String, String> options,
    final OptionsOrientation orientation = OptionsOrientation.vertical,
    double? width,
    final bool readonly = false,
    final FormFieldValidator<String>? validator,
    final FormManager? formManager,
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
    required String keyString,
    required String label,
    required Map<String, T> choices,
    final T? initialValue,
    final bool readonly = false,
    final bool required = false,
    final FormFieldValidator? validator,
    final FormManager? formManager,
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
              onChanged?.runChain(value);
              formManager?.onFieldChanged(keyString, value);
            },
      enabled: !readonly,
      focusNode: focusNode,
    );

    return SizedBox(width: 400.0, child: dropdown);
  }

  // static Widget popup<T extends Entity>({
  //   required String keyString,
  //   required String label,
  //   required List<T> choices,
  //   required BuildContext context,
  //   required FormManager formManager,
  //   final T? initialValue,
  //   final bool readonly = false,
  //   final bool required = false,
  //   final ValueChanged<String?>? onChanged,
  //   final List<String>? linkedFields,
  //   final double? inputSize,
  // }) {
  //   final validator = required ? FormBuilderValidators.required(errorText: "Wymagane") : null;
  //
  //   final TextEditingController controller = TextEditingController(text: initialValue?.shortDescription());
  //
  //   final chosenItem = SizedBox(
  //       width: 200,
  //       child: FormBuilderTextField(
  //         controller: controller,
  //         name: "${FormManager.ignoreFieldKey}.$keyString",
  //         // decoration: AppStyle.inputDecoration(label),
  //         readOnly: true,
  //         validator: validator,
  //       ));
  //
  //   final input = Visibility(
  //     visible: false,
  //     maintainState: true,
  //     child: BasicTextInput.basicTextInput(
  //       keyString: keyString,
  //       autovalidateMode: AutovalidateMode.disabled,
  //       label: label,
  //       labelPosition: LabelPosition.topLeft,
  //       initialValue: initialValue?.getId().toString(),
  //       readonly: readonly,
  //       validator: validator,
  //       formManager: formManager,
  //       onChanged: onChanged,
  //       linkedFields: linkedFields,
  //       inputWidth: inputSize,
  //     ),
  //   );
  //
  //   final button = IconButton(
  //     icon: const Icon(Icons.search_sharp),
  //     onPressed: () {
  //       formManager.formKey.currentState?.fields[keyString]?.focus();
  //       openPopupTable(context, form: EntityPopupForm(entities: choices)).then((value) {
  //         controller.text = value?.shortDescription() ?? "";
  //         formManager.onFieldChanged(keyString, value);
  //       });
  //     },
  //   );
  //   return Row(children: [chosenItem, input, button]);
  // }
  //
  // static Future<Entity?> openPopupTable({required BuildContext context, required EntityPopupForm form}) {
  //   return showDialog(context, barrierDismissible: false, builder: (BuildContext context) => form)
  //       .then((value) => value);
  // }
}
