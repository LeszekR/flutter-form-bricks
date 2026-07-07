import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

abstract class FormSchema {
  final GlobalKey<FormStateBrick> formKey;
  final String initiallyFocusedKeyString;
  final List<FormFieldDescriptor> fieldDescriptors = [];

  List<FormFieldDescriptor> get fieldDescriptorsList;

  FormSchema({
    required this.formKey,
    required this.initiallyFocusedKeyString,
    // required this.fieldDescriptors,
  })
/*      : assert(fieldDescriptors.map((d) => d.keyString).toSet().length == fieldDescriptors.length,
          'All keyStrings in field descriptors list must be unique.'),
        assert(fieldDescriptors.map((d) => d.keyString).toSet().contains(initiallyFocusedKeyString),
          'Initially focused keyString must be in field descriptors list: \'$initiallyFocusedKeyString\' is missing there.')*/
  {
    final Set<String> allKeyStrings = <String>{};
    bool hasInitiallyFocusedKeyString = false;

    for (FormFieldDescriptor d in fieldDescriptorsList) {
      assert(!allKeyStrings.contains(d.keyString),
          'All keyStrings in field descriptors list must be unique - ' '"${d.keyString}" is duplicated.');

      allKeyStrings.add(d.keyString);
      fieldDescriptors.add(d);

      hasInitiallyFocusedKeyString |= d.keyString == initiallyFocusedKeyString;
    }

    assert(hasInitiallyFocusedKeyString,
        'Initially focused keyString must be in field descriptors list: \'$initiallyFocusedKeyString\' is missing there.');
  }
}
