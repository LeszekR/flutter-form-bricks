import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:intl/intl.dart';

class TimeFormatterValidator {
  static TimeFormatterValidator? _instance;

  TimeFormatterValidator._(DateTimeUtils dateTimeUtils) {
    _dateTimeUtils = dateTimeUtils;
  }

  factory TimeFormatterValidator(DateTimeUtils dateTimeUtils) {
    _instance ??= TimeFormatterValidator._(dateTimeUtils);
    return _instance!;
  }

  DateTimeUtils? _dateTimeUtils;
  static const timeDelimiterPattern = '( |/|-|,|\\.|:|;)';
  static const timeDelimiter = ':';
  final nMaxDelimiters = 1;

  String makeTimeString(BricksLocalizations localizations, String inputString) {
    return makeTimeFromString(localizations, inputString).parsedString;
  }

  StringParseResult makeTimeFromString(BricksLocalizations localizations, String inputString) {
    StringParseResult parseResult = _dateTimeUtils!.cleanDateTimeString(
      bricksLocalizations: localizations,
      text: inputString,
      dateTimeOrBoth: DateTimeOrBoth.TIME,
      stringDelimiterPattern: timeDelimiterPattern,
      stringDelimiter: timeDelimiter,
      minNumberOfDigits: 2,
      maxNDigits: 4,
      maxNumberDelimiters: 1,
    );
    if (!parseResult.isStringValid) return StringParseResult.err(inputString, null, parseResult.errorMessage);

    parseResult = parseTimeFromString(localizations, parseResult);
    if (!parseResult.isStringValid) return StringParseResult.err(inputString, null, parseResult.errorMessage);

    parseResult = validateTime(localizations, parseResult);

    return parseResult;
  }

  StringParseResult parseTimeFromString(BricksLocalizations localizations, StringParseResult stringParseResult) {
    var inputString = stringParseResult.parsedString;
    var nDelimiters = RegExp(timeDelimiter).allMatches(inputString).length;

    if (nDelimiters == 0) {
      return makeTimeStringNoDelimiters(localizations, inputString);
    } else {
      return makeTimeStringWithDelimiters(localizations, inputString);
    }
  }

  StringParseResult makeTimeStringNoDelimiters(BricksLocalizations localizations, String text) {
    if (text.length < 3) return StringParseResult.err(text, null, localizations.timeStringErrorTooFewDigits);

    String formattedResult = '';
    String element = '';

    var nElements = 0;
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
    return StringParseResult.transient(formattedResult);
  }

  StringParseResult makeTimeStringWithDelimiters(BricksLocalizations localizations, String inputString) {
    var timeString = '';
    var element = '';
    var resultList = inputString.split(timeDelimiter);
    var nElements = 0;
    var connector = '\n';
    var errMsg = '';
    var errHours = '', errMinutes = '';
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
    if (errMsg.isNotEmpty) return StringParseResult.err(timeString, null, errMsg);

    DateTime time = parseTime(timeString);
    return StringParseResult.ok(timeString, time);
  }

  DateTime parseTime(String timeString) {
    final timeFormat = DateFormat("HH:mm");
    final time = timeFormat.parseStrict(timeString);
    return time;
  }

  StringParseResult validateTime(BricksLocalizations localizations, StringParseResult stringParseResult) {
    var timeString = stringParseResult.parsedString;
    var resultList = timeString.split(timeDelimiter);
    var connector = '\n';
    var errMsg = '';
    var errHours = '', errMinutes = '';

    var hour = int.parse(resultList[0]);
    if (hour > 23) errHours = localizations.timeErrorTooBigHour;

    var minute = int.parse(resultList[1]);
    if (minute > 60) errMinutes = localizations.timeErrorTooBigMinute;

    if (errHours.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errHours);
    if (errMinutes.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errMinutes);
    if (errMsg.isNotEmpty) return StringParseResult.err(timeString, null, errMsg);

    DateTime time = parseTime(timeString);
    return StringParseResult.ok(timeString, time);
  }
}
