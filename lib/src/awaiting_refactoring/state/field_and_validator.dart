import 'package:flutter/cupertino.dart';

class FieldAndValidator<T> {
  final String fieldKeyString;
  T? value;
  final FormFieldValidator<T>? validator;
  String? errorMessage;

  FieldAndValidator({required this.fieldKeyString, required this.value, this.validator, this.errorMessage});
}
