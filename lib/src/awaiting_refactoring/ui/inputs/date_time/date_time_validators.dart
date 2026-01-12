// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
// import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/current_date.dart';
// import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
// import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_range_span.dart';
// import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_utils.dart';
// import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/dateTimeRange_formatter_validator.dart';
// import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/dateTime_formatter_validator.dart';
// import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/dateTime_range_controller.dart';
// import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_formatter_validator.dart';
// import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/time_formatter_validator.dart';
// import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
//
// typedef ValidatorFunction = String? Function(String);
//
// class DateTimeValidators {
//   // TODO - move to DI !
//   static final DateTimeUtils _dateTimeUtils = DateTimeUtils();
//   static final CurrentDate _currentDate = CurrentDate();
//   static final DateFormatterValidator _dateFormatter = DateFormatterValidator(_dateTimeUtils, _currentDate);
//   static final TimeFormatterValidator _timeFormatter = TimeFormatterValidator(_dateTimeUtils);
//   static final DateTimeFormatterValidator _dateTimeFormatter =
//       DateTimeFormatterValidator(_dateFormatter, _timeFormatter, _dateTimeUtils);
//
//   DateTimeValidators._();
//
//   static FormFieldValidator<String> dateInputValidator(BricksLocalizations localizations, DateTimeLimits? dateLimits) {
//     ValidatorFunction validator =
//         (String inputString) => _dateFormatter.run(localizations, inputString, dateLimits).error;
//     return (inputString) => validate(inputString, validator);
//   }
//
//   static FormFieldValidator<String> timeInputValidator(BricksLocalizations localizations) {
//     ValidatorFunction validator =
//         (inputString) => _timeFormatter.makeTimeFromString(localizations, inputString).error;
//     return (inputString) => validate(inputString, validator);
//   }
//
//   static FormFieldValidator<String> dateTimeInputValidator(
//     BricksLocalizations localizations,
//     DateTimeLimits dateLimits,
//   ) {
//     ValidatorFunction validator = (inputString) => _dateTimeFormatter
//         .makeDateTimeFromString(
//           localizations,
//           inputString,
//           dateLimits,
//         )
//         .error!;
//     return (inputString) => validate(inputString, validator);
//   }
//
//   // TODO test
//   static FormFieldValidator<String> dateTimeRangeValidator(
//     BricksLocalizations localizations,
//     String keyString,
//     FormManager formManager,
//     // RangeController errorController,
//     DateTimeLimits? dateTimeLimits,
//     DateTimeRangeSpan? dateTimeRangeSpan,
//   ) {
//     return DateTimeRangeFormatterValidator(
//       localizations,
//       keyString,
//       formManager,
//       // errorController,
//       dateTimeLimits,
//       dateTimeRangeSpan,
//     ).validator;
//   }
//
//   static String? validate(String? inputString, String? Function(String inputString) validator) {
//     if (inputString == null || inputString.isEmpty) return null;
//     String? errorMessage = validator.run(inputString);
//     return errorMessage == null || errorMessage.isEmpty ? null : errorMessage;
//   }
// }
