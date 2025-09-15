import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/forms/base/form_schema.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validator_chain.dart';

import '../../../../shelf.dart';
import '../../inputs/base/brick_field.dart';
import '../base/brick_form.dart';
import 'e_form_status.dart';

abstract class FormManager extends ChangeNotifier {
  final _formKey = GlobalKey<BrickFormState>();
  final BrickFormStateData _stateData;
  final Map<String, dynamic> _inputInitialValuesMap = {};
  final Map<String, String?> _errorsMap = {};

  final Map<String, FormatterValidatorChain?> _formatterValidatorChainMap = {};

  final ValueNotifier<String> errorMessageNotifier = ValueNotifier<String>("");
  late final Map<String, TextEditingController> _controllers = {};
  late final Map<String, FocusNode> _focusNodes = {};

  void _fillFormattersValidatorsMap(FormSchema formSchema) {
    for (var descriptor in formSchema.descriptors) {
      _formatterValidatorChainMap[descriptor.keyString] = descriptor.formatterValidatorChain;
    }
  }

  FormManager(this._stateData, FormSchema formSchema) {
    _fillFormattersValidatorsMap(formSchema);
  }

  void afterFieldChanged();

  EFormStatus checkState();

  void fillInitialInputValuesMap();

  BrickFieldState<BrickField>? findField(String keyString);

  void resetForm();

  Map<String, dynamic> collectInputs();

  GlobalKey<BrickFormState> get formKey => _formKey;

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

  void setInitialValues(GlobalKey<BrickFormState> contentGlobalKey) {
    // TODO uncomment and refactor
    // var currentState = contentGlobalKey.currentState;
    // assert(currentState != null);
    // currentState!.save();
    // for (var field in currentState.value.entries) {
    //   // TODO look up in the internet - if no solution then create KeyStringUniquenessGuard
    //   // field keyStrings must be unique across all tabs
    //   if (_inputInitialValuesMap.keys.contains(field.key)) continue;
    //   // assert(!_inputInitialValuesMap.keys.contains(field.key));
    //
    //   _inputInitialValuesMap[field.key] = field.value;
    // }
  }

  EFormStatus getFormPartState(GlobalKey<BrickFormState> formPartKey) {
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
    return EFormStatus.valid;
  }

  void onFieldChanged(final String keyString, dynamic value) {
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

// field validation functionality
// ==============================================================================
  void validateField(String keyString) {
    String? errorText = validateFieldQuietly(keyString);
    showErrorMessage(errorText);
  }

  String? validateFieldQuietly(String keyString) {
    // TODO uncomment and refactor
    // var field = findField(keyString);
    // field?.validate();
    // var errorText = field?.errorText;
    // _errorsMap[keyString] = errorText;
    // return errorText;
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
    // TODO uncomment and refactor
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

  dynamic _getInputValue(String inputIdString) {
    return null;
  // TODO uncomment and refactor
    // return findField(inputIdString)!.value;
  }
}
