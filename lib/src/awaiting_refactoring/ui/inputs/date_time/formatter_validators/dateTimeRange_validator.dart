import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/dateTime_range_error_controller.dart';

class DateTimeRangeValidator {
  String? _dateStartKeyString;
  String? _timeStartKeyString;
  String? _dateEndKeyString;
  String? _timeEndKeyString;
  List<String> _keyStrings = [];

  String? _dateStartText;
  String? _timeStartText;
  String? _dateEndText;
  String? _timeEndText;

  final BricksLocalizations _localizations;
  final String _keyString;
  final FormManagerOLD _formManager;
  final RangeController _rangeController;
  final int _maxRangeSpanDays;
  final int _minRangeSpanMinutes;
  FormFieldValidator<String>? _validator;

  FormFieldValidator<String> get validator => _validator!;

  // TODO full support for minDate, maxDate, minSpanMinutes, maxSpanMinutes
  DateTimeRangeValidator(
    this._localizations,
    this._keyString,
    this._formManager,
    this._rangeController,
    this._maxRangeSpanDays,
    this._minRangeSpanMinutes,
  ) {
    _rangeController.delayValidationAfterBuilt();
    _setkeyStrings(_rangeController.rangeId);
    _validator = _validatorFunction as FormFieldValidator<String>;
  }

  String? _validatorFunction(String inputString) {
    if (!_rangeController.isBuildCompleted) return null;
    if (!_rangeController.isEditCompleted) return null;
    if (_rangeController.areFieldsValidated) return _getMyErrorText();

    _loadErrorsExceptRange();
    if (noErrors()) _loadRangeErrors();

    _rangeController.areFieldsValidated = true;
    _validateOthersQuietly();
    _rangeController.areFieldsValidated = false;
    _rangeController.isEditCompleted = false;

    return _getMyErrorText();
  }

  String? _getMyErrorText() {
    var errorText = _formManager.getErrorMessage(_keyString);
    return errorText == '' ? null : errorText;
  }

  bool noErrors() {
    for (var keyString in _keyStrings) {
      if (_formManager.getErrorMessage(keyString) != null) return false;
    }
    return true;
  }

  void _loadErrorsExceptRange() {
    for (var keyString in _keyStrings) {
      var individualValidator = _rangeController.validatorExceptRange[keyString];
      if (individualValidator != null) {
        var text = _getRangeFieldText(keyString);
        var errorText = individualValidator.call(text);
        _formManager.saveErrorMessage(keyString, errorText);
      }
    }
  }

  void _validateOthersQuietly() {
    for (var keyString in _keyStrings) {
      if (keyString == keyString) continue;
      _formManager.validateFieldQuietly(keyString);
    }
  }

  void _loadRangeErrors() {
    _setFieldTexts();
    String errorText;

    // start-date absent
    // -----------------------------------------------------------------
    if (empty(_dateStartText)) {
      errorText = _localizations.rangeDateStartRequired;
      _formManager.saveErrorMessage(_dateStartKeyString!, errorText);
      return;
    }

    // start-time absent & end-date absent & end-time present
    // -----------------------------------------------------------------
    if (empty(_timeStartText) && empty(_dateEndText) && notEmpty(_timeEndText)) {
      errorText = _localizations.rangeDateEndRequiredOrRemoveTimeEnd;
      _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
      _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
      _formManager.saveErrorMessage(_timeEndKeyString!, errorText);
      return;
    }

    if (notEmpty(_dateStartText) && notEmpty(_dateEndText)) {
      var dateStart = DateTime.parse(_dateStartText!);
      var dateEnd = DateTime.parse(_dateEndText!);
      int difference = dateEnd.difference(dateStart).inDays;

      // start-date present & end-date present & start-date after end-date
      // -----------------------------------------------------------------
      if (difference < 0) {
        errorText = _localizations.rangeDateStartAfterEnd;
        _formManager.saveErrorMessage(_dateStartKeyString!, errorText);
        _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
        return;
      }

      // start-date present & end-date present & end-date too far from start-date
      // -----------------------------------------------------------------
      if (difference > _maxRangeSpanDays) {
        errorText = _localizations.rangeDatesTooFarApart(_maxRangeSpanDays);
        _formManager.saveErrorMessage(_dateStartKeyString!, errorText);
        _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
        return;
      }
    }

    if (notEmpty(_timeStartText) && notEmpty(_timeEndText)) {
      // identical start and end
      if (_dateStartText == _dateEndText && _timeStartText == _timeEndText) {
        errorText = _localizations.rangeStartSameAsEnd;
        _formManager.saveErrorMessage(_dateStartKeyString!, errorText);
        _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
        _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
        _formManager.saveErrorMessage(_timeEndKeyString!, errorText);
        return;
      }

      var dummyDate = '2000-01-01';
      var timeStart = makeDateTime(dummyDate, _timeStartText!);
      var timeEnd = makeDateTime(dummyDate, _timeEndText!);
      var difference = timeEnd.difference(timeStart).inMinutes;

      // end-date absent
      if (notEmpty(_dateStartText) && empty(_dateEndText)) {
        // start-time after end-time
        // -----------------------------------------------------------------
        if (difference < 0) {
          errorText = _localizations.rangeTimeStartAfterEndOrAddDateEnd;
          // formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
          _formManager.saveErrorMessage(_timeEndKeyString!, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        else if (difference < _minRangeSpanMinutes) {
          errorText = _localizations.rangeTimeStartEndTooCloseOrAddDateEnd(_minRangeSpanMinutes);
          // formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
          _formManager.saveErrorMessage(_timeEndKeyString!, errorText);
          return;
        }
      }

      // start-date = end-date
      if (notEmpty(_dateEndText) && notEmpty(_dateStartText)) {
        var dateTimeStart = makeDateTime(_dateStartText!, _timeStartText!);
        var dateTimeEnd = makeDateTime(_dateEndText!, _timeEndText!);
        var difference = dateTimeEnd.difference(dateTimeStart).inMinutes;

        // start-time after end-time
        // -----------------------------------------------------------------
        if (difference < 0) {
          errorText = _localizations.rangeTimeStartAfterEnd;
          // formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          // formManager.saveErrorMessage(_dateEndKeyString!, errorText);
          _formManager.saveErrorMessage(_timeEndKeyString!, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        else if (difference < _minRangeSpanMinutes) {
          errorText = _localizations.rangeTimeStartEndTooCloseSameDate(_minRangeSpanMinutes);
          // formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          // formManager.saveErrorMessage(_dateEndKeyString!, errorText);
          _formManager.saveErrorMessage(_timeEndKeyString!, errorText);
          return;
        }
      }
    }
    return;
  }

  bool empty(String? text) {
    return text == null || text.isEmpty;
  }

  bool notEmpty(String? text) {
    return text != null && text.isNotEmpty;
  }

  DateTime makeDateTime(final String dateText,String timeText) {
    var dateStart = DateTime.parse(dateText);
    var timeArr = timeText.split(':');
    var hour = int.parse(timeArr[0]);
    var minute = int.parse(timeArr[1]);
    return dateStart.add(Duration(hours: hour, minutes: minute));
  }

  void _setFieldTexts() {
    _dateStartText = _getRangeFieldText(_dateStartKeyString!);
    _timeStartText = _getRangeFieldText(_timeStartKeyString!);
    _dateEndText = _getRangeFieldText(_dateEndKeyString!);
    _timeEndText = _getRangeFieldText(_timeEndKeyString!);
  }

  void _setkeyStrings(String rangeId) {
    _dateStartKeyString = DateTimeInputs.rangeDateStartKeyString(rangeId);
    _timeStartKeyString = DateTimeInputs.rangeTimeStartKeyString(rangeId);
    _dateEndKeyString = DateTimeInputs.rangeDateEndKeyString(rangeId);
    _timeEndKeyString = DateTimeInputs.rangeTimeEndKeyString(rangeId);
    _keyStrings = [_dateStartKeyString!, _timeStartKeyString!, _dateEndKeyString!, _timeEndKeyString!];
  }

  String? _getRangeFieldText(String keyString) {
    return (_formManager.formKey.currentState?.fields[keyString])!.value;
  }
}
