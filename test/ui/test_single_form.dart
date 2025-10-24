import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form.dart';
import 'package:flutter_form_bricks/src/forms/base/form_schema.dart';
import 'package:flutter_form_bricks/src/forms/state/single_form_state_data.dart';

class TestSingleForm extends SingleForm {
  TestSingleForm() : super(TestSingleFormStateData(), FormSchema());

  @override
  SingleFormState<SingleForm> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}

class TestSingleFormStateData extends SingleFormStateData {
  TestSingleFormStateData(super.formKeyString, super.fieldList);
}

class TestSingleFormSchema extends FormSchema {
  TestSingleFormSchema(super.descriptors);
}