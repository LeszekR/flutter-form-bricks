// import 'package:flutter/material.dart';
// import 'package:flutter_form_bricks/shelf.dart';
//
// import '../test_implementations/test_form_manager.dart';
// import '../test_implementations/test_form_schema.dart';
// import '../test_implementations/test_form_state_data.dart';
//
// class TestSingleForm extends FormBrick {
//   final Widget Function(BuildContext context, FormManager formManager) widgetMaker;
//
//   TestSingleForm({super.key, required this.widgetMaker})
//       : super(formManager: TestFormManager(schema: TestFormSchema()));
//
//   @override
//   TestSingleFormState createState() => TestSingleFormState();
// }
//
// class TestSingleFormState extends FormStateBrick<TestSingleForm> {
//   /// Do NOT override this method in PROD! This is ONLY FOR UI TESTS!
//   /// Flutter builds UI differently in prod and test. Due to that TestSingleForm crashes on control panel vertical
//   /// overflow without this correction, This param introduces correction of control panel height
//   @override
//   int testControlsHeightCorrection() => 13;
//
//   @override
//   Widget buildBody(BuildContext context) {
//     return FormUtils.horizontalFormGroup(
//       context: context,
//       height: 300,
//       children: [widget.widgetMaker(context, formManager)],
//     );
//   }
//
//   @override
//   void submitData() {}
// }
