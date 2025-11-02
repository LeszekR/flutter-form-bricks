import 'package:flutter/material.dart';

import '../ui/test_constants.dart';
import 'dummy_form_schema.dart';

DummyFormSchema makeDummyFormSchemaForText(TextEditingValue? initialValue) {
  final schema = DummyFormSchema.forText(
    keyString: keyString1,
    initialValue: initialValue,
  );
  return schema;
}
