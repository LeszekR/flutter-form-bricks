import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/form_fields/components/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/string_extension.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_utils.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

import 'date_formatter_validator.dart';

class DateTimeFormatterValidator extends FormatterValidator<TextEditingValue, DateTime> {
  final DateFormatterValidator _dateFormatterValidator;
  final TimeFormatterValidator _timeFormatterValidator;

  DateTimeFormatterValidator(
    DateTimeUtils _dateTimeUtils,
    CurrentDate _currentDate,[
    DateTimeLimits? _dateTimeLimits,]
  )   : _dateFormatterValidator = DateFormatterValidator(_dateTimeUtils, _currentDate, _dateTimeLimits),
        _timeFormatterValidator = TimeFormatterValidator(_dateTimeUtils, _dateTimeLimits);

  DateTimeFieldContent run(
    BricksLocalizations localizations,
    String keyString,
    DateTimeFieldContent fieldContent,
  ) {
    String textTrimmed = fieldContent.input!.text;
    textTrimmed = textTrimmed.trim();
    textTrimmed = textTrimmed.replaceAll(RegExp(' +'), ' ');

    var nSpaces = RegExp(' ').allMatches(textTrimmed).length;
    if (nSpaces == 0)
      return DateTimeFieldContent.err(textTrimmed.txtEditVal(), localizations.datetimeStringErrorNoSpace);
    if (nSpaces > 1)
      return DateTimeFieldContent.err(textTrimmed.txtEditVal(), localizations.datetimeStringErrorTooManySpaces);

    var elementsList = textTrimmed.split(RegExp(' '));
    DateTimeFieldContent dateFieldContent = DateTimeFieldContent.transient(elementsList[0].txtEditVal());
    DateTimeFieldContent timeFieldContent = DateTimeFieldContent.transient(elementsList[1].txtEditVal());

    DateTimeFieldContent parseResultDate = _dateFormatterValidator.run(localizations, keyString, dateFieldContent);
    DateTimeFieldContent parseResultTime = _timeFormatterValidator.run(localizations, keyString, timeFieldContent);

    var parsedString = '${parseResultDate.input?.text} ${parseResultTime.input?.text}';
    var errorMessageDate = parseResultDate.error ?? '';
    var errorMessageTime = parseResultTime.error ?? '';
    var isStringValidDate = parseResultDate.isValid!;
    var isStringValidTime = parseResultTime.isValid!;

    // valid
    if (isStringValidDate && isStringValidTime) {
      DateTime dateTime = DateTime.parse(parsedString);
      return DateTimeFieldContent.ok(parsedString.txtEditVal(), dateTime);
    }

    // invalid
    var connector = (!isStringValidDate && !isStringValidTime) ? '\n' : '';
    var errorMessage = '$errorMessageDate$connector$errorMessageTime';
    return DateTimeFieldContent.err(parsedString.txtEditVal(), errorMessage);
  }
}
