import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/forms/base/form_brick.dart';

import '../../inputs/state/form_field_data.dart';

abstract class FormData {
  final GlobalKey<FormStateBrick> formKey;
  final Map<String, FormFieldData> fieldDataMap = {};
  String? focusedKeyString;

  FormData({required this.formKey, required this.focusedKeyString});
}
