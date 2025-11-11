import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

class RangeController {
  final String rangeId;
  bool _isBuildCompleted = false;
  bool _isBuilding = false;
  bool areFieldsValidated = false;
  bool isEditCompleted = false;
  final Map<String, DateTimeFieldContent> _resultsCacheMap = {};
  final Map<String, DateTimeFormatterValidatorChain> validatorsExceptRange = {};

  RangeController(this.rangeId);

  get isBuildCompleted => _isBuildCompleted;

  void delayValidationAfterBuilt() {
    if (_isBuilding) return;
    _isBuilding = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isBuildCompleted = true;
      _isBuilding = false;
    });
  }

  DateTimeFormatterValidatorChain getFormatterValidator(String keyString) => validatorsExceptRange[keyString]!;

  DateTimeFieldContent getFieldContent(String keyString) => _resultsCacheMap[keyString] ?? DateTimeFieldContent.empty();

  bool isFieldValid(String keyString) => _resultsCacheMap[keyString]!.isValid ?? true;

  void setFieldContent(String keyString, DateTimeFieldContent content) => _resultsCacheMap[keyString] = content;
}
