import '../../../../shelf.dart';
import 'form_field_descriptor.dart';

abstract class FormSchema {
  final List<FormFieldDescriptor> descriptors;

  const FormSchema(this.descriptors);

  void makeFieldStateList(FormStateData stateData) {
    if (stateData.fieldStateDataMap.isNotEmpty) {
      return;
    }
    for (var descriptor in descriptors) {
      stateData.fieldStateDataMap[descriptor.keyString] = FormFieldStateData(initialValue: descriptor.initialValue);
    }
  }
}
