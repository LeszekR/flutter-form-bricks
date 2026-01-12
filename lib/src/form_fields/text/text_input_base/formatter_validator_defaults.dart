import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/time_stamp.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_time_utils.dart';

typedef FormatterValidatorListMaker<I extends Object, V extends Object> = List<FormatterValidator<I, V>> Function();


/// Global, reassignable provider (NOT final) – easy to mock in tests.
FormatterValidatorDefaults formatterValidatorDefaults = FormatterValidatorDefaults();

/// Test-only helper to swap defaults safely.
@visibleForTesting
void setFormatterValidatorDefaultsForTest(FormatterValidatorDefaults replacement) {
  formatterValidatorDefaults = replacement;
}

/// Defaults chosen by **value type V**.
/// Keep these "internal"; the generator will reference the symbols directly.
final class FormatterValidatorDefaults {
  // Date
  List<FormatterValidator<String, Date>> date() => <FormatterValidator<String, Date>>[
        DateFormatterValidator(DateTimeUtils(), CurrentDate()),
      ];

// Add more as you introduce specialized fields:
// static List<FormatterValidator<String, TimeOfDay>> time() => [...];
// static List<FormatterValidator<String, DateTime>> dateTime() => [...];
// static List<FormatterValidator<String, EmailValue>> email() => [...];
}
