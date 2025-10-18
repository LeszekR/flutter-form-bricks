import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../form_manager/form_manager.dart';
import '../form_manager/standalone_form_manager.dart';
import 'abstract_form.dart';

abstract class SingleForm extends AbstractForm {
  SingleForm({super.key}) : super(formManager: StandaloneFormManagerOLD());

  @override
  SingleFormState createState();
}

abstract class SingleFormState extends AbstractFormState<SingleForm> {
  List<Widget> createBody(BuildContext context);

  @override
  FormManagerOLD get formManager => super.formManager as StandaloneFormManagerOLD;

  @override
  Widget build(BuildContext context) {
    final appSize = UiParams.of(context).appSize;
    return FormUtils.defaultScaffold(
        context: context,
        label: provideLabel(),
        child: Column(children: [
          //
          _createFormBody(context),
          //
          appSize.spacerBoxVerticalSmall,
          //
          createFormControlPanel(context)
        ]));
  }

  Widget _createFormBody(BuildContext context) {
    final appStyle = UiParams.of(context).appStyle;
    final ScrollController scrollController = ScrollController();
    return Expanded(
      child: FormBuilder(
        autovalidateMode: AutovalidateMode.disabled,
        key: formKey,
        child: Container(
          decoration: BoxDecoration(border: Border(bottom: appStyle.borderFieldSide)),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.trackpad,
                // PointerDeviceKind.stylus,
                // PointerDeviceKind.unknown,
              },
            ),
            child: Scrollbar(
              controller: scrollController,
              child: SingleChildScrollView(controller: scrollController, child: Column(children: createBody(context))),
            ),
          ),
        ),
      ),
    );
  }
}
