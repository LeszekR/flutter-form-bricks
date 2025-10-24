import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/base/form_utils.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';

class TestSingleForm extends SingleForm {
  final Widget Function(BuildContext context, FormManager formManager) widgetMaker;

  TestSingleForm({super.key, required this.widgetMaker});

  @override
  TestSingleFormState createState() => TestSingleFormState();
}

class TestSingleFormState extends SingleFormState<TestSingleForm> {
  /// Do NOT override this method in PROD! This is ONLY FOR UI TESTS!
  /// Flutter builds UI differently in prod and test. Due to that TestSingleForm crashes on control panel vertical
  /// overflow without this correction, This param introduces correction of control panel height
  @override
  int testControlsHeightCorrection() => 13;

  @override
  List<Widget> createBody(BuildContext context) {
    return [
      FormUtils.horizontalFormGroup(
        context: context,
        height: 300,
        children: [widget.widgetMaker(context, formManager)],
      )
    ];
  }

  @override
  String provideLabel() => "Test Single Form";

  @override
  void deleteEntity() {
    // TODO: remove from abstract
  }

  @override
  void submitData() {
    // TODO: remove from abstract
  }
}
