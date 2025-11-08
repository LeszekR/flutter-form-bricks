import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/forms/base/form_schema.dart';
import 'package:flutter_form_bricks/src/forms/state/form_data.dart';
import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/state/form_field_data.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

import '../base/form_brick.dart';
import 'form_status.dart';

abstract class FormManager extends ChangeNotifier {
  final ValueNotifier<String> errorMessageNotifier = ValueNotifier<String>('');
  final FormData formData;
  final Map<String, FormatterValidatorChain?> formatterValidators;

  // TODO make flat map for tabbed form too and implement here
  FormStatus checkStatus();

  // TODO make flat map for tabbed form too and implement here
  Map<String, dynamic> collectInputs();

  GlobalKey<FormStateBrick> get formKey => formData.formKey;

  Map<String, FormFieldData> get fieldDataMap => formData.fieldDataMap;

  FormManager({required this.formData, required FormSchema formSchema})
      : formatterValidators = {
          for (final d in formSchema.descriptors) d.keyString: d.formatterValidatorChain,
        } {
    resetForm();
  }

  // form reset
  // ==============================================================================
  // TODO setState with new FormData after button 'Reset' clicked
  void resetForm() {
    for (String keyString in fieldDataMap.keys) {
      _resetField(keyString);
    }
    _validateForm();
    _showFocusedFieldError();
  }

  void _resetField(String keyString) {
    _updateFieldData(
      keyString,
      isValidating: false,
      fieldContent: FieldContent.of(fieldDataMap[keyString]!.initialInput),
    );
  }

  // fields registration in FormManager
  // ==============================================================================
  /// Obligatory for every field
  ///  - guarantees access to `FormatterValidatorChain`
  ///  - saves field's input, value, isValid and error in state preservation object: `FormData`.
  void registerField<T>(String keyString, Type T) {
    assert(
      fieldDataMap.keys.contains(keyString),
      'No "$keyString" found in fieldDataMap. All fields in form must be declared in FormSchema => FormFieldData.',
    );
    assert(
      T == _fieldData(keyString).initialInput.runtimeType,
      'Field value type is different from FieldData valueType for keyString: "$keyString".',
    );
  }

  void setFocusListener(FocusNode focusNode, String keyString) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _setFocusedKeyString(keyString);
        _showFieldErrorMessage(keyString);
      } else if (errorMessageNotifier.value != '') {
        _showFieldErrorMessage(null);
      }
    });
  }

  // getting and updating saved field state
  // ==============================================================================
  FieldContent getFieldContent(String keyString) => _fieldData(keyString).fieldContent;

  bool isFocusedOnStart(String keyString) => keyString == formData.focusedKeyString;

  dynamic getInitialInput(String keyString) => _fieldData(keyString).initialInput;

  dynamic getFieldValue(String keyString) => getFieldContent(keyString).value;

  bool isFieldValidating(String keyString) => _fieldData(keyString).isValidating;

  void setFieldValidating(String keyString, bool isValidating) =>
      _updateFieldData(keyString, isValidating: isValidating);

  bool isFieldValid(String keyString) => getFieldContent(keyString).error == null;

  bool isFieldDirty(String keyString) => getFieldContent(keyString).input != _fieldData(keyString).initialInput;

  FormatterValidatorChain? getFormatterValidator(String keyString) => formatterValidators[keyString];

  void _setFocusedKeyString(String keyString) => formData.focusedKeyString = keyString;

  void _storeFieldContent(String keyString, FieldContent fieldContent) =>
      _updateFieldData(keyString, fieldContent: fieldContent);

  /// `FormManager` will throw on any unregistered field's attempt to access it.
  FormFieldData _fieldData(String keyString) {
    return fieldDataMap[keyString]!;
  }

  void _updateFieldData(String keyString, {bool? isValidating, FieldContent? fieldContent}) {
    assert((isValidating != null) || (fieldContent != null));
    fieldDataMap[keyString] = fieldDataMap[keyString]!.copyWith(isValidating: isValidating, fieldContent: fieldContent);
  }

  // validation
  // ==============================================================================
  FieldContent onFieldChanged(String keyString, dynamic input) {
    FieldContent fieldContent = formatAndValidateQuietly(keyString, input);
    _showFieldErrorMessage(keyString);
    return fieldContent;
  }

  FieldContent formatAndValidateQuietly(String keyString, dynamic input) {
    FieldContent fieldContent;
    FormatterValidatorChain? formatterValidator = getFormatterValidator(keyString);

    if (formatterValidator != null) {
      fieldContent = formatterValidator.run(input);
    } else {
      fieldContent = FieldContent.ok(input, input);
    }

    _storeFieldContent(keyString, fieldContent);
    return fieldContent;
  }

  bool isFormValid() {
    for (FormFieldData data in fieldDataMap.values) {
      if (data.fieldContent.error != null) {
        return false;
      }
    }
    return true;
  }

  void _validateForm() {
    FormatterValidatorChain? formatterValidator;
    FieldContent fieldContent;

    for (String keyString in fieldDataMap.keys) {
      formatterValidator = getFormatterValidator(keyString);
      if (formatterValidator == null) continue;

      fieldContent = formatterValidator.run(getFieldContent(keyString));
      _storeFieldContent(keyString, fieldContent);
    }
  }

  // showing error message
  // ==============================================================================
  void _showFieldErrorMessage(String? keyString) {
    String error = (keyString == null) ? '' : (getFieldContent(keyString).error ?? '');
    errorMessageNotifier.value = error;
  }

  void _showFocusedFieldError() {
    String? focusedKeyString = formData.focusedKeyString;
    if (focusedKeyString == null) return;
    _showFieldErrorMessage(formData.focusedKeyString);
  }

  // collecting values
  // ==============================================================================
  FormStatus getFormPartState(GlobalKey<FormStateBrick> formPartKey) {
    // TODO uncomment and refactor
    // final currentState = formPartKey.currentState;
    // if (currentState == null) {
    //   return EFormStatus.invalid;
    // }
    //
    // currentState.save();
    // var fieldValuesList = currentState.value.entries;
    //
    // // TODO check where disabled fields are excluded - if nowhere then do it here
    // var activeFields = fieldValuesList;
    // // var activeFields = fieldValuesList.where((field) => !_isFieldIgnored(field.key));
    //
    // if (activeFields.any((field) => !findField(field.key)!.isStringValid)) {
    //   return EFormStatus.invalid;
    // }
    // if (activeFields.every((input) => input.value == _inputInitialValuesMap[input.key])) {
    //   return EFormStatus.noChange;
    // }
    return FormStatus.valid;
  }

  Map<String, dynamic> collectInputData() {
    return collectInputs().map((keyString, _) => MapEntry(keyString, _parseDataFromInput(getFieldValue(keyString))));
  }

  dynamic _parseDataFromInput(value) {
    if (value == null) {
      return value;
    }
    if (value is! String) {
      return value;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
