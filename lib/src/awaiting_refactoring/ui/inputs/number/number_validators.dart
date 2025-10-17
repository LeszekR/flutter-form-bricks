import 'package:flutter/cupertino.dart';

class NumberValidators {
  NumberValidators._();

  static FormFieldValidator<String> integerValidator() {
    return (input) {
      if (input == null || input.isEmpty) return null;

      final regExp = RegExp(r'^\d[\d\s]*$');

      if (!regExp.hasMatch(input)) {
        return Tr.get.validationInteger;
      }

      return null;
    };
  }

  static FormFieldValidator<String> decimalValidator(final int decimalPoints) {
    return (input) {
      if (input == null || input.isEmpty) return null;

      final regExp = RegExp(r'^\d{1,3}(\s\d{3})*(,\d{0,' + decimalPoints.toString() + r'})?$');

      if (!regExp.hasMatch(input)) {
        return Tr.get.validationDecimal(decimalPoints);
      }

      return null;
    };
  }
}
