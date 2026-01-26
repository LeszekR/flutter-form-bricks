import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

abstract class FormSchema {
  final GlobalKey<FormStateBrick> formKey;
  final String initiallyFocusedKeyString;
  final List<FormFieldDescriptor> descriptors;

  FormSchema({required this.formKey, required this.initiallyFocusedKeyString, required this.descriptors})
      : assert(descriptors.map((d) => d.keyString).toSet().length == descriptors.length,
            'All keyStrings in descriptors list must be unique.'),
        assert(descriptors.map((d) => d.keyString).toSet().contains(initiallyFocusedKeyString),
            'Initially focused keyString must be in descriptors list: \'$initiallyFocusedKeyString\' is missing there.');
}
