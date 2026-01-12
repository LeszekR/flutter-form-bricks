import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';

abstract class FormManager extends ChangeNotifier {
  @visibleForTesting
  final ValueNotifier<String> errorMessageNotifier = ValueNotifier<String>('');
  final FormData _formData;
  final Map<String, FormatterValidatorChain?> _formatterValidatorChainMap;
  late BricksLocalizations _localizations;

  // TODO add focusing chosen field? or leave it as finding the field and then focusing

  // TODO make flat map for tabbed form too and implement here
  FormStatus checkStatus();

  // TODO make flat map for tabbed form too and implement here
  Map<String, dynamic> collectInputs();

  void set localizations(BricksLocalizations localizations) => _localizations = localizations;

  GlobalKey<FormStateBrick> get formKey => _formData.formKey;

  Map<String, FormFieldData> get fieldDataMap => _formData.fieldDataMap;

  FormManager({required FormData formData, required FormSchema formSchema})
      : _formData = formData,
        _formatterValidatorChainMap = {
          for (final d in formSchema.descriptors)
            d.keyString: FormFieldDescriptor.makeFormatterValidatorChain(d),
        } {
    _initFormData(formSchema, _formData);
  }


  // form reset
  // ==============================================================================
  void _initFormData(FormSchema formSchema, FormData formData) {
    if (formData.fieldDataMap.isNotEmpty) return;

    for (FormFieldDescriptor d in formSchema.descriptors) {
      formData.fieldDataMap[d.keyString] = FormFieldData(
        inputRuntimeType: d.inputRuntimeType,
        valueRuntimeType: d.valueRuntimeType,
        fieldContent: FieldContent.transient(d.initialInput),
        initialInput: d.initialInput,
      );
      if (d.isFocusedOnStart ?? false) formData.focusedKeyString = d.keyString;
    }
  }

  // TODO setState with new FormData after button 'Reset' clicked
  void resetForm() {
    for (String keyString in fieldDataMap.keys) {
      _resetField(keyString);
    }
    validateForm();
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
  /// Obligatory for every field - guarantees access to:
  ///  - `FormatterValidatorChain` for the field (if there is any)
  ///  - state preservation object: `FormData` where field's **input**, **value**, **isValid**,
  ///    **error** will be kept over the life of the `FormBrick`.
  void registerField<I extends Object, V extends Object>(String keyString, bool withValidator) {
    assert(
      fieldDataMap.keys.contains(keyString),
      'No "$keyString" found in FormData.fieldDataMap; '
      'all fields in form must be declared in FormSchema => FormFieldData.',
    );

    var inputRuntimeType = _fieldData(keyString).inputRuntimeType;
    assert(
      I == inputRuntimeType,
      'Field input type is different from FieldData inputType (\'${I.toString()}\' vs. \'${inputRuntimeType.toString()})\' '
      'for keyString: \'$keyString\' declared in FormSchema -> FormFieldDescriptor.',
    );

    var valueRuntimeType = _fieldData(keyString).valueRuntimeType;
    assert(
      V == valueRuntimeType,
      'Field value type is different from FieldData valueType (\'${V.toString()}\' vs. \'${valueRuntimeType.toString()})\' '
      'for keyString: \'$keyString\' declared in FormSchema -> FormFieldDescriptor.',
    );

    assert(
        withValidator == (getFormatterValidatorChain(keyString) != null),
        withValidator
            ? 'No "$keyString" found in formatterValidatorsMap while the field declares "withValidator == true"; '
                'there must be one FormatterValidatorChain in the map for every such field.'
            : 'Found "$keyString" in formatterValidatorsMap while the field declares "withValidator == false"; '
                'there must be no FormatterValidatorChain in the map for every such field.');
  }

  void setFocusListener(FocusNode focusNode, String keyString) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _setFocusedKeyString(keyString);
        _showFieldErrorMessage(keyString);
      }
    });
  }

  // getting and updating saved field state
  // ==============================================================================
  FieldContent getFieldContent(String keyString) => _fieldData(keyString).fieldContent;

  bool isFocusedOnStart(String keyString) => _formData.focusedKeyString == keyString;

  dynamic getInitialInput(String keyString) => _fieldData(keyString).initialInput;

  dynamic getFieldValue(String keyString) => getFieldContent(keyString).value;

  bool isFieldValidating(String keyString) => _fieldData(keyString).isValidating;

  dynamic getFieldError(String keyString) => getFieldContent(keyString).error;

  void setFieldValidating(String keyString, bool isValidating) =>
      _updateFieldData(keyString, isValidating: isValidating);

  bool isFieldValid(String keyString) => getFieldContent(keyString).isValid ?? false;

  bool isFieldDirty(String keyString) => getFieldContent(keyString).input != _fieldData(keyString).initialInput;

  FormatterValidatorChain? getFormatterValidatorChain(String keyString) => _formatterValidatorChainMap[keyString];

  void _setFocusedKeyString(String keyString) => _formData.focusedKeyString = keyString;

  void storeFieldContent(String keyString, FieldContent fieldContent) =>
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
  FieldContent onFieldChanged(BricksLocalizations localizations, String keyString, dynamic input) {
    FieldContent fieldContent = formatAndValidateQuietly(localizations, keyString, input);
    _showFieldErrorMessage(keyString);
    return fieldContent;
  }

  FieldContent formatAndValidateQuietly(BricksLocalizations localizations, String keyString, dynamic input) {
    FieldContent fieldContent;
    FormatterValidatorChain? formatterValidatorChain = getFormatterValidatorChain(keyString);

    if (formatterValidatorChain != null) {
      fieldContent = formatterValidatorChain.runChain(localizations, input, keyString);
    } else {
      fieldContent = FieldContent.ok(input, input);
    }

    storeFieldContent(keyString, fieldContent);
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

  void validateForm() {
    FormatterValidatorChain? formatterValidatorChain;
    FieldContent fieldContent;

    for (String keyString in fieldDataMap.keys) {
      formatterValidatorChain = getFormatterValidatorChain(keyString);
      if (formatterValidatorChain == null) continue;

      fieldContent = formatterValidatorChain.runChain(
        _localizations,
        keyString,
        getFieldContent(keyString).input,
      );
      storeFieldContent(keyString, fieldContent);
    }

    _showFieldErrorMessage(_formData.focusedKeyString);
  }

  // showing error message
  // ==============================================================================
  void _showFieldErrorMessage(String? keyString) {
    String error = (keyString == null) ? '' : (getFieldContent(keyString).error ?? '');
    errorMessageNotifier.value = error;
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
