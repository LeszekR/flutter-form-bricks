import 'package:flutter/cupertino.dart';

class RangeController {
  final String rangeId;
  bool _isBuildCompleted = false;
  bool _isBuilding = false;
  bool areFieldsValidated = false;
  bool isEditCompleted = false;
  final Map<String, FormFieldValidator<String>> validatorsExceptRange = {};

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
}
