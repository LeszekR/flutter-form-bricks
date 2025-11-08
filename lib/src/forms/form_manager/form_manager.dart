import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/forms/base/form_schema.dart';
import 'package:flutter_form_bricks/src/forms/state/form_data.dart';
import 'package:flutter_form_bricks/src/inputs/state/form_field_data.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/input_value_error.dart';

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

  FormManager({required this.formData, required FormSchema formSchema})
      : formatterValidators = {
          for (final d in formSchema.descriptors) d.keyString: d.formatterValidatorChain,
        } {
    resetForm();
  }

  GlobalKey<FormStateBrick> get formKey => formData.formKey;

  Map<String, FormFieldData> get fieldDataMap => formData.fieldDataMap;

  void resetForm() {
    // TODO solve setState with reset values in all fields
    for (FormFieldData data in fieldDataMap.values) {
      _resetField(data);
    }
    _validateForm();
    _showFocusedFieldError();
  }

  void _showFocusedFieldError() {
    String? focusedKeyString = formData.focusedKeyString;
    if (focusedKeyString == null) return;
    _showErrorMessage(getFieldError(formData.focusedKeyString!));
  }

  void _resetField(FormFieldData data) {
    data.value = data.initialInput;
    data.validating = false;
    data.error = null;
  }

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

  String? getFocusedKeyString() => formData.focusedKeyString;

  void setFocusedKeyString(String keyString) => formData.focusedKeyString = keyString;

  Type _getFieldValueType(String keyString) => _fieldData(keyString).initialInput.runtimeType;

  void storeFieldValue(String keyString, dynamic value) => _fieldData(keyString).value = value;

  dynamic getFieldValue(String keyString) => _fieldData(keyString).value;

  void storeFieldError(String keyString, String? error) => _fieldData(keyString).error = error;
  
  void storeFieldInputValueError(String keyString, InputValueError inputValueError) {
    _fieldData(keyString).input = inputValueError.input;
    _fieldData(keyString).value = inputValueError.value;
    _fieldData(keyString).error = inputValueError.error;
  }

  String? getFieldError(String keyString) => _fieldData(keyString).error;

  dynamic getInitialValue(String keyString) => _fieldData(keyString).initialInput;

  bool isFieldValidating(String keyString) => _fieldData(keyString).validating;

  bool isFieldValid(String keyString) => _fieldData(keyString).error == null;

  bool isFieldDirty(String keyString) => _fieldData(keyString).value != getInitialValue(keyString);

  bool hasFocusOnStart(String keyString) => keyString == formData.focusedKeyString;

  FormatterValidatorChain? getFormatterValidatorChain(String keyString) => formatterValidators[keyString];

  FormatterValidatorChain? getFieldValidator(String keyString) => getFormatterValidatorChain(keyString);

  /// Obligatory for any field planning to get its `FormatterValidatorChain`, save its value and error in `FormManager`.
  /// `FormManager` will throw on any unregistered field's attempt to access it.
  FormFieldData _fieldData(String keyString) {
    return fieldDataMap[keyString]!;
  }

  void setFocusListener(FocusNode focusNode, String keyString) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _showErrorMessage(getFieldError(keyString) ?? '');
      }
    });
  }

  void _validateForm() {
    FormatterValidatorChain? formatterValidator;
    InputValueError valueAndError;

    for (String keyString in fieldDataMap.keys) {
      formatterValidator = getFormatterValidatorChain(keyString);
      if (formatterValidator == null) continue;

      valueAndError = formatterValidator.run(_fieldData(keyString).value);
      storeFieldError(keyString, valueAndError.error);
    }
  }

  bool isFormValid() {
    for (FormFieldData data in fieldDataMap.values) {
      if (data.error != null) {
        return false;
      }
    }
    return true;
  }

  void onFieldChanged(String keyString, InputValueError valueAndError) {
    storeFieldValue(keyString, valueAndError.input);
    storeFieldError(keyString, valueAndError.error);
  }

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

// field validation functionality
// ==============================================================================
  InputValueError? formatAndValidateQuietly(String keyString) {
    dynamic value = getFieldValue(keyString);
    InputValueError inputValueError = getFormatterValidatorChain(keyString)!.run(value);
    storeFieldError(keyString, inputValueError);
    return error;
  }

  void formatAndValidate(String keyString) {
    String? errorText = formatAndValidateQuietly(keyString);
    _showErrorMessage(errorText);
  }

// show error message functionality
// ==============================================================================
  void _showFieldErrorMessage(String keyString) {
    _showErrorMessage(getFieldError(keyString) ?? '');
  }

  void _showErrorMessage(String? errorText) {
    errorMessageNotifier.value = errorText ?? '';
  }

// data collection functionality
// ==============================================================================
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
