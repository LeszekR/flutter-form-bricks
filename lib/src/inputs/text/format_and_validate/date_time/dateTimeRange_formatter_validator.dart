import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_range_span.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

class DateTimeRangeFormatterValidator extends FormatterValidatorChain<String, DateTime> {
  final String _keyString;
  final FormManager _formManager;
  final DateTimeUtils _dateTimeUtils;
  final BricksLocalizations _localizations;
  final CurrentDate _currentDate;
  final DateTimeLimits? _dateTimeLimits; // TODO 1: use dateTimeLimits
  final DateTimeRangeSpan? _dateTimeSpanLimits;

  List<String> _keyStrings = [];
  final Map<String, DateTimeFieldContent> _resultsCache = {};
  final Map<String, DateTimeFormatterValidatorChain> _dateTimeFormatterValidators = {};

  String? _dateStartKeyString;
  String? _timeStartKeyString;
  String? _dateEndKeyString;
  String? _timeEndKeyString;

  String? _dateStart;
  String? _timeStart;
  String? _dateEnd;
  String? _timeEnd;

  DateTimeRangeFormatterValidator(
    this._keyString,
    this._formManager,
    this._dateTimeUtils,
    this._localizations,
    this._currentDate,
    this._dateTimeLimits,
    this._dateTimeSpanLimits,
  ) : super([]) {
    _setKeyStrings(_keyString);
    _fillDateTimeFormatterValidators();
  }

  @override
  DateTimeFieldContent call(String input, [String? keyString, FormatValidatePayload? payload]) {
    DateTimeFormatterValidatorChain fieldFormaterValidator = _dateTimeFormatterValidators[keyString!]!;
    DateTimeFieldContent fieldContent = fieldFormaterValidator(input, keyString);

    // FieldContent cached here will be used during validation of any DateTime fields contained in
    // this formatter-validator by:
    // - providing FieldContent.isValid for future validation of other fields in this DateTimeRangeField
    // - providing FieldContent to be stored in FormManager, (including the field's input and value)
    cacheFieldContent(keyString, fieldContent);

    // All four fields will be validated against range criteria here. They have been checked for date/times correctness
    // by now.
    // FieldContent of the field which triggered validation here will be stored after being returned from this method.
    // The other fields' contents will be stored in FormManager -> FormData here.
    if (fieldContent.isValid! && _areOtherFieldsValid(keyString)) {
      _validateRange();
      _storeOtherFieldsContentsInFormData(keyString);
    }

    // FieldContent returned here will:
    // - be stored in FormData by FormManager
    // - FieldContent.input (just formatted by FormatterValidator) will be entered into the field
    return _getFieldContent(keyString);
  }

  void _fillDateTimeFormatterValidators() {
    // TU PRZERWAŁEM
    _dateTimeFormatterValidators[_dateStartKeyString!] =
        DateTimeFormatterValidatorChain([DateFormatterValidator(_dateTimeUtils, _currentDate)]);
    // _dateTimeFormatterValidators[_]
    // _dateTimeFormatterValidators[_]
    // _dateTimeFormatterValidators[_]
  }

  bool _areOtherFieldsValid(String excludedKeyString) {
    bool isFieldValid;
    for (String keyString in _getIncludedFields(excludedKeyString)) {
      isFieldValid = _resultsCache[keyString]?.isValid ?? false;
      if (!isFieldValid) return false;
    }
    return true;
  }

  void _storeOtherFieldsContentsInFormData([String? excludedKeyString]) {
    for (String keyString in _getIncludedFields(excludedKeyString)) {
      _formManager.storeFieldContent(keyString, _getFieldContent(keyString));
    }
  }

  Iterable<String> _getIncludedFields(String? excludedKeyString) {
    var otherFields = _keyStrings.where((k) => k != excludedKeyString);
    return otherFields;
  }

  DateTimeFieldContent _getFieldContent(String keyString) {
    return _resultsCache[keyString]!;
  }

  void cacheFieldContent(String keyString, DateTimeFieldContent content) {
    _resultsCache[keyString] = content;
  }

  void _validateRange() {
    _setFieldTexts();
    String errorText;

    // start-date absent
    // -----------------------------------------------------------------
    if (_empty(_dateStart)) {
      errorText = _localizations.rangeDateStartRequired;
      _cacheError(_dateStartKeyString!, _dateStart, errorText);
      return;
    }

    // start-time absent & end-date absent & end-time present
    // -----------------------------------------------------------------
    if (_empty(_timeStart) && _empty(_dateEnd) && _notEmpty(_timeEnd)) {
      errorText = _localizations.rangeDateEndRequiredOrRemoveTimeEnd;
      _cacheError(_timeStartKeyString!, _timeStart, errorText);
      _cacheError(_dateEndKeyString!, _dateEnd, errorText);
      _cacheError(_timeEndKeyString!, _timeEnd, errorText);
      return;
    }

    if (_notEmpty(_dateStart) && _notEmpty(_dateEnd)) {
      DateTime dateStart = _makeDateTimeOptional(_dateStart!, _timeStart);
      DateTime dateEnd = _makeDateTimeOptional(_dateEnd!, _timeEnd);
      int dateDiffMinutes = dateEnd.difference(dateStart).inMinutes;

      // start-date present & end-date present & start-date after end-date
      // -----------------------------------------------------------------
      if (dateDiffMinutes < 0) {
        errorText = _localizations.rangeDateStartAfterEnd;
        _cacheError(_dateStartKeyString!, _dateStart, errorText);
        _cacheError(_dateEndKeyString!, _dateEnd, errorText);
        return;
      }

      // start-date present & end-date present & end-date too far from start-date
      // -----------------------------------------------------------------
      if (_dateTimeSpanLimits != null && _dateTimeSpanLimits!.maxDateTimeSpanMinutes != null) {
        int maxSpanMinutes = _dateTimeSpanLimits!.maxDateTimeSpanMinutes!;
        if (dateDiffMinutes > maxSpanMinutes) {
          String maxSpanCondition = _dateTimeUtils.minutesToSpanCondition(maxSpanMinutes);
          errorText = _localizations.rangeDatesTooFarApart(maxSpanCondition);
          _cacheError(_dateStartKeyString!, _dateStart, errorText);
          _cacheError(_dateEndKeyString!, _dateEnd, errorText);
          return;
        }
      }
    }

    if (_notEmpty(_timeStart) && _notEmpty(_timeEnd)) {
      // identical start and end
      if (_dateStart == _dateEnd && _timeStart == _timeEnd) {
        errorText = _localizations.rangeStartSameAsEnd;
        _cacheError(_dateStartKeyString!, _dateStart, errorText);
        _cacheError(_timeStartKeyString!, _timeStart, errorText);
        _cacheError(_dateEndKeyString!, _dateEnd, errorText);
        _cacheError(_timeEndKeyString!, _timeEnd, errorText);
        return;
      }

      String dummyDate = '2000-01-01';
      DateTime timeStart = _makeDateTime(dummyDate, _timeStart!);
      DateTime timeEnd = _makeDateTime(dummyDate, _timeEnd!);
      int timeDiffMinutes = timeEnd.difference(timeStart).inMinutes;

      // end-date absent
      if (_notEmpty(_dateStart) && _empty(_dateEnd)) {
        // start-time after end-time
        // -----------------------------------------------------------------
        if (timeDiffMinutes < 0) {
          errorText = _localizations.rangeTimeStartAfterEndOrAddDateEnd;
          _cacheError(_timeStartKeyString!, _timeStart, errorText);
          _cacheError(_dateEndKeyString!, _dateEnd, errorText);
          _cacheError(_timeEndKeyString!, _timeEnd, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        if (_dateTimeSpanLimits != null && _dateTimeSpanLimits!.minDateTimeSpanMinutes != null) {
          int minSpanMinutes = _dateTimeSpanLimits!.minDateTimeSpanMinutes!;
          if (timeDiffMinutes < minSpanMinutes) {
            String minSpanCondition = _dateTimeUtils.minutesToSpanCondition(minSpanMinutes);
            errorText = _localizations.rangeTimeStartEndTooCloseOrAddDateEnd(minSpanCondition);
            _cacheError(_timeStartKeyString!, _timeStart, errorText);
            _cacheError(_dateEndKeyString!, _dateEnd, errorText);
            _cacheError(_timeEndKeyString!, _timeEnd, errorText);
            return;
          }
        }
      }

      // start-date = end-date
      if (_notEmpty(_dateEnd) && _notEmpty(_dateStart)) {
        DateTime dateTimeStart = _makeDateTime(_dateStart!, _timeStart!);
        DateTime dateTimeEnd = _makeDateTime(_dateEnd!, _timeEnd!);
        int dateTimeDiffMinutes = dateTimeEnd.difference(dateTimeStart).inMinutes;

        // start-time after end-time
        // -----------------------------------------------------------------
        if (dateTimeDiffMinutes < 0) {
          errorText = _localizations.rangeTimeStartAfterEnd;
          _cacheError(_timeStartKeyString!, _timeStart, errorText);
          _cacheError(_timeEndKeyString!, _timeEnd, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        if (_dateTimeSpanLimits != null && _dateTimeSpanLimits!.minDateTimeSpanMinutes != null) {
          int minSpanMinutes = _dateTimeSpanLimits!.minDateTimeSpanMinutes!;
          if (dateTimeDiffMinutes < minSpanMinutes) {
            String minSpan = _dateTimeUtils.minutesToSpanCondition(minSpanMinutes);
            errorText = _localizations.rangeTimeStartEndTooCloseSameDate(minSpan);
            _cacheError(_timeStartKeyString!, _timeStart, errorText);
            _cacheError(_timeEndKeyString!, _timeEnd, errorText);
            return;
          }
        }
      }
    }
    return;
  }

  void _cacheError(String keyString, text, String errorText) {
    // TU PRZERWAŁEM
    // TODO preserve DateTime isValid when range error makes the field invalid
    cacheFieldContent(keyString, _getFieldContent(keyString).copyWith(error: errorText));
  }

  bool _empty(String? text) {
    return text == null || text.isEmpty;
  }

  bool _notEmpty(String? text) {
    return text != null && text.isNotEmpty;
  }

  DateTime _makeDateTimeOptional(String dateStartText, String? timeStartText) {
    final String time = (timeStartText == null || timeStartText.isEmpty) ? '00:00' : '$timeStartText';
    return DateTime.parse('$dateStartText $time');
  }

  DateTime _makeDateTime(String dateText, final String timeText) {
    var dateStart = DateTime.parse(dateText);
    var timeArr = timeText.split(':');
    var hour = int.parse(timeArr[0]);
    var minute = int.parse(timeArr[1]);
    return dateStart.add(Duration(hours: hour, minutes: minute));
  }

  void _setFieldTexts() {
    _dateStart = _getRangeFieldText(_dateStartKeyString!);
    _timeStart = _getRangeFieldText(_timeStartKeyString!);
    _dateEnd = _getRangeFieldText(_dateEndKeyString!);
    _timeEnd = _getRangeFieldText(_timeEndKeyString!);
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

String makeTimeKeyString(String rangePartKeyString) => "${rangePartKeyString}_time";

String rangeDateStartKeyString(String rangeKeyString) => makeDateKeyString(makeRangeKeyStringStart(rangeKeyString));

String rangeTimeStartKeyString(String rangeKeyString) => makeTimeKeyString(makeRangeKeyStringStart(rangeKeyString));

String rangeDateEndKeyString(String rangeKeyString) => makeDateKeyString(makeRangeKeyStringEnd(rangeKeyString));

String rangeTimeEndKeyString(String rangeKeyString) => makeTimeKeyString(makeRangeKeyStringEnd(rangeKeyString));
