import 'package:flutter_form_bricks/src/forms/base/form_schema.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';

import '../ui/test_constants.dart';
import 'dummy_form_schema.dart';
import 'dummy_form_state_data.dart';

class DummyFormManager extends FormManager {
  DummyFormManager({required FormSchema schema})
      : super(
          stateData: DummyFormStateData(),
          schema: schema
        );

  @override
  FormStatus checkStatus() {
    // TODO: implement checkStatus
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> collectInputs() {
    // TODO: implement collectInputs
    throw UnimplementedError();
  }
}
