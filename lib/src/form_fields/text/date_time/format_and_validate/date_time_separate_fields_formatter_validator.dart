import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/data_time_text_editing_value.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_range_required_fields.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/dateTimeRange_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/dateTime_multifield_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/time_formatter_validator.dart';

class DateTimeSeparateFieldFormatterValidator extends DateTimeMultiFieldFormatterValidator {
  final DateTimeRequiredFields _requiredFields;
  final DateTimeLimits? _dateTimeLimits;

  late final String _dateKeyString;
  late final String _timeKeyString;

  DateTimeSeparateFieldFormatterValidator(
    super.keyString,
    super.dateTimeUtils,
    super.currentDate,
    this._requiredFields, [
    this._dateTimeLimits,
  ]) : assert(
            !keyString.contains('~'),
            'DateTimeSeparaterFieldFormatterValidator keyString must not contain "~"'
            ' - it is reserved for use in automatically extended range-parts\' keyStrings.') {
    setKeyStrings(keyString);
    fillDateTimeFormatterValidators();
  }

  @override
  void validateFieldsGroup(BricksLocalizations localizations) {
    // TODO: implement validateFieldsGroup

    //
    assert(
        DateTimeUtils.isDateField(keyString) || DateTimeUtils.isTimeField(keyString),
        'DateTimeSeparateFieldFormatterValidator must receive either date or time field keyString '
        '- received "$keyString" is none of those.');

    DateTimeFieldContent dateFieldContent, timeFieldContent;
    FieldContent result;

    if (DateTimeUtils.isDateField(keyString)) {
      dateFieldContent = dateFormatterValidator.run(localizations, keyString, input);
      timeFieldContent = _formManager.getFieldContent(getTimeKeyString(keyString)) as DateTimeFieldContent;
      result = dateFieldContent;
    } else {
      dateFieldContent = _formManager.getFieldContent(getDateKeyString(keyString)) as DateTimeFieldContent;
      timeFieldContent = timeFormatterValidator.run(localizations, keyString, input);
      result = timeFieldContent;
    }

    // error in date or time field
    // ------------------------------------------------------------
    if (!result.isValid!) return DateTimeSeparatedFieldContent.err(input, result.error);

    DateTimeTextEditingValue formattedInput = DateTimeTextEditingValue(
      dateFieldContent.input,
      timeFieldContent.input,
    );
    DateTime? date = dateFieldContent.value;
    DateTime? time = timeFieldContent.value;

    // one of the fields is empty - can't compute the value
    // ------------------------------------------------------------
    if (DateTimeUtils.isDateField(keyString)) {
      if (time == null) {
        return DateTimeSeparatedFieldContent.err(
            formattedInput, localizations.dateTimeSeparatedFieldNoTimeForLimitValidation);
      }
    } else {
      if (date == null) {
        return DateTimeSeparatedFieldContent.err(
            formattedInput, localizations.dateTimeSeparatedFieldNoDateForLimitValidation);
      }
    }

    DateTime? value = _dateTimeUtils.mergeDateAndTime(date!, time!);

    // check the limits
    // ------------------------------------------------------------
    if (_dateTimeLimits != null) {
      DateTime minDateTime = _dateTimeLimits!.minDateTime!;
      if (value.compareTo(minDateTime) < 0) {
        String minDateTimeString = minDateTime.toDateTimeString();
        return DateTimeSeparatedFieldContent.err(formattedInput, localizations.dateErrorTooFarBack(minDateTimeString));
      }
      DateTime maxDateTime = _dateTimeLimits!.maxDateTime!;
      if (value.compareTo(maxDateTime) > 0) {
        String maxDateTimeString = maxDateTime.toDateTimeString();
        return DateTimeSeparatedFieldContent.err(
            formattedInput, localizations.dateErrorTooFarForward(maxDateTimeString));
      }
    }

    // no limits - return ok
    // ------------------------------------------------------------
    return DateTimeSeparatedFieldContent.ok(formattedInput, value);
  }

  String getDateKeyString(String keyString) {
    if (_dateKeyString == null) {
      if (DateTimeUtils.isDateField(keyString)) {
        _dateKeyString = keyString;
      } else if (DateTimeUtils.isTimeField(keyString)) {
        _dateKeyString = keyString.replaceFirst(DateTimeUtils.timePostfix, DateTimeUtils.datePostfix);
      } else {
        throw ArgumentError(
            'DateTimeSeparateFieldFormatterValidator must receive either date or time field keyString to cache'
            'elements keyStrings - received "$keyString" is none ');
      }
    }
    return _dateKeyString!;
  }

  String getTimeKeyString(String keyString) {
    if (_timeKeyString == null) {
      if (DateTimeUtils.isTimeField(keyString)) {
        _timeKeyString = keyString;
      } else if (DateTimeUtils.isDateField(keyString)) {
        _timeKeyString = keyString.replaceFirst(DateTimeUtils.datePostfix, DateTimeUtils.timePostfix);
      } else {
        throw ArgumentError(
            'DateTimeSeparateFieldFormatterValidator must receive either date or time field keyString to cache'
            'elements keyStrings - received "$keyString" is none ');
      }
    }
    return _timeKeyString!;
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
