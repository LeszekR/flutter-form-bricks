import 'package:flutter_form_bricks/shelf.dart';

abstract class FormSchema {
  // final String focusedKeyString;
  final List<FormFieldDescriptor> descriptors;

  FormSchema(this.descriptors)
  // FormSchema(this.focusedKeyString, this.descriptors)
      : assert(descriptors.map((d) => d.keyString).toSet().length == descriptors.length,
            'All keyStrings in descriptors list must be unique.');
        // assert(descriptors.any((d) => d.keyString == focusedKeyString),
        //     'The initialFocusKeyString must match one of the descriptors.');
}
