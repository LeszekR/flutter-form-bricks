import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/form_fields/components/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/utils/string_extension.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/utils/date_time_extension.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_utils.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:intl/intl.dart';

class TimeFormatterValidator extends FormatterValidator<TextEditingValue, DateTime> {
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
  DateTimeFieldContent run(
    BricksLocalizations localizations,
    String keyString,
    TextEditingValue? input,
  ) {
    if (input == null) return const DateTimeFieldContent.ok(null, null);
    if (input.text.isEmpty) return DateTimeFieldContent.ok(''.toTextEditingValue(), null);

    DateTimeFieldContent dateTimeContent = _dateTimeUtils.cleanDateTimeString(
      bricksLocalizations: localizations,
      textEditingValue: input!,
      dateTimeOrBoth: DateTimeOrBoth.time,
      stringDelimiterPattern: timeDelimiterPattern,
      stringDelimiter: timeDelimiter,
      minNumberOfDigits: 2,
      maxNDigits: 4,
      maxNumberDelimiters: 1,
    );
    if (!isValid(dateTimeContent)) return DateTimeFieldContent.err(input, dateTimeContent.error);

    DateTimeFieldContent timeContent = _parseTimeFromString(localizations, dateTimeContent);
    if (!isValid(timeContent)) return DateTimeFieldContent.err(input, timeContent.error);

    timeContent = _validateTime(localizations, timeContent, _dateTimeLimits);

    // DateTimeFieldContent timeContent = _makeTimeFCFromDateTimeFC(dateTimeContent);
    return timeContent;
  }

  DateTimeFieldContent _parseTimeFromString(BricksLocalizations localizations, DateTimeFieldContent fieldContent) {
    String inputString = fieldContent.input!.text;
    int nDelimiters = RegExp(timeDelimiter).allMatches(inputString).length;

    if (nDelimiters == 0) {
      return makeTimeStringNoDelimiters(localizations, inputString);
    } else {
      return makeTimeStringWithDelimiters(localizations, inputString);
    }
  }

  DateTimeFieldContent makeTimeStringNoDelimiters(BricksLocalizations localizations, String text) {
    if (text.length < 3)
      return DateTimeFieldContent.err(text.toTextEditingValue(), localizations.timeStringErrorTooFewDigits);

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
    return DateTimeFieldContent.transient(formattedResult.toTextEditingValue());
  }

  DateTimeFieldContent makeTimeStringWithDelimiters(BricksLocalizations localizations, String inputString) {
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
    if (errMsg.isNotEmpty) return DateTimeFieldContent.err(timeString.toTextEditingValue(), errMsg);

    return DateTimeFieldContent.transient(timeString.toTextEditingValue());
  }

  DateTime parseTime(String timeString) {
    final timeFormat = DateFormat("HH:mm");
    final time = timeFormat.parseStrict(timeString);
    return time;
  }

  DateTimeFieldContent _validateTime(
    BricksLocalizations localizations,
    DateTimeFieldContent fieldContent,
    DateTimeLimits? dateTimeLimits,
  ) {
    DateTimeFieldContent resultContent;
    String timeString = fieldContent.input!.text;

    resultContent = _validateHourMinuteNumbers(localizations, timeString);
    if (!isValid(resultContent)) return resultContent;

    DateTime parsedTime = _dateTimeUtils.timeMinutePrecisionFromString(timeString);
    resultContent = DateTimeFieldContent.ok(resultContent.input, parsedTime);

    if (dateTimeLimits != null)
      resultContent = _validateTimeLimits(localizations, resultContent, dateTimeLimits, timeString);

    return resultContent;
  }

  DateTimeFieldContent _validateHourMinuteNumbers(BricksLocalizations localizations, String timeString) {
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

    if (errMsg.isNotEmpty) return DateTimeFieldContent.err(timeString.toTextEditingValue(), errMsg);
    return DateTimeFieldContent.transient(timeString.toTextEditingValue());
  }

  FieldContent<TextEditingValue, DateTime> _validateTimeLimits(
    BricksLocalizations localizations,
    DateTimeFieldContent resultContent,
    DateTimeLimits? dateTimeLimits,
    String timeString,
  ) {
    DateTime parsedTime = resultContent.value!;
    if (dateTimeLimits != null) {
      DateTime? minDateLimit = dateTimeLimits.minDateTime;
      DateTime? maxDateLimit = dateTimeLimits.maxDateTime;

      if (minDateLimit != null && maxDateLimit != null) {
        DateTime minDate = _dateTimeUtils.fromDateTime(minDateLimit);
        DateTime maxDate = _dateTimeUtils.fromDateTime(maxDateLimit);
        DateTime minTime = _dateTimeUtils.fromDateTime(minDateLimit);
        DateTime maxTime = _dateTimeUtils.fromDateTime(maxDateLimit);

        bool minMaxDatesEqual = minDate == maxDate;

        bool minBeforeMaxDate = minDate.isBefore(maxDate);
        bool minAfterMaxTime = minTime.isAfter(maxTime);
        bool hasExcludedTimeWindow = minBeforeMaxDate && minAfterMaxTime;

        if (minMaxDatesEqual || hasExcludedTimeWindow) {
          if (parsedTime.isBefore(minTime))
            return DateTimeFieldContent.err(
              timeString.toTextEditingValue(),
              localizations.timeErrorTooFarBack(minTime.toTimeStringMinutePrecision()),
            );
          if (parsedTime.isAfter(maxTime))
            return DateTimeFieldContent.err(
              timeString.toTextEditingValue(),
              localizations.timeErrorTooFarForward(maxTime.toTimeStringMinutePrecision()),
            );
        }
      }
    }
    return DateTimeFieldContent.ok(timeString.toTextEditingValue(), parsedTime);
  }

  DateTimeFieldContent _makeTimeFCFromDateTimeFC(DateTimeFieldContent content) {
    return DateTimeFieldContent.ok(content.input, _dateTimeUtils.fromDateTime(content.value!));
  }

  bool isValid(FieldContent dateContent) {
    return _dateTimeUtils.isValid(dateContent);
  }
}
