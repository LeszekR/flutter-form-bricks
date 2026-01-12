import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_time_utils.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

import 'date_formatter_validator.dart';

class DateTimeFormatterValidator extends FormatterValidator<String, DateTime> {
  final DateFormatterValidator _dateFormatterValidator;
  final TimeFormatterValidator _timeFormatterValidator;

  DateTimeFormatterValidator(
    DateTimeUtils _dateTimeUtils,
    CurrentDate _currentDate,
    DateTimeLimits? _dateTimeLimits,
  )   : _dateFormatterValidator = DateFormatterValidator(_dateTimeUtils, _currentDate, _dateTimeLimits),
        _timeFormatterValidator = TimeFormatterValidator(_dateTimeUtils, _dateTimeLimits);

  DateTimeFieldContent run(
    BricksLocalizations localizations,
    String keyString,
    DateTimeFieldContent fieldContent,
  ) {
    String textTrimmed = fieldContent.input!;
    textTrimmed = textTrimmed.trim();
    textTrimmed = textTrimmed.replaceAll(RegExp(' +'), ' ');

    var nSpaces = RegExp(' ').allMatches(textTrimmed).length;
    if (nSpaces == 0) return DateTimeFieldContent.err(textTrimmed, localizations.datetimeStringErrorNoSpace);
    if (nSpaces > 1) return DateTimeFieldContent.err(textTrimmed, localizations.datetimeStringErrorTooManySpaces);

    var elementsList = textTrimmed.split(RegExp(' '));
    DateFieldContent dateFieldContent = DateFieldContent.transient(elementsList[0]);
    TimeFieldContent timeFieldContent = TimeFieldContent.transient(elementsList[1]);

    DateFieldContent parseResultDate = _dateFormatterValidator.run(localizations, keyString, dateFieldContent);
    TimeFieldContent parseResultTime = _timeFormatterValidator.run(localizations, keyString, timeFieldContent);

    var parsedString = '${parseResultDate.input} ${parseResultTime.input}';
    var errorMessageDate = parseResultDate.error ?? '';
    var errorMessageTime = parseResultTime.error ?? '';
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
