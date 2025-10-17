import 'package:flutter/cupertino.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shipping_ui/ui/inputs/date_time/dateTimeRange_validator.dart';

import '../../../../config/string_assets/translation.dart';

class ValidatorProvider {
  static final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}$');
  static final validatorEmail = FormBuilderValidators.match(emailRegex, errorText: Tr.get.invalidEmail);

  static final RegExp vatRegex = RegExp(r'^[A-Z]{2}\d{10}|[A-Z]{2}[A-Z0-9]{10}$');
  static final validatorVAT = FormBuilderValidators.match(vatRegex, errorText: Tr.get.invalidVAT);

  static final validatorRequired = FormBuilderValidators.required();

  //todo add tests
  static FormFieldValidator<String> compose(
      {final bool? isRequired,
      final int? minIntValue,
      final int? maxIntValue,
      final int? minLength,
      final int? maxLength,
      final FormFieldValidator<String>? customValidator,
      final List<FormFieldValidator<String>>? validatorsList}) {
    final List<FormFieldValidator<String>> validatorsToCompose = [];

    var isCustomRangeValidator = customValidator is DateTimeRangeValidator;

    if (customValidator != null && isCustomRangeValidator) {
      validatorsToCompose.add(customValidator);
    }
    if (isRequired ?? false) {
      validatorsToCompose.add(FormBuilderValidators.required(errorText: Tr.get.requiredField));
    }
    if (minIntValue != null) {
      validatorsToCompose.add(FormBuilderValidators.min(minIntValue, errorText: Tr.get.minIntValue(minIntValue)));
    }
    if (maxIntValue != null) {
      validatorsToCompose.add(FormBuilderValidators.max(maxIntValue, errorText: Tr.get.maxIntValue(maxIntValue)));
    }
    if (minLength != null) {
      validatorsToCompose.add(FormBuilderValidators.minLength(minLength, errorText: Tr.get.minNChars(minLength)));
    }
    if (maxLength != null) {
      validatorsToCompose.add(FormBuilderValidators.maxLength(maxLength, errorText: Tr.get.minNChars(maxLength)));
    }
    if (customValidator != null && !isCustomRangeValidator) {
      validatorsToCompose.add(customValidator);
    }
    if (validatorsList != null) {
      validatorsToCompose.addAll(validatorsList);
    }
    assert(validatorsToCompose.isNotEmpty, 'At least one validation is required');
    return validatorsToCompose.length == 1
        ? validatorsToCompose[0]
        : FormBuilderValidators.compose(validatorsToCompose);
  }
}
