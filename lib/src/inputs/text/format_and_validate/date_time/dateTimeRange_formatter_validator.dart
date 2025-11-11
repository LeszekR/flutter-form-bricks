import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_range_span.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/dateTime_range_controller.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

class DateTimeRangeFormatterValidator extends FormatterValidatorChain<String, DateTime> {
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

  // FormFieldValidator<String>? _validator;
  final BricksLocalizations _localizations;
  final DateTimeLimits? _dateTimeLimits;
  final DateTimeRangeSpan? _dateTimeSpanLimits;

  // FormFieldValidator<String> get validator => _validator!;

  DateTimeRangeFormatterValidator(
    this._localizations,
    this._keyString,
    this._formManager,
    this._rangeController,
    this._dateTimeLimits,
    this._dateTimeSpanLimits,
  ) {
    _rangeController.delayValidationAfterBuilt();
    _setKeyStrings(_rangeController.rangeId);
    // _validator = _validatorFunction as FormFieldValidator<String>;
  }

  @override
  DateTimeFieldContent call(String input, [String? keyString, FormatValidatePayload? payload]) {
    // String? _validatorFunction(String text, String keyString) {
    if (!_rangeController.isBuildCompleted) return DateTimeFieldContent.empty();
    if (!_rangeController.isEditCompleted) return DateTimeFieldContent.empty();
    if (_rangeController.areFieldsValidated)
      return _rangeController.getFieldContent(keyString!) ?? DateTimeFieldContent.empty(); // _getMyErrorText();

    DateTimeFormatterValidatorChain fieldFormaterValidator = _rangeController.getFormatterValidator(keyString!);
    DateTimeFieldContent fieldContent = fieldFormaterValidator.call(input, keyString);

    _rangeController.setFieldContent(keyString, fieldContent);

    if (!fieldContent.isValid!) {
      _saveIndividualContentsInFormData(keyString);
    //
    } else if (!_areOtherFieldsValid(keyString)) {
      _saveIndividualContentsInFormData(keyString);
    //
    } else {
      _loadRangeErrors();

      _rangeController.areFieldsValidated = true;
      _validateOthersQuietly();
      _rangeController.areFieldsValidated = false;
      _rangeController.isEditCompleted = false;
    }
    return _getMyErrorText();
  }

  bool _areOtherFieldsValid(String initiatingKeyString) {
    for (String keyString in _otherFields(initiatingKeyString)) {
      if (!_rangeController.isFieldValid(keyString)) return false;
    }
    return false;
  }

  Iterable<String> _otherFields(String initiatingKeyString) {
    var otherFields = _keyStrings.where((k) => k != initiatingKeyString);
    return otherFields;
  }

  void _saveIndividualContentsInFormData(String initiatingKeyString) {
    for (String keyString in  _otherFields(initiatingKeyString)) {
     _formManager.storeFieldContent(keyString, _rangeController.getFieldContent(keyString));
    }
  }

  String? _getMyErrorText() {
    var errorText = _formManager.getFieldError(_keyString);
    return errorText == '' ? null : errorText;
  }

  bool noErrors() {
    for (var _keyString in _keyStrings) {
      if (_formManager.getFieldError(_keyString) != null) return false;
    }
    return true;
  }

  void _loadErrorsExceptRange() {
    for (String _keyString in _keyStrings) {
      DateTimeFormatterValidatorChain dateTimeValidator = _rangeController.getFormatterValidator(_keyString);
      if (dateTimeValidator != null) {
        // TU PRZERWAŁEM
        String text = _getRangeFieldText(_keyString);
        String? errorText = dateTimeValidator.call(text);
        _formManager.storeFieldError(_keyString, errorText);
      }
    }
  }

  void _validateOthersQuietly() {
    for (var _keyString in _keyStrings) {
      if (_keyString == _keyString) continue;
      _formManager.formatAndValidateQuietly(_keyString);
    }
  }

  void _loadRangeErrors() {
    _setFieldTexts();
    String errorText;

    // start-date absent
    // -----------------------------------------------------------------
    if (empty(dateStartText)) {
      errorText = _localizations.rangeDateStartRequired;
      _formManager.storeFieldContent(_dateStartKeyString!, DateTimeFieldContent.err(dateStartText, errorText));
      // _formManager.storeFieldError(_dateStartKeyString!, errorText);
      return;
    }

    // start-time absent & end-date absent & end-time present
    // -----------------------------------------------------------------
    if (empty(timeStartText) && empty(dateEndText) && notEmpty(timeEndText)) {
      errorText = _localizations.rangeDateEndRequiredOrRemoveTimeEnd;
      _formManager.storeFieldError(_timeStartKeyString!, errorText);
      _formManager.storeFieldError(_dateEndKeyString!, errorText);
      _formManager.storeFieldError(_timeEndKeyString!, errorText);
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
        _formManager.storeFieldError(_dateStartKeyString!, errorText);
        _formManager.storeFieldError(_dateEndKeyString!, errorText);
        return;
      }

      // start-date present & end-date present & end-date too far from start-date
      // -----------------------------------------------------------------
      if (difference > _maxDateTimeSpan) {
        errorText = _localizations.rangeDatesTooFarApart(_maxDateTimeSpan);
        _formManager.storeFieldError(_dateStartKeyString!, errorText);
        _formManager.storeFieldError(_dateEndKeyString!, errorText);
        return;
      }
    }

    if (notEmpty(timeStartText) && notEmpty(timeEndText)) {
      // identical start and end
      if (dateStartText == dateEndText && timeStartText == timeEndText) {
        errorText = _localizations.rangeStartSameAsEnd;
        _formManager.storeFieldError(_dateStartKeyString!, errorText);
        _formManager.storeFieldError(_timeStartKeyString!, errorText);
        _formManager.storeFieldError(_dateEndKeyString!, errorText);
        _formManager.storeFieldError(_timeEndKeyString!, errorText);
        return;
      }

      var dummyDate = '2000-01-01';
      DateTime timeStart = makeDateTime(dummyDate, timeStartText!);
      DateTime timeEnd = makeDateTime(dummyDate, timeEndText!);
      int difference = timeEnd.difference(timeStart).inMinutes;

      // end-date absent
      if (notEmpty(dateStartText) && empty(dateEndText)) {
        // start-time after end-time
        // -----------------------------------------------------------------
        if (difference < 0) {
          errorText = _localizations.rangeTimeStartAfterEndOrAddDateEnd;
          // _formManager.setFieldError(_dateStartKeyString!, errorText);
          _formManager.storeFieldError(_timeStartKeyString!, errorText);
          _formManager.storeFieldError(_dateEndKeyString!, errorText);
          _formManager.storeFieldError(_timeEndKeyString!, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        else if (difference < _minDateTimeSpan) {
          errorText = _localizations.rangeTimeStartEndTooCloseOrAddDateEnd(_minDateTimeSpan);
          // _formManager.setFieldError(_dateStartKeyString!, errorText);
          _formManager.storeFieldError(_timeStartKeyString!, errorText);
          _formManager.storeFieldError(_dateEndKeyString!, errorText);
          _formManager.storeFieldError(_timeEndKeyString!, errorText);
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
          // _formManager.setFieldError(_dateStartKeyString!, errorText);
          _formManager.storeFieldError(_timeStartKeyString!, errorText);
          // _formManager.setFieldError(_dateEndKeyString!, errorText);
          _formManager.storeFieldError(_timeEndKeyString!, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        else if (difference < _minDateTimeSpan) {
          errorText = _localizations.rangeTimeStartEndTooCloseSameDate(_minDateTimeSpan);
          _formManager.storeFieldError(_timeStartKeyString!, errorText);
          _formManager.storeFieldError(_timeEndKeyString!, errorText);
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

  DateTime makeDateTime(String dateText, final String timeText) {
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

  void _setKeyStrings(String rangeId) {
    _dateStartKeyString = rangeDateStartKeyString(rangeId);
    _timeStartKeyString = rangeTimeStartKeyString(rangeId);
    _dateEndKeyString = rangeDateEndKeyString(rangeId);
    _timeEndKeyString = rangeTimeEndKeyString(rangeId);
    _keyStrings = [_dateStartKeyString!, _timeStartKeyString!, _dateEndKeyString!, _timeEndKeyString!];
  }

  String? _getRangeFieldText(String keyString) {
    return _formManager.getFieldValue(keyString);
  }
}

String makeRangeKeyStringStart(String rangeKeyString) => "${rangeKeyString}_start";

String makeRangeKeyStringEnd(String rangeKeyString) => "${rangeKeyString}_end";

String makeDateKeyString(String rangePartKeyString) => "${rangePartKeyString}_date";

String mameTimeKeyString(String rangePartKeyString) => "${rangePartKeyString}_time";

String rangeDateStartKeyString(String rangeKeyString) => makeDateKeyString(makeRangeKeyStringStart(rangeKeyString));

String rangeTimeStartKeyString(String rangeKeyString) => mameTimeKeyString(makeRangeKeyStringStart(rangeKeyString));

String rangeDateEndKeyString(String rangeKeyString) => makeDateKeyString(makeRangeKeyStringEnd(rangeKeyString));

String rangeTimeEndKeyString(String rangeKeyString) => mameTimeKeyString(makeRangeKeyStringEnd(rangeKeyString));
