import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../forms/form_manager/form_manager.dart';
import 'current_date.dart';
import 'dateTimeRange_validator.dart';
import 'dateTime_formatter_validator.dart';
import 'dateTime_range_error_controller.dart';
import 'date_formatter_validator.dart';
import 'date_time_utils.dart';
import 'time_formatter_validator.dart';

class DateTimeValidators {
  // TODO - move to DI !
  static final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  static final CurrentDate _currentDate = CurrentDate();
  static final DateFormatterValidator _dateFormatter = DateFormatterValidator(_dateTimeUtils, _currentDate);
  static final TimeFormatterValidator _timeFormatter = TimeFormatterValidator(_dateTimeUtils);
  static final DateTimeFormatterValidator _dateTimeFormatter =
      DateTimeFormatterValidator(_dateFormatter, _timeFormatter, _dateTimeUtils);

  DateTimeValidators._();

  static FormFieldValidator<String> dateInputValidator() {
    validator(text) => _dateFormatter.makeDateFromString(text).errorMessage!;
    return (text) => getErrorMessage(text, validator);
  }

  static FormFieldValidator<String> timeInputValidator() {
    validator(text) => _timeFormatter.makeTimeFromString(text).errorMessage;
    return (text) => getErrorMessage(text, validator);
  }

  static FormFieldValidator<String> dateTimeInputValidator() {
    validator(text) => _dateTimeFormatter.makeDateTimeFromString(text).errorMessage!;
    return (text) => getErrorMessage(text, validator);
  }

  // TODO test
  static FormFieldValidator<String> dateTimeRangeValidator(
    final String keyString,
    final FormManagerOLD formManager,
    final RangeController errorController,
  ) {
    return DateTimeRangeValidator(keyString, formManager, errorController).validator;
  }

  static getFieldText(GlobalKey<FormBuilderState> formKey, String rangeStartDateKey) =>
      formKey.currentState?.fields[rangeStartDateKey]?.value ?? "";

  static String? getErrorMessage(String? text, String Function(String text) validator) {
    if (text == null || text.isEmpty) return null;
    var errorMessage = validator.call(text);
    return errorMessage.isEmpty ? null : errorMessage;
  }
}
