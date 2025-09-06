import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'e_form_status.dart';

abstract class FormManager {
  final _formKey = GlobalKey<FormBuilderState>();
  final Map<String, dynamic> _inputInitialValuesMap = {};
  late final Map<String, TextEditingController> _controllers = {};
  late final Map<String, FocusNode> _focusNodes = {};
  final ValueNotifier<String> errorMessageNotifier = ValueNotifier<String>("");
  final Map<String, String?> _errorsMap = {};

  void afterFieldChanged();

  EFormStatus checkState();

  void fillInitialInputValuesMap();

  FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>? findField(String keyString);

  void resetForm();

  Map<String, dynamic> collectInputs();

  GlobalKey<FormBuilderState> get formKey => _formKey;

  TextEditingController getTextEditingController(String keyString, {String? defaultValue}) {
    setEditingController(keyString, defaultValue);
    return _controllers[keyString]!;
  }

  void setEditingController(String keyString, String? defaultValue) {
    if (!_controllers.containsKey(keyString)) {
      _controllers[keyString] = TextEditingController(text: defaultValue);
    }
  }

  FocusNode getFocusNode(String keyString) {
    setFocusNode(keyString);
    return _focusNodes[keyString]!;
  }

  void setFocusNode(String keyString) {
    if (!_focusNodes.containsKey(keyString)) {
      _focusNodes[keyString] = FocusNode();
    }
  }

  void disposeAll() {
    _controllers.forEach((key, controller) => controller.dispose());
    _focusNodes.forEach((key, focusNode) => focusNode.dispose());
  }

  // TODO FormManager refactoring: only show errorMessage of the field which gains focus and none when none has focus
// void refreshErrorMessage() {
//   clearErrorMessages();
//   formKey.currentState?.fields.entries
//       .where((element) => !element.key.startsWith(FormManager.ignoreFieldKey))
//       .where((entry) => entry.value.hasError)
//       .forEach((entry) => addErrorMessageIfIsNew(
//           entry.key, "${entry.value.errorText}")); //"${_fieldNamesMapping[entry.key]}: ${entry.value.errorText}"));
//   // TODO issue: refresh error message getting focused field errMsg after locking/unlocking tab
//   // renderErrorMessage();
// }

// void renderErrorMessage() {
//   final String newMessages = _errorsMap.values.join("\n");
//   errorMessageNotifier.value = newMessages;
// }

  void setInitialValues(GlobalKey<FormBuilderState> contentGlobalKey) {
    var currentState = contentGlobalKey.currentState;
    assert(currentState != null);
    currentState!.save();
    for (var field in currentState.value.entries) {
      // TODO look up in the internet - if no solution then create KeyStringUniquenessGuard
      // field keyStrings must be unique across all tabs
      if (_inputInitialValuesMap.keys.contains(field.key)) continue;
      // assert(!_inputInitialValuesMap.keys.contains(field.key));

      _inputInitialValuesMap[field.key] = field.value;
    }
  }

  EFormStatus getFormPartState(GlobalKey<FormBuilderState> formPartKey) {
    final currentState = formPartKey.currentState;
    if (currentState == null) {
      return EFormStatus.invalid;
    }

    currentState.save();
    var fieldValuesList = currentState.value.entries;

    // TODO check where disabled fields are excluded - if nowhere then do it here
    var activeFields = fieldValuesList;
    // var activeFields = fieldValuesList.where((field) => !_isFieldIgnored(field.key));

    if (activeFields.any((field) => !findField(field.key)!.isValid)) {
      return EFormStatus.invalid;
    }
    if (activeFields.every((input) => input.value == _inputInitialValuesMap[input.key])) {
      return EFormStatus.noChange;
    }
    return EFormStatus.valid;
  }

  void onFieldChanged(final String keyString, dynamic value) {
    var field = findField(keyString);
    if (!(field?.isTouched ?? false)) {
      return;
    }

    // sets state of the field with new value
    // validates the field
    // calls rebuild of all fields in the form
    // if the form autoValidateMode is "always" or "onUserInteraction" revalidates all fields in the form
    formKey.currentState?.fields[keyString]?.didChange(value ?? field?.value);

    validateField(keyString);
    afterFieldChanged();
  }


// field validation functionality
// ==============================================================================
  void validateField(String keyString) {
    String? errorText = validateFieldQuietly(keyString);
    showErrorMessage(errorText);
  }

  String? validateFieldQuietly(String keyString) {
    var field = findField(keyString);
    field?.validate();
    var errorText = field?.errorText;
    _errorsMap[keyString] = errorText;
    return errorText;
  }

// show error message functionality
// ==============================================================================
  void showErrorMessage(String? errorText) {
    errorMessageNotifier.value = errorText ?? '';
  }

  void showFieldErrorMessage(String keyString) {
    showErrorMessage(_errorsMap[keyString] ?? '');
  }

  void addErrorMessageIfIsNew(final String key, final String errMsg) {
    final String? lastError = _errorsMap[key];
    if (lastError?.contains(errMsg) ?? false) {
      return;
    }
    _errorsMap[key] = errMsg;
    renderErrorMessage(errMsg);
  }

  void removeErrorMessageIfPresent(final String key) {
    if (_errorsMap.containsKey(key)) {
      _errorsMap.remove(key);
    }
  }

  void renderErrorMessage(String? errorMessage) {
    showErrorMessage(errorMessage);
  }

  String? getErrorMessage(String keyString) {
    if (_errorsMap.containsKey(keyString)) return _errorsMap[keyString];
    return null;
  }

  void saveErrorMessage(String keyString, String? errorMessage) {
    _errorsMap[keyString] = errorMessage;
  }

// data collection functionality
// ==============================================================================
  Map<String, dynamic> collectInputData() {
    return collectInputs().map((inputKey, _) => MapEntry(inputKey, _parseDataFromInput(_getInputValue(inputKey))));
  }

  dynamic _parseDataFromInput(final value) {
    if (value == null) {
      return value;
    }
    // if (value is Entity) {
    //   return value.toJson();
    // }
    if (value is! String) {
      return value;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  _getInputValue(String inputIdString) => findField(inputIdString)!.value;
}
