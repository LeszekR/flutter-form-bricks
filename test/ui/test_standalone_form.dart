import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_manager.dart';

class TestStandaloneForm extends StandaloneForm {
  final Widget Function(BuildContext context, FormManagerOLD formManager) widgetMaker;

  TestStandaloneForm({super.key, required this.widgetMaker});

  @override
  TestStandaloneFormState createState() => TestStandaloneFormState();
}

class TestStandaloneFormState extends StandaloneFormState<TestStandaloneForm> {
  /// Do NOT override this method in PROD! This is ONLY FOR UI TESTS!
  /// Flutter builds UI differently in prod and test. Due to that TestStandaloneForm crashes on control panel vertical
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
  String provideLabel() => "Test Standalone Form";

  @override
  void deleteEntity() {
    // TODO: remove from abstract
  }

  @override
  void submitData() {
    // TODO: remove from abstract
  }
}
