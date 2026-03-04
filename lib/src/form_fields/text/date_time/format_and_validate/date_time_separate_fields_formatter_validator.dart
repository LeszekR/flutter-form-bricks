import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_range_required_fields.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/dateTimeRange_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/time_formatter_validator.dart';

class DateTimeSeparateFieldsFormatterValidator extends FormatterValidator<TextEditingValue, DateTime> {
  final DateTimeRequiredFields _dateTimeRequiredFields;
  final DateTimeUtils _dateTimeUtils;
  final DateTimeLimits? _dateTimeLimits;
  final DateFormatterValidator dateFormatterValidator;
  final TimeFormatterValidator timeFormatterValidator;
  late final FormManager _formManager;
  late final String? _keyStringDate;
  late final String? _keyStringTime;

  void set formManager(FormManager formManager) => _formManager = formManager;

  DateTimeSeparateFieldsFormatterValidator(
    this._dateTimeRequiredFields,
    this._dateTimeUtils,
    CurrentDate currentDate, [
    this._dateTimeLimits,
  ])  : dateFormatterValidator = DateFormatterValidator(_dateTimeUtils, currentDate),
        timeFormatterValidator = TimeFormatterValidator(_dateTimeUtils);

  @override
  FieldContent<TextEditingValue, DateTime> run(
    BricksLocalizations localizations,
    String keyString,
    DateTimeFieldContent fieldContent,
  ) {
    DateTimeFieldContent result;

    if (isDateField(keyString)) {
      result = dateFormatterValidator.run(localizations, keyString, fieldContent);
    } else if (isTimeField(keyString)) {
      result = timeFormatterValidator.run(localizations, keyString, fieldContent);
    } else {
      throw ArgumentError('DateTimeSeparateFieldsFormatterValidator must receive either date or time field keyString '
          '- received "$keyString" is none.');
    }

    if (!result.isValid!) return DateTimeFieldContent.err(fieldContent.input, result.error);

    if (_dateTimeLimits == null) return result;

    DateTime? date;
    DateTime? time;
    if (isDateField(keyString)) {
      date = result.value;
      time = _formManager.getFieldValue(getTimeKeyString(keyString)).value;
      if (time == null) {
        return DateTimeFieldContent.err(result.input, localizations.dateTimeSeparateFieldsNoTimeForLimitValidation);
      }
    } else if (isTimeField(keyString)) {
      time = result.value;
      date = _formManager.getFieldValue(getDateKeyString(keyString)).value;
      if (date == null) {
        return DateTimeFieldContent.err(result.input, localizations.dateTimeSeparateFieldsNoDateForLimitValidation);
      }
    }

    DateTime dateTime = DateTime(date!.year, date.month, date.day, time!.hour, time.minute);

    DateTime minDateTime = _dateTimeLimits!.minDateTime!;
    if (dateTime.compareTo(minDateTime) < 0) {
      String minDateTimeString = minDateTime.toDateTimeString();
      return DateTimeFieldContent.err(result.input, localizations.dateErrorTooFarBack(minDateTimeString));
    }
    DateTime maxDateTime = _dateTimeLimits!.maxDateTime!;
    if (dateTime.compareTo(maxDateTime) > 0) {
      String maxDateTimeString = maxDateTime.toDateTimeString();
      return DateTimeFieldContent.err(result.input, localizations.dateErrorTooFarForward(maxDateTimeString));
    }

    return result;
  }

  bool isDateField(String keyString) => keyString.contains(DateTimeRangeFormatterValidator.date);

  bool isTimeField(String keyString) => keyString.contains(DateTimeRangeFormatterValidator.time);

  String getDateKeyString(String keyString) {
    if (_keyStringDate == null) {
      if (isDateField(keyString)) {
        _keyStringDate = keyString;
      } else if (isTimeField(keyString)) {
        _keyStringDate =
            keyString.replaceFirst(DateTimeRangeFormatterValidator.time, DateTimeRangeFormatterValidator.date);
      } else {
        throw ArgumentError(
            'DateTimeSeparateFieldsFormatterValidator must receive either date or time field keyString to cache'
            'elements keyStrings - received "$keyString" is none ');
      }
    }
    return _keyStringDate!;
  }

  String getTimeKeyString(String keyString) {
    if (_keyStringTime == null) {
      if (isTimeField(keyString)) {
        _keyStringTime = keyString;
      } else if (isDateField(keyString)) {
        _keyStringTime =
            keyString.replaceFirst(DateTimeRangeFormatterValidator.date, DateTimeRangeFormatterValidator.time);
      } else {
        throw ArgumentError(
            'DateTimeSeparateFieldsFormatterValidator must receive either date or time field keyString to cache'
            'elements keyStrings - received "$keyString" is none ');
      }
    }
    return _keyStringTime!;
  }
}
