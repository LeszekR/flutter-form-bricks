import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

import 'date_formatter_validator.dart';
import 'time_formatter_validator.dart';

class DateTimeFormatterValidator {
  static DateTimeFormatterValidator? _instance;

  DateTimeFormatterValidator._(
      DateFormatterValidator dateFormatter, TimeFormatterValidator timeFormatter, DateTimeUtils dateTimeUtils) {
    _dateFormatter = dateFormatter;
    _timeFormatter = timeFormatter;
  }

  factory DateTimeFormatterValidator(
      DateFormatterValidator dateFormatter, TimeFormatterValidator timeFormatter, DateTimeUtils dateTimeUtils) {
    _instance ??= DateTimeFormatterValidator._(dateFormatter, timeFormatter, dateTimeUtils);
    return _instance!;
  }

  DateFormatterValidator? _dateFormatter;
  TimeFormatterValidator? _timeFormatter;

  String makeDateTimeString(
    BricksLocalizations localizations,
    CurrentDate currentDate,
    String inputString,
    DateTimeLimits dateLimits,
  ) {
    return makeDateTimeFromString(localizations, inputString, dateLimits).parsedString;
  }

  StringParseResult makeDateTimeFromString(
    BricksLocalizations localizations,
    String inputString,
    DateTimeLimits dateLimits,
  ) {
    var textTrimmed = inputString;
    textTrimmed = textTrimmed.trim();
    textTrimmed = textTrimmed.replaceAll(RegExp(' +'), ' ');

    var nSpaces = RegExp(' ').allMatches(textTrimmed).length;
    if (nSpaces == 0) return StringParseResult(textTrimmed, false, localizations.datetimeStringErrorNoSpace);
    if (nSpaces > 1) return StringParseResult(textTrimmed, false, localizations.datetimeStringErrorTooManySpaces);

    var elementsList = textTrimmed.split(RegExp(' '));
    String dateString = elementsList[0];
    String timeString = elementsList[1];

    StringParseResult parseResultDate = _dateFormatter!.makeDateFromString(localizations, dateString, dateLimits);
    StringParseResult parseResultTime = _timeFormatter!.makeTimeFromString(localizations, timeString);

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
}
