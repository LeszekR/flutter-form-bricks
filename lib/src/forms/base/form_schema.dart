import 'package:flutter_form_bricks/shelf.dart';

abstract class FormSchema {
  final Map<String, FormFieldDescriptor> _descriptorsMap;
  final String _initialFocusKeyString;

  FormSchema(List<FormFieldDescriptor> descriptors, this._initialFocusKeyString)
      : _descriptorsMap = {
          for (final d in descriptors) d.keyString: d,
        } {
    assert(_descriptorsMap.containsKey(_initialFocusKeyString),
        'keyString of the field that is to be focused on the form start must exist in the descriptors list.');
  }

  void init(FormStateData stateData) {
    for (final keyString in _descriptorsMap.keys) {
      stateData.fieldStateDataMap[keyString] = FormFieldStateData(_descriptorsMap[keyString]!.initialValue);
    }
    stateData.focusedKeyString = _initialFocusKeyString;
  }

  Map<String, FormFieldDescriptor> get descriptorsMap => _descriptorsMap;
}
