import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_range_required_fields.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/dateTime_multifield_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/time_formatter_validator.dart';

class DateTimeSeparateFieldFormatterValidator extends DateTimeMultiFieldFormatterValidator {
  final DateTimeRequiredFields _requiredFields;
  final DateTimeLimits? _dateTimeLimits;

  late final String _dateKeyString;
  late final String _timeKeyString;

  DateTime? _date;
  DateTime? _time;

  DateTimeSeparateFieldFormatterValidator(
    super.keyString,
    super.dateTimeUtils,
    super.currentDate,
    this._requiredFields, [
    this._dateTimeLimits,
  ]);

  @override
  void validateFieldsGroup(BricksLocalizations localizations) {
    if (_dateTimeLimits == null) return;

    _getFieldValues();
    String errorText;

    // date is absent - limits validation not possible
    if (_date == null) return;

    // time is absent - check whether the date fits the limits
    if (_time == null) {
      if (_date!.compareTo(_dateTimeLimits!.minDateWithoutTime!) < 0) {
        errorText = localizations.dateErrorTooFarBack(_dateTimeLimits!.minDateWithoutTime!.toDateString());
        cacheError(_dateKeyString, errorText);
      } else if (_date!.compareTo(_dateTimeLimits!.maxDateWithoutTime!) > 0) {
        errorText = localizations.dateErrorTooFarForward(_dateTimeLimits!.maxDateWithoutTime!.toDateString());
        cacheError(_dateKeyString, errorText);
      }
    }
    // both are present - check if their concatenation fits the limits
    DateTime dateTime = _date!.add(Duration(hours: _time!.hour, minutes: _time!.minute));
    if (dateTime.compareTo(_dateTimeLimits!.minDateTime!) < 0) {
      errorText = localizations.dateTimeErrorTooFarBack(_dateTimeLimits!.minDateTime!.toDateTimeString());
      cacheError(_dateKeyString, errorText);
      cacheError(_timeKeyString, errorText);
    } else if (_date!.compareTo(_dateTimeLimits!.maxDateTime!) > 0) {
      errorText = localizations.dateTimeErrorTooFarForward(_dateTimeLimits!.maxDateTime!.toDateTimeString());
      cacheError(_dateKeyString, errorText);
      cacheError(_timeKeyString, errorText);
    }
  }

  void _getFieldValues() {
    _date = _getRangeFieldValue(_dateKeyString);
    _time = _getRangeFieldValue(_timeKeyString);
  }

  DateTime? _getRangeFieldValue(String keyString) {
    return formManager.getFieldValue(keyString) as DateTime;
  }

  @override
  void setKeyStrings(String keyString) {
    _dateKeyString = DateTimeUtils.makeDateKeyString(keyString);
    _timeKeyString = DateTimeUtils.makeTimeKeyString(keyString);

    keyStrings = [
      _dateKeyString,
      _timeKeyString,
    ];
  }

  void fillDateTimeFormatterValidators() {
    formatterValidators[_dateKeyString] = DateFormatterValidator(
      dateTimeUtils,
      currentDate,
      _dateTimeLimits,
    );
    formatterValidators[_timeKeyString] = TimeFormatterValidator(
      dateTimeUtils,
      _dateTimeLimits,
    );
  }
}
