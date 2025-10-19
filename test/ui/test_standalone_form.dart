// import 'package:flutter/material.dart';
// import 'package:shipping_ui/config/http/http_service.dart';
// import 'package:shipping_ui/config/objects/abstracts/entity.dart';
// import 'package:shipping_ui/ui/forms/base/form_utils.dart';
// import 'package:shipping_ui/ui/forms/base/single_form.dart';
// import 'package:shipping_ui/ui/forms/form_manager/form_manager.dart';
//
// class TestStandaloneForm extends SingleForm {
//   final Widget Function(FormManager formManager) widgetMaker;
//
//   TestStandaloneForm({super.key, required this.widgetMaker});
//
//   @override
//   StandaloneFormState<SingleForm> createState() => _TestStandaloneFormState();
// }
//
// class _TestStandaloneFormState extends StandaloneFormState<TestStandaloneForm> {
//
//   /// Do NOT override this method in PROD! This is ONLY FOR UI TESTS!
//   /// Flutter builds UI differently in prod and test. Due to that TestStandaloneForm crashes on control panel vertical
//   /// overflow without this correction, This param introduces correction of control panel height
//   @override
//   int testControlsHeightCorrection()  => 13;
//
//   @override
//   List<Widget> createBody() {
//     return [
//       FormUtils.horizontalFormGroup(
//         height: 300,
//         [widget.widgetMaker(formManager)],
//       )
//     ];
//   }
//
//   @override
//   String provideLabel() => "Test Standalone Form";
//
//   @override
//   Entity? getEntity() => null;
//
//   @override
//   EntityService<Entity> getService() => throw UnimplementedError();
//
//   @override
//   void removeEntityFromState() {}
//
//   @override
//   void upsertEntityInState(Map<String, dynamic> responseBody) {}
// }
