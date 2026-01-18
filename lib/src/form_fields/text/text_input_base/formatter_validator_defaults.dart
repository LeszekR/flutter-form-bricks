import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/time_stamp.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/text/lowercase_formatter.dart';

typedef FormatterValidatorListMaker<I extends Object, V extends Object> = List<FormatterValidator<I, V>> Function();

/// Global, reassignable provider (NOT final) – easy to mock in tests.
FormatterValidatorDefaults formatterValidatorDefaults = FormatterValidatorDefaults();

@visibleForTesting
void setFormatterValidatorDefaultsForTest(FormatterValidatorDefaults replacement) {
  formatterValidatorDefaults = replacement;
}

/// Defaults chosen by **value type V**.
/// Keep these "internal"; the generator will reference the symbols directly.
final class FormatterValidatorDefaults {
  FormatterValidatorListMaker<String, Date> date =
      () => <FormatterValidator<String, Date>>[
        dateFormatterValidator,
      ];

  FormatterValidatorListMaker<String, TextEditingValue> lowerCase =
      () => <FormatterValidator<String, TextEditingValue>>[
            lowercaseFormatter,
          ];

// Add more as you introduce specialized fields:
}

// List<FormatterValidator<I,V>> getDefaultFormatterValidator<I extends Object, V extends Object>(String runtimeType) {
//   return switch (runtimeType) {
//     'DateField' => <FormatterValidator<I,V>>[dateFormatterValidator as FormatterValidator<I,V>],
//     'LowerCaseTextField' => <FormatterValidator<I,V>>[lowercaseFormatter as FormatterValidator<I,V>],
//     _ => throw Exception('No default formatter validator for $runtimeType')
//   };
// }
