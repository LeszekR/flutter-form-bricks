import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';

import 'date_time_utils.dart';

class TimeFormatterValidator {
  static TimeFormatterValidator? _instance;

  TimeFormatterValidator._(DateTimeUtils dateTimeInputUtils) {
    _dateTimeUtils = dateTimeInputUtils;
  }

  factory TimeFormatterValidator(DateTimeUtils dateTimeInputUtils) {
    _instance ??= TimeFormatterValidator._(dateTimeInputUtils);
    return _instance!;
  }

  DateTimeUtils? _dateTimeUtils;
  static const timeDelimiterPattern = '( |/|-|,|\\.|:|;)';
  static const timeDelimiter = ':';
  final nMaxDelimiters = 1;

  StringParseResult makeTimeFromString(String text) {
    StringParseResult parseResult = _dateTimeUtils!.cleanDateTimeString(
      text: text,
      eDateTime: EDateTime.TIME,
      stringDelimiterPattern: timeDelimiterPattern,
      stringDelimiter: timeDelimiter,
      minNumberOfDigits: 2,
      maxNDigits: 4,
      maxNumberDelimiters: 1,
    );
    if (!parseResult.isStringValid) return StringParseResult(text, false, parseResult.errorMessage);

    parseResult = parseTimeFromString(parseResult);
    if (!parseResult.isStringValid) return StringParseResult(text, false, parseResult.errorMessage);

    parseResult = validateTime(parseResult);
    if (!parseResult.isStringValid) return parseResult;

    return parseResult;
  }

  StringParseResult parseTimeFromString(StringParseResult stringParseResult) {
    var text = stringParseResult.parsedString;
    var nDelimiters = RegExp(timeDelimiter).allMatches(text).length;

    if (nDelimiters == 0) {
      return makeTimeStringNoDelimiters(text);
    } else {
      return makeTimeStringWithDelimiters(text);
    }
  }

  StringParseResult makeTimeStringNoDelimiters(String text) {
    if (text.length < 3) return StringParseResult(text, false, Tr.get.timeStringErrorTooFewDigits);

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
    return StringParseResult(formattedResult, true, '');
  }

  StringParseResult makeTimeStringWithDelimiters(String text) {
    var timeString = '';
    var element = '';
    var resultList = text.split(timeDelimiter);
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
        if (nElements == 2) errHours = Tr.get.timeStringErrorTooManyDigitsHours;
        if (nElements == 1) errMinutes = Tr.get.timeStringErrorTooManyDigitsMinutes;
      }
      if (elementLength == 1) element = '0$element';
      timeString = (i > 0 ? timeDelimiter : '') + element + timeString;
    }

    if (errHours.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errHours);
    if (errMinutes.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errMinutes);
    if (errMsg.isNotEmpty) return StringParseResult(timeString, false, errMsg);

    return StringParseResult(timeString, true, '');
  }

  StringParseResult validateTime(StringParseResult stringParseResult) {
    var timeString = stringParseResult.parsedString;
    var resultList = timeString.split(timeDelimiter);
    var connector = '\n';
    var errMsg = '';
    var errHours = '', errMinutes = '';

    var hour = int.parse(resultList[0]);
    if (hour > 23) errHours = Tr.get.timeErrorTooBigHour;

    var minute = int.parse(resultList[1]);
    if (minute > 60) errMinutes = Tr.get.timeErrorTooBigMinute;

    if (errHours.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errHours);
    if (errMinutes.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errMinutes);
    if (errMsg.isNotEmpty) return StringParseResult(timeString, false, errMsg);

    return StringParseResult(timeString, true, '');
  }

  String makeTimeString(String text) {
    return makeTimeFromString(text).parsedString;
  }
}
