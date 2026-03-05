import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/data_time_text_editing_value.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_range_required_fields.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/dateTimeRange_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/time_formatter_validator.dart';

class DateTimeSeparateFieldFormatterValidator extends FormatterValidator<DateTimeTextEditingValue, DateTime> {
  final DateTimeRequiredFields _dateTimeRequiredFields;
  final DateTimeUtils _dateTimeUtils;
  final DateTimeLimits? _dateTimeLimits;
  final DateFormatterValidator dateFormatterValidator;
  final TimeFormatterValidator timeFormatterValidator;
  late final FormManager _formManager;
  late final String? _keyStringDate;
  late final String? _keyStringTime;

  void set formManager(FormManager formManager) => _formManager = formManager;

  DateTimeSeparateFieldFormatterValidator(
    this._dateTimeRequiredFields,
    this._dateTimeUtils,
    CurrentDate currentDate, [
    this._dateTimeLimits,
  ])  : dateFormatterValidator = DateFormatterValidator(_dateTimeUtils, currentDate),
        timeFormatterValidator = TimeFormatterValidator(_dateTimeUtils);

  @override
  DateTimeSeparatedFieldContent run(
    BricksLocalizations localizations,
    String keyString,
    DateTimeSeparatedFieldContent fieldContent,
  ) {
    //
    assert(
        isDateField(keyString) || isTimeField(keyString),
        'DateTimeSeparateFieldFormatterValidator must receive either date or time field keyString '
        '- received "$keyString" is none of those.');

    DateTimeFieldContent dateFieldContent, timeFieldContent;
    FieldContent result;

    if (isDateField(keyString)) {
      dateFieldContent = dateFormatterValidator.run(localizations, keyString, fieldContent);
      timeFieldContent = _formManager.getFieldContent(getTimeKeyString(keyString)) as DateTimeFieldContent;
      result = dateFieldContent;
    } else {
      dateFieldContent = _formManager.getFieldContent(getDateKeyString(keyString)) as DateTimeFieldContent;
      timeFieldContent = timeFormatterValidator.run(localizations, keyString, fieldContent);
      result = timeFieldContent;
    }

    // error in date or time field
    // ------------------------------------------------------------
    if (!result.isValid!) return DateTimeSeparatedFieldContent.err(fieldContent.input, result.error);

    DateTimeTextEditingValue formattedInput = DateTimeTextEditingValue(
      dateFieldContent.input,
      timeFieldContent.input,
    );
    DateTime? date = dateFieldContent.value;
    DateTime? time = timeFieldContent.value;

    // one of the fields is empty - can't compute the value
    // ------------------------------------------------------------
    if (isDateField(keyString)) {
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
            'DateTimeSeparateFieldFormatterValidator must receive either date or time field keyString to cache'
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
            'DateTimeSeparateFieldFormatterValidator must receive either date or time field keyString to cache'
            'elements keyStrings - received "$keyString" is none ');
      }
    }
    return _keyStringTime!;
  }
}
