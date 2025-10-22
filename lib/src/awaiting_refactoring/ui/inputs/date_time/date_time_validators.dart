import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/dateTimeRange_validator.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/dateTime_formatter_validator.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/dateTime_range_error_controller.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/time_formatter_validator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

typedef ValidatorFunction = String? Function(String);

class DateTimeValidators {
  // TODO - move to DI !
  static final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  static final CurrentDate _currentDate = CurrentDate();
  static final DateFormatterValidator _dateFormatter = DateFormatterValidator(_dateTimeUtils, _currentDate);
  static final TimeFormatterValidator _timeFormatter = TimeFormatterValidator(_dateTimeUtils);
  static final DateTimeFormatterValidator _dateTimeFormatter =
      DateTimeFormatterValidator(_dateFormatter, _timeFormatter, _dateTimeUtils);

  DateTimeValidators._();

  static FormFieldValidator<String> dateInputValidator(BricksLocalizations localizations, DateTimeLimits dateLimits) {
    ValidatorFunction validator =
        (String inputString) => _dateFormatter.makeDateFromString(localizations, inputString, dateLimits).errorMessage;
    return (inputString) => validate(inputString, validator);
  }

  static FormFieldValidator<String> timeInputValidator(BricksLocalizations localizations) {
    ValidatorFunction validator =
        (inputString) => _timeFormatter.makeTimeFromString(localizations, inputString).errorMessage;
    return (inputString) => validate(inputString, validator);
  }

  static FormFieldValidator<String> dateTimeInputValidator(
    BricksLocalizations localizations,
    DateTimeLimits dateLimits,
  ) {
    ValidatorFunction validator = (inputString) => _dateTimeFormatter
        .makeDateTimeFromString(
          localizations,
          inputString,
          dateLimits,
        )
        .errorMessage!;
    return (inputString) => validate(inputString, validator);
  }

  // TODO test
  static FormFieldValidator<String> dateTimeRangeValidator(
    BricksLocalizations localizations,
    String keyString,
    FormManagerOLD formManager,
    RangeController errorController,
    int maxRangeSpanDays,
    int minRangeSpanMinutes,
  ) {
    return DateTimeRangeValidator(
      localizations,
      keyString,
      formManager,
      errorController,
      maxRangeSpanDays,
      minRangeSpanMinutes,
    ).validator;
  }

  static getFieldInputString(GlobalKey<FormBuilderState> formKey, String rangeStartDateKey) =>
      formKey.currentState?.fields[rangeStartDateKey]?.value ?? "";

  static String? validate(String? inputString, String? Function(String inputString) validator) {
    if (inputString == null || inputString.isEmpty) return null;
    String? errorMessage = validator.call(inputString);
    return errorMessage == null || errorMessage.isEmpty ? null : errorMessage;
  }
}
