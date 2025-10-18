import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/dateTimeRange_validator.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ValidatorProvider {
  static final validatorEmail = (BuildContext context) {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}$');
    final txt = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    FormBuilderValidators.match(emailRegex, errorText: txt.invalidEmail);
  };

  static final validatorVAT = (BuildContext context) {
    final RegExp vatRegex = RegExp(r'^[A-Z]{2}\d{10}|[A-Z]{2}[A-Z0-9]{10}$');
    final txt = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    FormBuilderValidators.match(vatRegex, errorText: txt.invalidVAT);
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
    final txt = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;

    final List<FormFieldValidator<String>> validatorsToCompose = [];

    var isCustomRangeValidator = customValidator is DateTimeRangeValidator;

    if (customValidator != null && isCustomRangeValidator) {
      validatorsToCompose.add(customValidator);
    }
    if (isRequired ?? false) {
      validatorsToCompose.add(FormBuilderValidators.required(errorText: txt.requiredField));
    }
    if (minIntValue != null) {
      validatorsToCompose.add(FormBuilderValidators.min(minIntValue, errorText: txt.minIntValue(minIntValue)));
    }
    if (maxIntValue != null) {
      validatorsToCompose.add(FormBuilderValidators.max(maxIntValue, errorText: txt.maxIntValue(maxIntValue)));
    }
    if (minLength != null) {
      validatorsToCompose.add(FormBuilderValidators.minLength(minLength, errorText: txt.minNChars(minLength)));
    }
    if (maxLength != null) {
      validatorsToCompose.add(FormBuilderValidators.maxLength(maxLength, errorText: txt.minNChars(maxLength)));
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
