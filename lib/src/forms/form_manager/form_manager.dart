import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/forms/base/form_field_descriptor.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

import '../base/form_brick.dart';
import 'form_status.dart';

abstract class FormManager extends ChangeNotifier {
  final ValueNotifier<String> errorMessageNotifier = ValueNotifier<String>('');
  final _formKey = GlobalKey<FormStateBrick>();
  final FormStateData _stateData;
  final FormSchema _schema;

  FormStatus checkStatus();

  Map<String, dynamic> collectInputs();

  FormManager({required FormStateData stateData, required FormSchema schema})
      : _stateData = stateData,
        _schema = schema {
    if (!_stateData.isInitialised) {
      resetForm();
    }
    String? error = getFieldError((_getFocusedKeyString()));
    _showErrorMessage(error);
  }

  void resetForm() {
    _schema.init(_stateData);
    _validate();
    _showErrorMessage(getFieldError(_getFocusedKeyString()));
  }

  GlobalKey<FormStateBrick> get formKey => _formKey;

  void registerField<T>(String keyString, T valueType) {
    final descriptor = _schema.descriptorsMap[keyString];
    if (descriptor == null) {
      throw ArgumentError('FormSchema does not contain a FormFieldDescriptor with keyString: "$keyString".');
    }
    if (descriptor.valueType != valueType) {
      throw ArgumentError(
          'Field\'s $keyString value Type must be the same as its Type declared in FormSchema -> FormFieldDescriptor.');
    }
  }

  dynamic getFieldValue(String keyString) => _getFieldStateData(keyString).value;

  void storeFieldValue(String keyString, dynamic value) => _getFieldStateData(keyString).value = value;

  String? getFieldError(String keyString) => _getFieldStateData(keyString).errorMessage;

  void setFieldError(String keyString, String? error) => _getFieldStateData(keyString).errorMessage = error;

  bool isFieldValid(String keyString) => _getFieldStateData(keyString).valid;

  void setFieldValid(String keyString, bool valid) => _getFieldStateData(keyString).valid = valid;

  FormatterValidatorChain? getFieldValidator(String keyString) => getFormatterValidator(keyString);

  Type getFieldValueType(String keyString) => _getValueRuntimeType(keyString);

  dynamic getInitialValue(String keyString) => _getFieldDescriptor(keyString).initialValue;

  FormatterValidatorChain? getFormatterValidator(String keyString) =>
      _getFieldDescriptor(keyString).formatterValidatorChain;

  Type _getValueRuntimeType(String keyString) => _getFieldDescriptor(keyString).valueType;

  FormFieldStateData _getFieldStateData(String keyString) {
    return _stateData.fieldStateDataMap[keyString]!;
  }

  FormFieldDescriptor _getFieldDescriptor(String keyString) {
    return _schema.descriptorsMap[keyString]!;
  }

  void _validate() {
    FormatterValidatorChain? formatterValidator;
    String? error;
    for (String keyString in _schema.descriptorsMap.keys) {
      formatterValidator = getFormatterValidator(keyString);
      error = formatterValidator?.run(_getFieldStateData(keyString).value);
      setFieldError(keyString, error);
    }
  }

  String _getFocusedKeyString() => _stateData.focusedKeyString;

  void onFieldChanged(String keyString, dynamic value) {
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
    String? error = getFormatterValidator(keyString)!.getError(value);
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
