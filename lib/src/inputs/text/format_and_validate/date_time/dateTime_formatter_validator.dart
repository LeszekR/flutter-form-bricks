import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/format_validate_components.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

import 'date_formatter_validator.dart';

class DateTimeFormatterValidator extends FormatterValidator<String, DateTime, DateTimeFormatterValidatorPayload> {
  static DateTimeFormatterValidator? _instance;

  DateTimeFormatterValidator._(
    DateFormatterValidator dateFormatter,
    TimeFormatterValidator timeFormatter,
    DateTimeUtils dateTimeUtils,
  ) {
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

  // String makeDateTimeString(
  //   BricksLocalizations localizations,
  //   CurrentDate currentDate,
  //   String inputString,
  //   DateTimeLimits dateLimits,
  // ) {
  //   return makeDateTimeFromString(localizations, inputString, dateLimits).input!;
  // }
  //
  DateTimeFieldContent run(
    BricksLocalizations localizations,
    DateTimeFieldContent fieldContent, [
    String? keyString,
    DateTimeFormatterValidatorPayload? limitsCarrier,
  ]) {
    String textTrimmed = fieldContent.input!;
    textTrimmed = textTrimmed.trim();
    textTrimmed = textTrimmed.replaceAll(RegExp(' +'), ' ');

    var nSpaces = RegExp(' ').allMatches(textTrimmed).length;
    if (nSpaces == 0) return DateTimeFieldContent.err(textTrimmed, localizations.datetimeStringErrorNoSpace);
    if (nSpaces > 1) return DateTimeFieldContent.err(textTrimmed, localizations.datetimeStringErrorTooManySpaces);

    var elementsList = textTrimmed.split(RegExp(' '));
    String dateString = elementsList[0];
    String timeString = elementsList[1];

    DateTimeFieldContent parseResultDate = _dateFormatter!.run(localizations, fieldContent,  limitsCarrier);
    DateTimeFieldContent parseResultTime = _timeFormatter!.run(localizations, fieldContent,  limitsCarrier);

    var parsedString = '${parseResultDate.input} ${parseResultTime.input}';
    var errorMessageDate = parseResultDate.error;
    var errorMessageTime = parseResultTime.error;
    var isStringValidDate = parseResultDate.isValid!;
    var isStringValidTime = parseResultTime.isValid!;

    // valid
    if (isStringValidDate && isStringValidTime) {
      DateTime dateTime = DateTime.parse(parsedString);
      return DateTimeFieldContent.ok(parsedString, dateTime);
    }

    // invalid
    var connector = (!isStringValidDate && !isStringValidTime) ? '\n' : '';
    var errorMessage = '$errorMessageDate$connector$errorMessageTime';
    return DateTimeFieldContent.err(parsedString, errorMessage);
  }
}
