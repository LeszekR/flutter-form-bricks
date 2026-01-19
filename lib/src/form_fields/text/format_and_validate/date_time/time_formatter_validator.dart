import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/time_stamp.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_time_utils.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:intl/intl.dart';

class TimeFormatterValidator extends FormatterValidator<TextEditingValue, Time> {
  final timeDelimiterPattern = '( |/|-|,|\\.|:|;)';
  final timeDelimiter = ':';

  late final DateTimeUtils _dateTimeUtils;
  late final DateTimeLimits? _dateTimeLimits;
  final nMaxDelimiters = 1;

  TimeFormatterValidator(
    this._dateTimeUtils, [
    this._dateTimeLimits,
  ]);

  @override
  TimeFieldContent run(
    BricksLocalizations localizations,
    String keyString,
    TimeFieldContent fieldContent,
  ) {
    DateTimeFieldContent dateTimeContent = _dateTimeUtils.cleanDateTimeString(
      bricksLocalizations: localizations,
      textEditingValue: fieldContent.input!,
      dateTimeOrBoth: DateTimeOrBoth.time,
      stringDelimiterPattern: timeDelimiterPattern,
      stringDelimiter: timeDelimiter,
      minNumberOfDigits: 2,
      maxNDigits: 4,
      maxNumberDelimiters: 1,
    );
    if (!isValid(dateTimeContent)) return TimeFieldContent.err(fieldContent.input, dateTimeContent.error);

    TimeFieldContent timeContent = _parseTimeFromString(localizations, dateTimeContent);
    if (!isValid(timeContent)) return TimeFieldContent.err(fieldContent.input, timeContent.error);

    timeContent = _validateTime(localizations, timeContent, _dateTimeLimits);

    // TimeFieldContent timeContent = _makeTimeFCFromDateTimeFC(dateTimeContent);
    return timeContent;
  }

  TimeFieldContent _parseTimeFromString(BricksLocalizations localizations, DateTimeFieldContent fieldContent) {
    String inputString = fieldContent.input!.text;
    int nDelimiters = RegExp(timeDelimiter).allMatches(inputString).length;

    if (nDelimiters == 0) {
      return makeTimeStringNoDelimiters(localizations, inputString);
    } else {
      return makeTimeStringWithDelimiters(localizations, inputString);
    }
  }

  TimeFieldContent makeTimeStringNoDelimiters(BricksLocalizations localizations, String text) {
    if (text.length < 3)
      return TimeFieldContent.err(makeTextEditingValue(text), localizations.timeStringErrorTooFewDigits);

    String formattedResult = '';
    String element = '';

    int nElements = 0;
    for (int i = text.length - 2; i >= -1 && nElements <= nMaxDelimiters; i -= 2) {
      nElements++;

      if (i == -1) {
        element = text.substring(0, 1);
        element = '0$element';
      } else if (nElements <= nMaxDelimiters) {
        element = timeDelimiter + text.substring(i, i + 2);
      } else {
        element = text.substring(i, i + 2);
      }
      formattedResult = element + formattedResult;
    }
    return TimeFieldContent.transient(makeTextEditingValue(formattedResult));
  }

  TimeFieldContent makeTimeStringWithDelimiters(BricksLocalizations localizations, String inputString) {
    String timeString = '';
    String element = '';
    List<String> resultList = inputString.split(timeDelimiter);
    int nElements = 0;
    String connector = '\n';
    String errMsg = '';
    String errHours = '', errMinutes = '';
    int elementLength;

    for (int i = nMaxDelimiters; i >= 0; i--) {
      nElements++;

      element = resultList[i];
      elementLength = element.length;

      if (elementLength > 2) {
        if (nElements == 2) errHours = localizations.timeStringErrorTooManyDigitsHours;
        if (nElements == 1) errMinutes = localizations.timeStringErrorTooManyDigitsMinutes;
      }
      if (elementLength == 1) element = '0$element';
      timeString = (i > 0 ? timeDelimiter : '') + element + timeString;
    }

    if (errHours.isNotEmpty) errMsg = _dateTimeUtils.addErrMsg(errMsg, connector, errHours);
    if (errMinutes.isNotEmpty) errMsg = _dateTimeUtils.addErrMsg(errMsg, connector, errMinutes);
    if (errMsg.isNotEmpty) return TimeFieldContent.err(makeTextEditingValue(timeString), errMsg);

    return TimeFieldContent.transient(makeTextEditingValue(timeString));
  }

  DateTime parseTime(String timeString) {
    final timeFormat = DateFormat("HH:mm");
    final time = timeFormat.parseStrict(timeString);
    return time;
  }

  TimeFieldContent _validateTime(
    BricksLocalizations localizations,
    TimeFieldContent fieldContent,
    DateTimeLimits? dateTimeLimits,
  ) {
    TimeFieldContent resultContent;
    String timeString = fieldContent.input!.text;

    resultContent = _validateHourMinuteNumbers(localizations, timeString);
    if (!isValid(resultContent)) return resultContent;

    Time parsedTime = Time.fromString(timeString);
    resultContent = TimeFieldContent.ok(resultContent.input, parsedTime);

    if (dateTimeLimits != null)
      resultContent = _validateTimeLimits(localizations, resultContent, dateTimeLimits, timeString);

    return resultContent;
  }

  TimeFieldContent _validateHourMinuteNumbers(BricksLocalizations localizations, String timeString) {
    List<String> resultList = timeString.split(timeDelimiter);

    String errConnector = '\n';
    String errMsg = '';
    String errHours = '';
    String errMinutes = '';

    int hour = int.parse(resultList[0]);
    if (hour > 23) errHours = localizations.timeErrorTooBigHour;

    int minute = int.parse(resultList[1]);
    if (minute > 60) errMinutes = localizations.timeErrorTooBigMinute;

    if (errHours.isNotEmpty) errMsg = _dateTimeUtils.addErrMsg(errMsg, errConnector, errHours);
    if (errMinutes.isNotEmpty) errMsg = _dateTimeUtils.addErrMsg(errMsg, errConnector, errMinutes);

    if (errMsg.isNotEmpty) return TimeFieldContent.err(makeTextEditingValue(timeString), errMsg);
    return TimeFieldContent.transient(makeTextEditingValue(timeString));
  }

  FieldContent<TextEditingValue, Time> _validateTimeLimits(
    BricksLocalizations localizations,
    TimeFieldContent resultContent,
    DateTimeLimits? dateTimeLimits,
    String timeString,
  ) {
    Time parsedTime = resultContent.value as Time;
    if (dateTimeLimits != null) {
      DateTime? minDateLimit = dateTimeLimits.minDateTime;
      DateTime? maxDateLimit = dateTimeLimits.maxDateTime;

      if (minDateLimit != null && maxDateLimit != null) {
        Date minDate = Date.fromDateTime(minDateLimit);
        Date maxDate = Date.fromDateTime(maxDateLimit);
        Time minTime = Time.fromDateTime(minDateLimit);
        Time maxTime = Time.fromDateTime(maxDateLimit);

        bool minMaxDatesEqual = minDate == maxDate;

        bool minBeforeMaxDate = minDate < maxDate;
        bool minAfterMaxTime = minTime > maxTime;
        bool hasExcludedTimeWindow = minBeforeMaxDate && minAfterMaxTime;

        if (minMaxDatesEqual || hasExcludedTimeWindow) {
          if (parsedTime < minTime)
            return TimeFieldContent.err(makeTextEditingValue(timeString), localizations.timeErrorTooFarBack(minTime.toString()));
          if (parsedTime > maxTime)
            return TimeFieldContent.err(makeTextEditingValue(timeString), localizations.timeErrorTooFarForward(maxTime.toString()));
        }
      }
    }
    return TimeFieldContent.ok(makeTextEditingValue(timeString), parsedTime);
  }

  TimeFieldContent _makeTimeFCFromDateTimeFC(DateTimeFieldContent content) {
    return TimeFieldContent.ok(content.input, Time.fromDateTime(content.value!));
  }

  bool isValid(FieldContent dateContent) {
    return _dateTimeUtils.isValid(dateContent);
  }
}
