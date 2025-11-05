import 'package:flutter_form_bricks/shelf.dart';

abstract class FormSchema {
  final String initialFocusKeyString;
  final List<FormFieldDescriptor> descriptors;

  FormSchema(this.initialFocusKeyString, this.descriptors)
      : assert(descriptors.map((d) => d.keyString).toSet().length == descriptors.length,
            'All keyStrings in descriptors list must be unique.'),
        assert(descriptors.any((d) => d.keyString == initialFocusKeyString),
            'The initialFocusKeyString must match one of the descriptors.');
}
//
// void init(FormData stateData) {
//   for (final keyString in _descriptorsMap.keys) {
//     stateData.fieldDataMap[keyString] = FormFieldData(_descriptorsMap[keyString]!.initialValue);
//   }
//   stateData.focusedKeyString = _initialFocusKeyString;
// }
//
// Map<String, FormFieldDescriptor> get descriptorsMap => _descriptorsMap;
