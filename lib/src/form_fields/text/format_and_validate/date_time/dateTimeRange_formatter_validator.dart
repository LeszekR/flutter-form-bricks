import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/formatter_validators/formatter_validator.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

class DateTimeRangeFormatterValidator extends FormatterValidator<String, DateTime> {
  final FormManager _formManager;
  final DateTimeUtils _dateTimeUtils;
  final CurrentDate _currentDate;
  final DateTimeRangeLimits? _rangeLimits;

  List<String> _keyStrings = [];
  final Map<String, DateTimeFieldContent> _resultsCache = {};
  final Map<String, FormatterValidator> _formatterValidators = {};

  String? _dateStartKeyString;
  String? _timeStartKeyString;
  String? _dateEndKeyString;
  String? _timeEndKeyString;

  String? _dateStart;
  String? _timeStart;
  String? _dateEnd;
  String? _timeEnd;

  DateTimeRangeFormatterValidator(
    String keyString,
    this._formManager,
    this._dateTimeUtils,
    this._currentDate,
    this._rangeLimits,
  ) {
    _setKeyStrings(keyString);
    _fillDateTimeFormatterValidators();
  }

  void _setKeyStrings(String keyString) {
    _dateStartKeyString = rangeDateStartKeyString(keyString);
    _timeStartKeyString = rangeTimeStartKeyString(keyString);
    _dateEndKeyString = rangeDateEndKeyString(keyString);
    _timeEndKeyString = rangeTimeEndKeyString(keyString);

    _keyStrings = [
      _dateStartKeyString!,
      _timeStartKeyString!,
      _dateEndKeyString!,
      _timeEndKeyString!,
    ];
  }

  void _fillDateTimeFormatterValidators() {
    _formatterValidators[_dateStartKeyString!] = DateFormatterValidator(
      _dateTimeUtils,
      _currentDate,
      _rangeLimits?.startDateTimeLimits,
    );
    _formatterValidators[_timeStartKeyString!] = TimeFormatterValidator(
      _dateTimeUtils,
      _rangeLimits?.startDateTimeLimits,
    );
    _formatterValidators[_dateEndKeyString!] = DateFormatterValidator(
      _dateTimeUtils,
      _currentDate,
      _rangeLimits?.endDateTimeLimits,
    );
    _formatterValidators[_timeEndKeyString!] = TimeFormatterValidator(
      _dateTimeUtils,
      _rangeLimits?.endDateTimeLimits,
    );
  }

  @override
  DateTimeFieldContent run(
    BricksLocalizations localizations,
    String keyString,
    DateTimeFieldContent fieldContent,
  ) {
    FormatterValidator fieldFormaterValidator = _formatterValidators[keyString]!;
    DateTimeFieldContent resultContent =
        fieldFormaterValidator.run(localizations, keyString, fieldContent) as DateTimeFieldContent;

    // FieldContent cached here will be used during validation of any DateTime fields contained in
    // this formatter-validator by:
    // - providing FieldContent.isValid for future validation of other fields in this DateTimeRangeField
    // - providing FieldContent to be stored in FormManager, (including the field's input and value)
    cacheFieldContent(keyString, resultContent);

    // All four fields will be validated against range criteria here. They have been checked for date/times correctness
    // by now.
    // FieldContent of the field which triggered validation here will be stored after being returned from this method.
    // The other fields' contents will be stored in FormManager -> FormData here.
    if (resultContent.isValid! && _areOtherFieldsValid(keyString)) {
      _validateRange(localizations);
      _storeOtherFieldsContentsInFormData(keyString);
    }

    // FieldContent returned here will:
    // - be stored in FormData by FormManager
    // - FieldContent.input (just formatted by FormatterValidator) will be entered into the field
    return _getFieldContent(keyString);
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

  void _validateRange(BricksLocalizations localizations) {
    _setFieldTexts();
    String errorText;

    // start-date absent
    // -----------------------------------------------------------------
    if (_empty(_dateStart)) {
      errorText = localizations.rangeDateStartRequired;
      _cacheError(_dateStartKeyString!, _dateStart, errorText);
      return;
    }

    // start-time absent & end-date absent & end-time present
    // -----------------------------------------------------------------
    if (_empty(_timeStart) && _empty(_dateEnd) && _notEmpty(_timeEnd)) {
      errorText = localizations.rangeDateEndRequiredOrRemoveTimeEnd;
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
        errorText = localizations.rangeDateStartAfterEnd;
        _cacheError(_dateStartKeyString!, _dateStart, errorText);
        _cacheError(_dateEndKeyString!, _dateEnd, errorText);
        return;
      }

      // start-date present & end-date present & end-date too far from start-date
      // -----------------------------------------------------------------
      int? maxSpanMinutes = _rangeLimits?.maxSpanMinutes;
      if (maxSpanMinutes != null) {
        if (dateDiffMinutes > maxSpanMinutes) {
          String maxSpanCondition = _dateTimeUtils.minutesToSpanCondition(maxSpanMinutes);
          errorText = localizations.rangeDatesTooFarApart(maxSpanCondition);
          _cacheError(_dateStartKeyString!, _dateStart, errorText);
          _cacheError(_dateEndKeyString!, _dateEnd, errorText);
          return;
        }
      }
    }

    if (_notEmpty(_timeStart) && _notEmpty(_timeEnd)) {
      // identical start and end
      if (_dateStart == _dateEnd && _timeStart == _timeEnd) {
        errorText = localizations.rangeStartSameAsEnd;
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
          errorText = localizations.rangeTimeStartAfterEndOrAddDateEnd;
          _cacheError(_timeStartKeyString!, _timeStart, errorText);
          _cacheError(_dateEndKeyString!, _dateEnd, errorText);
          _cacheError(_timeEndKeyString!, _timeEnd, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        int? minSpanMinutes = _rangeLimits?.minSpanMinutes;
        if (minSpanMinutes != null) {
          if (timeDiffMinutes < minSpanMinutes) {
            String minSpanCondition = _dateTimeUtils.minutesToSpanCondition(minSpanMinutes);
            errorText = localizations.rangeTimeStartEndTooCloseOrAddDateEnd(minSpanCondition);
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
          errorText = localizations.rangeTimeStartAfterEnd;
          _cacheError(_timeStartKeyString!, _timeStart, errorText);
          _cacheError(_timeEndKeyString!, _timeEnd, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        int? minSpanMinutes = _rangeLimits?.minSpanMinutes;
        if (minSpanMinutes != null) {
          if (dateTimeDiffMinutes < minSpanMinutes) {
            String minSpan = _dateTimeUtils.minutesToSpanCondition(minSpanMinutes);
            errorText = localizations.rangeTimeStartEndTooCloseSameDate(minSpan);
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
