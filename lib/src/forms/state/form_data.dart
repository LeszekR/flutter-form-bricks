import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

abstract class FormData {
  final Map<String, FormFieldData> fieldDataMap = {};
  String initiallyFocusedKeyString = '';
}
