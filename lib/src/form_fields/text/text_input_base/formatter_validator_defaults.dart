import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/text/lowercase_formatter.dart';

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
        dateFormatterValidator,
      ];

  // LowerCase
  List<FormatterValidator<String, TextEditingValue>> lowerCase() => <FormatterValidator<String, TextEditingValue>>[
        lowercaseFormatter,
      ];

// Add more as you introduce specialized fields:
}

String? defaultFormValidListMakerForFieldClassName(String? fieldClassName) {
  switch (fieldClassName) {
    case 'DateField':
      return 'formatterValidatorDefaults.date';
    case 'LowerCaseTextField':
      return 'formatterValidatorDefaults.lowerCase';
    // Extend here:
    // case 'TimeField': return 'formatterValidatorDefaults.time';
    // case 'DateTimeField': return 'formatterValidatorDefaults.dateTime';
  }
  return null;
}


// List<FormatterValidator<I,V>> getDefaultFormatterValidator<I extends Object, V extends Object>(String runtimeType) {
//   return switch (runtimeType) {
//     'DateField' => <FormatterValidator<I,V>>[dateFormatterValidator as FormatterValidator<I,V>],
//     'LowerCaseTextField' => <FormatterValidator<I,V>>[lowercaseFormatter as FormatterValidator<I,V>],
//     _ => throw Exception('No default formatter validator for $runtimeType')
//   };
// }
