import 'package:flutter_form_bricks/shelf.dart';

abstract class FormSchema {
  final List<FieldDescriptor> descriptors;

  FormSchema(this.descriptors)
      : assert(descriptors.map((d) => d.keyString).toSet().length == descriptors.length,
            'All keyStrings in descriptors list must be unique.');
}
