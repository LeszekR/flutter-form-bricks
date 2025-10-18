import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';

import 'date_formatter_validator.dart';
import 'date_time_utils.dart';
import 'time_formatter_validator.dart';

class DateTimeFormatterValidator {
  static DateTimeFormatterValidator? _instance;

  DateTimeFormatterValidator._(
      DateFormatterValidator dateFormatter, TimeFormatterValidator timeFormatter, DateTimeUtils dateTimeInputUtils) {
    _dateFormatter = dateFormatter;
    _timeFormatter = timeFormatter;
  }

  factory DateTimeFormatterValidator(
      DateFormatterValidator dateFormatter, TimeFormatterValidator timeFormatter, DateTimeUtils dateTimeInputUtils) {
    _instance ??= DateTimeFormatterValidator._(dateFormatter, timeFormatter, dateTimeInputUtils);
    return _instance!;
  }

  DateFormatterValidator? _dateFormatter;
  TimeFormatterValidator? _timeFormatter;

  StringParseResult makeDateTimeFromString(String text) {
    var textTrimmed = text;
    textTrimmed = textTrimmed.trim();
    textTrimmed = textTrimmed.replaceAll(RegExp(' +'), ' ');

    var nSpaces = RegExp(' ').allMatches(textTrimmed).length;
    if (nSpaces == 0) return StringParseResult(textTrimmed, false, Tr.get.datetimeStringErrorNoSpace);
    if (nSpaces > 1) return StringParseResult(textTrimmed, false, Tr.get.datetimeStringErrorTooManySpaces);

    var elementsList = textTrimmed.split(RegExp(' '));
    String dateString = elementsList[0];
    String timeString = elementsList[1];

    StringParseResult parseResultDate = _dateFormatter!.makeDateFromString(dateString);
    StringParseResult parseResultTime = _timeFormatter!.makeTimeFromString(timeString);

    var parsedString = '${parseResultDate.parsedString} ${parseResultTime.parsedString}';
    var errorMessageDate = parseResultDate.errorMessage;
    var errorMessageTime = parseResultTime.errorMessage;
    var isStringValidDate = parseResultDate.isStringValid;
    var isStringValidTime = parseResultTime.isStringValid;

    // valid
    if (isStringValidDate && isStringValidTime) return StringParseResult(parsedString, true, '');

    // invalid
    var connector = (!isStringValidDate && !isStringValidTime) ? '\n' : '';
    var errorMessage = '$errorMessageDate$connector$errorMessageTime';
    return StringParseResult(parsedString, false, errorMessage);
  }

  String makeDateTimeString(String text) {
    return makeDateTimeFromString(text).parsedString;
  }
}
