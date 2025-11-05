import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/forms/base/form_schema.dart';
import 'package:flutter_form_bricks/src/forms/state/form_data.dart';
import 'package:flutter_form_bricks/src/inputs/state/form_field_data.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

import '../base/form_brick.dart';
import 'form_status.dart';

abstract class FormManager extends ChangeNotifier {
  final ValueNotifier<String> errorMessageNotifier = ValueNotifier<String>('');
  final _formKey = GlobalKey<FormStateBrick>();
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

  GlobalKey<FormStateBrick> get formKey => _formKey;

  void resetForm() {
    // TODO solve setState with reset values in all fields
    for (FormFieldData data in formData.fieldDataMap.values) {
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
    data.value = data.initialValue;
    data.validating = false;
    data.errorMessage = null;
  }

  void registerField<T>(String keyString, Type T) {
    assert(formData.fieldDataMap.keys.contains(keyString),
        'FormData does not contain FormFieldData with keyString: "$keyString".');
    assert(T ==  _getFieldValueType(keyString),
        'Field value type is different from FieldData valueType for keyString: "$keyString".');
  }

  Type _getFieldValueType(String keyString) => _getFieldData(keyString).initialValue.runtimeType;

  void storeFieldValue(String keyString, dynamic value) => _getFieldData(keyString).value = value;

  dynamic getFieldValue(String keyString) => _getFieldData(keyString).value;

  void setFieldError(String keyString, String? error) => _getFieldData(keyString).errorMessage = error;

  String? getFieldError(String keyString) => _getFieldData(keyString).errorMessage;

  dynamic getInitialValue(String keyString) => _getFieldData(keyString).initialValue;

  bool isFieldValidating(String keyString) => _getFieldData(keyString).validating;

  bool isFieldValid(String keyString) => _getFieldData(keyString).errorMessage == null;

  bool isFieldDirty(String keyString) => _getFieldData(keyString).value != getInitialValue(keyString);

  bool hasFocusOnStart(String keyString) => keyString == formData.focusedKeyString;

  FormatterValidatorChain? getFormatterValidatorChain(String keyString) => formatterValidators[keyString];

  FormatterValidatorChain? getFieldValidator(String keyString) => getFormatterValidatorChain(keyString);

  FormFieldData _getFieldData(String keyString) {
    return formData.fieldDataMap[keyString]!;
  }

  void setFocusListener(FocusNode focusNode, String keyString) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showFieldErrorMessage(keyString);
      }
    });
  }

  void _validateForm() {
    FormatterValidatorChain? formatterValidator;
    String? error;
    for (String keyString in formData.fieldDataMap.keys) {
      formatterValidator = getFormatterValidatorChain(keyString);
      error = formatterValidator?.run(_getFieldData(keyString).value);
      setFieldError(keyString, error);
    }
  }

  void onFieldChanged(String keyString, dynamic value, String? error) {
    storeFieldValue(keyString, value);
    _validateField(keyString);
    // TODO uncomment and refactor
    // var field = findField(keyString);
    // if (!(field?.isTouched ?? false)) {
    //   return;
    // }
    //
    // // sets state of the field with new value
    // // validates the field
    // // calls rebuild of all fields in the form
    // // if the form autoValidateMode is "always" or "onUserInteraction" revalidates all fields in the form
    // formKey.currentState?.fields[keyString]?.didChange(value ?? field?.value);
    //
    // validateField(keyString);
    // afterFieldChanged();
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
  String? validateFieldQuietly(String keyString) {
    dynamic value = getFieldValue(keyString);
    String? error = getFormatterValidatorChain(keyString)!.getError(value);
    setFieldError(keyString, error);
    return error;
  }

  void _validateField(String keyString) {
    String? errorText = validateFieldQuietly(keyString);
    _showErrorMessage(errorText);
  }

// show error message functionality
// ==============================================================================
  void showFieldErrorMessage(String keyString) {
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
