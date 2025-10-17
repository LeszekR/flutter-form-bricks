import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../style/app_size.dart';
import '../../style/app_style.dart';
import '../form_manager/standalone_form_manager.dart';
import 'entity_form.dart';
import 'form_utils.dart';

abstract class SingleForm extends EntityForm {
  SingleForm({super.key}) : super(formManager: StandaloneFormManager());

  @override
  StandaloneFormState createState();
}

abstract class StandaloneFormState<T extends SingleForm> extends EntityFormState<T> {

  List<Widget> createBody();

  @override
  StandaloneFormManager get formManager => super.formManager as StandaloneFormManager;

  @override
  Widget build(final BuildContext context) {
    return FormUtils.defaultScaffold(
        label: provideLabel(),
        child: Column(children: [
          //
          _createFormBody(context),
          //
          AppSize.spacerBoxVerticalSmall,
          //
          createFormControlPanel(context)
        ]));
  }

  Widget _createFormBody(final BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Expanded(
      child: FormBuilder(
        autovalidateMode: AutovalidateMode.disabled,
        key: formKey,
        child: Container(
          decoration: BoxDecoration(border: Border(bottom: AppStyle.borderFieldSideEnabled)),
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
              child: SingleChildScrollView(controller: scrollController, child: Column(children: createBody())),
            ),
          ),
        ),
      ),
    );
  }
}
