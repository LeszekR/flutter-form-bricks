import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';

class NumberValidators {
  NumberValidators._();

  static FormFieldValidator<String> integerValidator(BricksLocalizations localizations) {
    return (input) {
      if (input == null || input.isEmpty) return null;

      final regExp = RegExp(r'^\d[\d\s]*$');

      if (!regExp.hasMatch(input)) {
        return localizations.validationInteger;
      }

      return null;
    };
  }

  static FormFieldValidator<String> decimalValidator(BricksLocalizations localizations,int decimalPoints) {
    return (input) {
      if (input == null || input.isEmpty) return null;

      final regExp = RegExp(r'^\d{1,3}(\s\d{3})*(,\d{0,' + decimalPoints.toString() + r'})?$');

      if (!regExp.hasMatch(input)) {
        return localizations.validationDecimal(decimalPoints);
      }

      return null;
    };
  }
}
