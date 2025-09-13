import 'package:flutter_form_bricks/src/ui/inputs/state/brick_form_state_data.dart';

import '../../inputs/state/brick_field_state_data.dart';
import 'field_descriptor.dart';

abstract class FormSchema {
  final List<BrickFieldDescriptor> descriptors;

  const FormSchema(this.descriptors);

  void makeFieldStateList(BrickFormStateData stateData) {
    if (stateData.fieldStateDataMap.isNotEmpty) {
      return;
    }
    for (var descriptor in descriptors) {
      stateData.fieldStateDataMap[descriptor.keyString] = BrickFieldStateData(initialValue: descriptor.initialValue);
    }
  }
}
