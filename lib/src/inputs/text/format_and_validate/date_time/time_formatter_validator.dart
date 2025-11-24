import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/time_stamp.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:intl/intl.dart';

const timeDelimiterPattern = '( |/|-|,|\\.|:|;)';
const timeDelimiter = ':';

class TimeFormatterValidator extends FormatterValidator<String, Time> {
  late final DateTimeUtils _dateTimeUtils;
  late final DateTimeLimits? _dateTimeLimits;
  final nMaxDelimiters = 1;

  TimeFormatterValidator(
    this._dateTimeUtils,
    [this._dateTimeLimits,]
  );

  @override
  TimeFieldContent run(
    BricksLocalizations localizations,
    String keyString,
    TimeFieldContent fieldContent,
  ) {
    TimeFieldContent parseResult = _dateTimeUtils.cleanDateTimeString(
      bricksLocalizations: localizations,
      text: fieldContent.input!,
      dateTimeOrBoth: DateTimeOrBoth.time,
      stringDelimiterPattern: timeDelimiterPattern,
      stringDelimiter: timeDelimiter,
      minNumberOfDigits: 2,
      maxNDigits: 4,
      maxNumberDelimiters: 1,
    ) as TimeFieldContent;
    if (!parseResult.isValid!) return TimeFieldContent.err(fieldContent.input, parseResult.error);

    parseResult = parseTimeFromString(localizations, parseResult);
    if (!parseResult.isValid!) return TimeFieldContent.err(fieldContent.input, parseResult.error);

    parseResult = _validateTime(localizations, parseResult, _dateTimeLimits);

    return parseResult;
  }

  TimeFieldContent parseTimeFromString(BricksLocalizations localizations, TimeFieldContent fieldContent) {
    String inputString = fieldContent.input!;
    int nDelimiters = RegExp(timeDelimiter).allMatches(inputString).length;

    if (nDelimiters == 0) {
      return makeTimeStringNoDelimiters(localizations, inputString);
    } else {
      return makeTimeStringWithDelimiters(localizations, inputString);
    }
  }

  TimeFieldContent makeTimeStringNoDelimiters(BricksLocalizations localizations, String text) {
    if (text.length < 3) return TimeFieldContent.err(text, localizations.timeStringErrorTooFewDigits);

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
    return TimeFieldContent.transient(formattedResult);
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
    if (errMsg.isNotEmpty) return TimeFieldContent.err(timeString, errMsg);

    Time parsedTime = Time.fromString(timeString);
    return TimeFieldContent.ok(timeString, parsedTime);
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
    String timeString = fieldContent.input!;

    TimeFieldContent resultContent = _validateHourMinuteNumbers(localizations, timeString);
    if (!resultContent.isValid!) return resultContent;

    if (dateTimeLimits == null) return resultContent;
    return _validateTimeLimits(localizations, resultContent, dateTimeLimits, timeString);
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
    if (errMsg.isNotEmpty) return TimeFieldContent.err(timeString, errMsg);

    Time parsedTime = Time.fromString(timeString);
    return TimeFieldContent.ok(timeString, parsedTime);
  }

  FieldContent<String, Time> _validateTimeLimits(
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
            return TimeFieldContent.err(timeString, localizations.timeErrorTooFarBack(minTime.toString()));
          if (parsedTime > maxTime)
            return TimeFieldContent.err(timeString, localizations.timeErrorTooFarForward(maxTime.toString()));
        }
      }
    }
    return TimeFieldContent.ok(timeString, parsedTime);
  }
}
