import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../forms/form_manager/form_manager.dart';
import 'dateTime_range_error_controller.dart';
import 'date_time_inputs.dart';

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

  final RangeController rangeController;
  final FormManagerOLD formManager;
  final String keyString;
  FormFieldValidator<String>? _validator;

  FormFieldValidator<String> get validator => _validator!;

  DateTimeRangeValidator(
    this.keyString,
    this.formManager,
    this.rangeController,
  ) {
    rangeController.delayValidationAfterBuilt();
    _setkeyStrings(rangeController.rangeId);
    _validator = _validatorFunction as FormFieldValidator<String>;
  }

  String? _validatorFunction(text) {
    if (!rangeController.isBuildCompleted) return null;
    if (!rangeController.isEditCompleted) return null;
    if (rangeController.areFieldsValidated) return _getMyErrorText();

    _loadErrorsExceptRange();
    if (noErrors()) _loadRangeErrors();

    rangeController.areFieldsValidated = true;
    _validateOthersQuietly();
    rangeController.areFieldsValidated = false;
    rangeController.isEditCompleted = false;

    return _getMyErrorText();
  }

  String? _getMyErrorText() {
    var errorText = formManager.getErrorMessage(keyString);
    return errorText == '' ? null : errorText;
  }

  bool noErrors() {
    for (var keyString in _keyStrings) {
      if (formManager.getErrorMessage(keyString) != null) return false;
    }
    return true;
  }

  void _loadErrorsExceptRange() {
    for (var keyString in _keyStrings) {
      var individualValidator = rangeController.validatorExceptRange[keyString];
      if (individualValidator != null) {
        var text = _getRangeFieldText(keyString);
        var errorText = individualValidator.call(text);
        formManager.saveErrorMessage(keyString, errorText);
      }
    }
  }

  void _validateOthersQuietly() {
    for (var keyString in _keyStrings) {
      if (keyString == keyString) continue;
      formManager.validateFieldQuietly(keyString);
    }
  }

  void _loadRangeErrors() {
    _setFieldTexts();
    String errorText;

    // start-date absent
    // -----------------------------------------------------------------
    if (empty(dateStartText)) {
      errorText = Tr.get.rangeDateStartRequired;
      formManager.saveErrorMessage(_dateStartKeyString!, errorText);
      return;
    }

    // start-time absent & end-date absent & end-time present
    // -----------------------------------------------------------------
    if (empty(timeStartText) && empty(dateEndText) && notEmpty(timeEndText)) {
      errorText = Tr.get.rangeDateEndRequiredOrRemoveTimeEnd;
      formManager.saveErrorMessage(_timeStartKeyString!, errorText);
      formManager.saveErrorMessage(_dateEndKeyString!, errorText);
      formManager.saveErrorMessage(_timeEndKeyString!, errorText);
      return;
    }

    if (notEmpty(dateStartText) && notEmpty(dateEndText)) {
      var dateStart = DateTime.parse(dateStartText!);
      var dateEnd = DateTime.parse(dateEndText!);
      var difference = dateEnd.difference(dateStart).inDays;

      // start-date present & end-date present & start-date after end-date
      // -----------------------------------------------------------------
      if (difference < 0) {
        errorText = Tr.get.rangeDateStartAfterEnd;
        formManager.saveErrorMessage(_dateStartKeyString!, errorText);
        formManager.saveErrorMessage(_dateEndKeyString!, errorText);
        return;
      }

      // start-date present & end-date present & end-date too far from start-date
      // -----------------------------------------------------------------
      var maxRangeSpanDays = AppParams.maxRangeSpanDays;
      if (difference > maxRangeSpanDays) {
        errorText = Tr.get.rangeDatesTooFarApart(maxRangeSpanDays);
        formManager.saveErrorMessage(_dateStartKeyString!, errorText);
        formManager.saveErrorMessage(_dateEndKeyString!, errorText);
        return;
      }
    }

    if (notEmpty(timeStartText) && notEmpty(timeEndText)) {
      // identical start and end
      if (dateStartText == dateEndText && timeStartText == timeEndText) {
        errorText = Tr.get.rangeStartSameAsEnd;
        formManager.saveErrorMessage(_dateStartKeyString!, errorText);
        formManager.saveErrorMessage(_timeStartKeyString!, errorText);
        formManager.saveErrorMessage(_dateEndKeyString!, errorText);
        formManager.saveErrorMessage(_timeEndKeyString!, errorText);
        return;
      }

      var dummyDate = '2000-01-01';
      var timeStart = makeDateTime(dummyDate, timeStartText!);
      var timeEnd = makeDateTime(dummyDate, timeEndText!);
      var difference = timeEnd.difference(timeStart).inMinutes;

      // end-date absent
      var minRangeSpanMinutes = AppParams.minRangeSpanMinutes;
      if (notEmpty(dateStartText) && empty(dateEndText)) {
        // start-time after end-time
        // -----------------------------------------------------------------
        if (difference < 0) {
          errorText = Tr.get.rangeTimeStartAfterEndOrAddDateEnd;
          // formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          formManager.saveErrorMessage(_dateEndKeyString!, errorText);
          formManager.saveErrorMessage(_timeEndKeyString!, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        else if (difference < minRangeSpanMinutes) {
          errorText = Tr.get.rangeTimeStartEndTooCloseOrAddDateEnd(minRangeSpanMinutes);
          // formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          formManager.saveErrorMessage(_dateEndKeyString!, errorText);
          formManager.saveErrorMessage(_timeEndKeyString!, errorText);
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
          errorText = Tr.get.rangeTimeStartAfterEnd;
          // formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          // formManager.saveErrorMessage(_dateEndKeyString!, errorText);
          formManager.saveErrorMessage(_timeEndKeyString!, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        else if (difference < minRangeSpanMinutes) {
          errorText = Tr.get.rangeTimeStartEndTooCloseSameDate(minRangeSpanMinutes);
          // formManager.saveErrorMessage(_dateStartKeyString!, errorText);
          formManager.saveErrorMessage(_timeStartKeyString!, errorText);
          // formManager.saveErrorMessage(_dateEndKeyString!, errorText);
          formManager.saveErrorMessage(_timeEndKeyString!, errorText);
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
    return (formManager.formKey.currentState?.fields[keyString])!.value;
  }
}
