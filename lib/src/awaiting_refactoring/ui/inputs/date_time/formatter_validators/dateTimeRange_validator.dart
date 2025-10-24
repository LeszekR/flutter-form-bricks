import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/dateTime_range_error_controller.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

import '../date_time_inputs.dart';

class DateTimeRangeValidator {
  String? _dateStartKeyString;
  String? _timeStartKeyString;
  String? _dateEndKeyString;
  String? _timeEndKeyString;
  List<String> _keyStrings = [];

  String? dateStartText;
  String? timeStartText;
  String? dateEndText;
  String? timeEndText;

  final String _keyString;
  final FormManager _formManager;
  final RangeController _rangeController;
  FormFieldValidator<String>? _validator;
  final BricksLocalizations _localizations;
  final int _maxRangeSpanDays;
  final int _minRangeSpanMinutes;

  FormFieldValidator<String> get validator => _validator!;

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

  String? _validatorFunction(text) {
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
    for (var _keyString in _keyStrings) {
      if (_formManager.getErrorMessage(_keyString) != null) return false;
    }
    return true;
  }

  void _loadErrorsExceptRange() {
    for (var _keyString in _keyStrings) {
      var individualValidator = _rangeController.validatorExceptRange[_keyString];
      if (individualValidator != null) {
        var text = _getRangeFieldText(_keyString);
        var errorText = individualValidator.call(text);
        _formManager.saveErrorMessage(_keyString, errorText);
      }
    }
  }

  void _validateOthersQuietly() {
    for (var _keyString in _keyStrings) {
      if (_keyString == _keyString) continue;
      _formManager.validateFieldQuietly(_keyString);
    }
  }

  void _loadRangeErrors() {
    _setFieldTexts();
    String errorText;

    // start-date absent
    // -----------------------------------------------------------------
    if (empty(dateStartText)) {
      errorText = _localizations.rangeDateStartRequired;
      _formManager.saveErrorMessage(_dateStartKeyString!, errorText);
      return;
    }

    // start-time absent & end-date absent & end-time present
    // -----------------------------------------------------------------
    if (empty(timeStartText) && empty(dateEndText) && notEmpty(timeEndText)) {
      errorText = _localizations.rangeDateEndRequiredOrRemoveTimeEnd;
      _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
      _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
      _formManager.saveErrorMessage(_timeEndKeyString!, errorText);
      return;
    }

    if (notEmpty(dateStartText) && notEmpty(dateEndText)) {
      var dateStart = DateTime.parse(dateStartText!);
      var dateEnd = DateTime.parse(dateEndText!);
      var difference = dateEnd.difference(dateStart).inDays;

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

    if (notEmpty(timeStartText) && notEmpty(timeEndText)) {
      // identical start and end
      if (dateStartText == dateEndText && timeStartText == timeEndText) {
        errorText = _localizations.rangeStartSameAsEnd;
        _formManager.saveErrorMessage(_dateStartKeyString!, errorText);
        _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
        _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
        _formManager.saveErrorMessage(_timeEndKeyString!, errorText);
        return;
      }

      var dummyDate = '2000-01-01';
      var timeStart = makeDateTime(dummyDate, timeStartText!);
      var timeEnd = makeDateTime(dummyDate, timeEndText!);
      var difference = timeEnd.difference(timeStart).inMinutes;

      // end-date absent
      if (notEmpty(dateStartText) && empty(dateEndText)) {
        // start-time after end-time
        // -----------------------------------------------------------------
        if (difference < 0) {
          errorText = _localizations.rangeTimeStartAfterEndOrAddDateEnd;
          // _formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
          _formManager.saveErrorMessage(_timeEndKeyString!, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        else if (difference < _minRangeSpanMinutes) {
          errorText = _localizations.rangeTimeStartEndTooCloseOrAddDateEnd(_minRangeSpanMinutes);
          // _formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
          _formManager.saveErrorMessage(_timeEndKeyString!, errorText);
          return;
        }
      }

      // start-date = end-date
      if (notEmpty(dateEndText) && notEmpty(dateStartText)) {
        var dateTimeStart = makeDateTime(dateStartText!, timeStartText!);
        var dateTimeEnd = makeDateTime(dateEndText!, timeEndText!);
        var difference = dateTimeEnd.difference(dateTimeStart).inMinutes;

        // start-time after end-time
        // -----------------------------------------------------------------
        if (difference < 0) {
          errorText = _localizations.rangeTimeStartAfterEnd;
          // _formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          // _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
          _formManager.saveErrorMessage(_timeEndKeyString!, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        else if (difference < _minRangeSpanMinutes) {
          errorText = _localizations.rangeTimeStartEndTooCloseSameDate(_minRangeSpanMinutes);
          // _formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          _formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          // _formManager.saveErrorMessage(_dateEndKeyString!, errorText);
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

  DateTime makeDateTime(final String dateText, final String timeText) {
    var dateStart = DateTime.parse(dateText);
    var timeArr = timeText.split(':');
    var hour = int.parse(timeArr[0]);
    var minute = int.parse(timeArr[1]);
    return dateStart.add(Duration(hours: hour, minutes: minute));
  }

  void _setFieldTexts() {
    dateStartText = _getRangeFieldText(_dateStartKeyString!);
    timeStartText = _getRangeFieldText(_timeStartKeyString!);
    dateEndText = _getRangeFieldText(_dateEndKeyString!);
    timeEndText = _getRangeFieldText(_timeEndKeyString!);
  }

  void _setkeyStrings(String rangeId) {
    _dateStartKeyString = DateTimeInputs.rangeDateStartKeyString(rangeId);
    _timeStartKeyString = DateTimeInputs.rangeTimeStartKeyString(rangeId);
    _dateEndKeyString = DateTimeInputs.rangeDateEndKeyString(rangeId);
    _timeEndKeyString = DateTimeInputs.rangeTimeEndKeyString(rangeId);
    _keyStrings = [_dateStartKeyString!, _timeStartKeyString!, _dateEndKeyString!, _timeEndKeyString!];
  }

  String? _getRangeFieldText(String keyString) {
    return _formManager.getFieldValue(keyString);
  }
}
