import 'package:flutter_form_bricks/shelf.dart';

import '../src/tools/test_constants.dart';

class TestFormData extends FormData {
  TestFormData() : super(formKey: testFormGlobalKey, initiallyFocusedKeyString: fieldKeyString1);
}
