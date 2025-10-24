import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/dateTimeRange_validator.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

class ValidatorProvider {

  static final validatorEmail = (BricksLocalizations localizations) {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}$');
    return FormBuilderValidators.match(emailRegex, errorText: localizations.invalidEmail);
  };

  static final validatorVAT = (BricksLocalizations localizations) {
    final RegExp vatRegex = RegExp(r'^[A-Z]{2}\d{10}|[A-Z]{2}[A-Z0-9]{10}$');
    return FormBuilderValidators.match(vatRegex, errorText: localizations.invalidVAT);
  };

  static final validatorRequired = FormBuilderValidators.required();

  //todo add tests
  // TODO refactor to own validators - get rid of external lib form_builder_validators
  static FormFieldValidator<String> compose(
      {required BuildContext context,
      bool? isRequired,
      int? minIntValue,
      int? maxIntValue,
      int? minLength,
      int? maxLength,
      FormFieldValidator<String>? customValidator,
      List<FormFieldValidator<String>>? validatorsList}) {
    final localizations = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;

    final List<FormFieldValidator<String>> validatorsToCompose = [];

    var isCustomRangeValidator = customValidator is DateTimeRangeValidator;

    if (customValidator != null && isCustomRangeValidator) {
      validatorsToCompose.add(customValidator);
    }
    if (isRequired ?? false) {
      validatorsToCompose.add(FormBuilderValidators.required(errorText: localizations.requiredField));
    }
    if (minIntValue != null) {
      validatorsToCompose.add(FormBuilderValidators.min(minIntValue, errorText: localizations.minIntValue(minIntValue)));
    }
    if (maxIntValue != null) {
      validatorsToCompose.add(FormBuilderValidators.max(maxIntValue, errorText: localizations.maxIntValue(maxIntValue)));
    }
    if (minLength != null) {
      validatorsToCompose.add(FormBuilderValidators.minLength(minLength, errorText: localizations.minNChars(minLength)));
    }
    if (maxLength != null) {
      validatorsToCompose.add(FormBuilderValidators.maxLength(maxLength, errorText: localizations.minNChars(maxLength)));
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
