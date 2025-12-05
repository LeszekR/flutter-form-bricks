import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/forms/base/form_brick.dart';

import '../test_implementations/test_form_manager.dart';


class TestSingleForm extends FormBrick {
  final Widget Function(BuildContext context, FormManager formManager) widgetBuilder;

  TestSingleForm({super.key, required this.widgetBuilder}) : super(formManager: TestFormManager.testDefault());

  @override
  TestSingleFormState createState() => TestSingleFormState();
}

class TestSingleFormState extends FormStateBrick<TestSingleForm> {
  @override
  Widget buildBody(BuildContext context) {
    return widget.widgetBuilder(context, formManager);
  }

  @override
  void submitData() {}
}
