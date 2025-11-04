import 'package:flutter_form_bricks/src/forms/base/form_schema.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';

import '../ui/test_constants.dart';
import 'test_form_schema.dart';
import 'test_form_state_data.dart';

class TestFormManager extends FormManager {
  TestFormManager({required FormSchema schema})
      : super(
          stateData: TestFormStateData(),
          schema: schema
        );

  @override
  FormStatus checkStatus() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> collectInputs() {
    throw UnimplementedError();
  }
}
