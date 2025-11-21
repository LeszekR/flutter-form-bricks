import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:intl/intl.dart';

const timeDelimiterPattern = '( |/|-|,|\\.|:|;)';
const timeDelimiter = ':';

class TimeFormatterValidator extends FormatterValidator<String, DateTime> {
  static TimeFormatterValidator? _instance;

  TimeFormatterValidator._(DateTimeUtils dateTimeUtils) {
    _dateTimeUtils = dateTimeUtils;
  }

  factory TimeFormatterValidator(DateTimeUtils dateTimeUtils) {
    _instance ??= TimeFormatterValidator._(dateTimeUtils);
    return _instance!;
  }

  DateTimeUtils? _dateTimeUtils;
  final nMaxDelimiters = 1;

  String makeTimeString(
    BricksLocalizations localizations,
    FieldContent<String, DateTime> fieldContent,
  ) {
    return run(localizations, fieldContent).input!;
  }

  @override
  DateTimeFieldContent run(
    BricksLocalizations localizations,
    FieldContent<String, DateTime> fieldContent, [
    String? keyString,
    FormatValidatePayload? payload,
  ]) {
    DateTimeFieldContent parseResult = _dateTimeUtils!.cleanDateTimeString(
      bricksLocalizations: localizations,
      text: fieldContent.input!,
      dateTimeOrBoth: DateTimeOrBoth.time,
      stringDelimiterPattern: timeDelimiterPattern,
      stringDelimiter: timeDelimiter,
      minNumberOfDigits: 2,
      maxNDigits: 4,
      maxNumberDelimiters: 1,
    );
    if (!parseResult.isValid!) return DateTimeFieldContent.err(fieldContent.input, parseResult.error);

    parseResult = parseTimeFromString(localizations, parseResult);
    if (!parseResult.isValid!) return DateTimeFieldContent.err(fieldContent.input, parseResult.error);

    parseResult = validateTime(localizations, parseResult);

    return parseResult;
  }

  DateTimeFieldContent parseTimeFromString(BricksLocalizations localizations, DateTimeFieldContent fieldContent) {
    String inputString = fieldContent.input!;
    int nDelimiters = RegExp(timeDelimiter).allMatches(inputString).length;

    if (nDelimiters == 0) {
      return makeTimeStringNoDelimiters(localizations, inputString);
    } else {
      return makeTimeStringWithDelimiters(localizations, inputString);
    }
  }

  DateTimeFieldContent makeTimeStringNoDelimiters(BricksLocalizations localizations, String text) {
    if (text.length < 3) return DateTimeFieldContent.err(text, localizations.timeStringErrorTooFewDigits);

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
    return DateTimeFieldContent.transient(formattedResult);
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

    if (errHours.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errHours);
    if (errMinutes.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errMinutes);
    if (errMsg.isNotEmpty) return DateTimeFieldContent.err(timeString, errMsg);

    DateTime time = parseTime(timeString);
    return DateTimeFieldContent.ok(timeString, time);
  }

  DateTime parseTime(String timeString) {
    final timeFormat = DateFormat("HH:mm");
    final time = timeFormat.parseStrict(timeString);
    return time;
  }

  DateTimeFieldContent validateTime(BricksLocalizations localizations, DateTimeFieldContent fieldContent) {
    String timeString = fieldContent.input!;
    List<String> resultList = timeString.split(timeDelimiter);
    String connector = '\n';
    String errMsg = '';
    String errHours = '', errMinutes = '';

    int hour = int.parse(resultList[0]);
    if (hour > 23) errHours = localizations.timeErrorTooBigHour;

    int minute = int.parse(resultList[1]);
    if (minute > 60) errMinutes = localizations.timeErrorTooBigMinute;

    if (errHours.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errHours);
    if (errMinutes.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errMinutes);
    if (errMsg.isNotEmpty) return DateTimeFieldContent.err(timeString, errMsg);

    DateTime time = parseTime(timeString);
    return DateTimeFieldContent.ok(timeString, time);
  }
}
