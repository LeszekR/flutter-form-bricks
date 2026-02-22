import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

abstract class FormSchema {
  final GlobalKey<FormStateBrick> formKey;
  final String initiallyFocusedKeyString;
  final List<FormFieldDescriptor> fieldDescriptors;

  FormSchema({
    required this.formKey,
    required this.initiallyFocusedKeyString,
    required this.fieldDescriptors,
  })  : assert(fieldDescriptors.map((d) => d.keyString).toSet().length == fieldDescriptors.length,
            'All keyStrings in field descriptors list must be unique.'),
        assert(fieldDescriptors.map((d) => d.keyString).toSet().contains(initiallyFocusedKeyString),
            'Initially focused keyString must be in field descriptors list: \'$initiallyFocusedKeyString\' is missing there.');
}
