import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

abstract class FormData {
  final GlobalKey<FormStateBrick> formKey;
  final Map<String, FormFieldData> fieldDataMap = {};
  String focusedKeyString;

  FormData({required this.formKey, required this.focusedKeyString});
}

class SingleFormData extends FormData {
  SingleFormData({required super.formKey, required super.focusedKeyString});
}
