// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_bricks/shelf.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
//
// class ExampleTabulatedForm extends TabulatedForm {
//   ExampleTabulatedForm({super.key});
//
//   @override
//   TabulatedFormState<ExampleTabulatedForm> createState() => _ExampleTabulatedFormState();
// }
//
// class _ExampleTabulatedFormState extends TabulatedFormState<ExampleTabulatedForm> {
//   var _dependentTextInputReadonly = true;
//   var _dependentTabReadonly = true;
//   final _lockingTabGlobalKey = GlobalKey<FormBuilderState>();
//
//   // @override
//   // Entity? getEntity() => null; //TODO implement
//   //
//   // @override
//   // EntityService<Entity> getService() => throw UnimplementedError();
//
//   @override
//   String provideLabel() => "Przykład Tabulated Form";
//
//   @override
//   void deleteEntity() => debugPrint("delete triggered.");
//
//   @override
//   void removeEntityFromState() {}
//
//   @override
//   void upsertEntityInState(Map<String, dynamic> responseBody) {}
//
//   @override
//   void submitData() {
//     final Map<String, dynamic> formData = formManager.collectInputData();
//     debugPrint("save triggered. Data: $formData");
//   }
//
//   @override
//   List<TabData> makeTabsData(BuildContext context) {
//     final uiParams = UiParams.of(context);
//     final appSize = uiParams.appSize;
//     final disabled = _createDisabledPart();
//     final text = _createTextPart(appSize);
//     final numbers = _createNumbersPart();
//     final choices = _createChoicesPart(appSize);
//     final forDisable = _createForDisablePart();
//     final dates = _createDatesPart(appSize);
//     return [disabled, text, numbers, choices, forDisable, dates];
//   }
//
//   TabData _createDisabledPart() {
//     const label = "Disabled jako pierwszy tab";
//     return TabData(
//         label: label,
//         globalKey: _lockingTabGlobalKey,
//         makeTabContent: () => _makeDisabled(_lockingTabGlobalKey, label),
//         initialStatus: TabStatus.tabOk);
//   }
//
//   Widget _makeDisabled(GlobalKey formKey, String label) {
//     return FormUtils.verticalFormGroup([
//       TextInputs.textSimple(
//         keyString: "diabledTabSimpleExample",
//         label: 'nieistotne',
//         labelPosition: LabelPosition.topLeft,
//         formManager: formManager,
//       ),
//     ], label: label);
//   }
//
//   TabData _createTextPart(AppSize appSize) {
//     final formKey = GlobalKey<FormBuilderState>();
//     const label = "Tekst";
//     return TabData(
//       label: label,
//       globalKey: formKey,
//       initialStatus: TabStatus.tabOk,
//       makeTabContent: () => _makeTexts(appSize, formKey, label),
//     );
//   }
//
//   Widget _makeTexts(AppSize appSize, GlobalKey formKey, String label) {
//     final leftColumn = Column(
//       children: [
//         BasicTextInput.label("Label - tylko odczyt", appSize.fontSize5),
//         appSize.spacerBoxVerticalMedium,
//         TextInputs.textSimple(
//           keyString: "regular text input",
//           label: 'Prosty text input',
//           labelPosition: LabelPosition.topLeft,
//           validator: ValidatorProvider.compose(isRequired: true),
//           formManager: formManager,
//         ),
//         appSize.spacerBoxHorizontalMedium,
//         TextInputs.textLowercase(
//           keyString: "lowercase text",
//           label: 'tylko low-case',
//           labelPosition: LabelPosition.topLeft,
//           formManager: formManager,
//         ),
//         appSize.spacerBoxVerticalSmall,
//         TextInputs.textSimple(
//             keyString: "withDefault",
//             label: 'input posiadający defaultową wartość (sprawdz reset)',
//             labelPosition: LabelPosition.topLeft,
//             formManager: formManager,
//             initialValue: "tadam"),
//         appSize.spacerBoxVerticalSmall,
//         TextInputs.textMultiline(
//             keyString: "bulkText",
//             label: 'Bulk Text',
//             labelPosition: LabelPosition.topLeft,
//             formManager: formManager,
//             inputWidth: appSize.textFieldWidth,
//             inputHeightMultiplier: 3)
//       ],
//     );
//     final rightColumn = Column(
//       children: [
//         TextInputs.textUppercase(
//           keyString: "uppercase text",
//           label: 'tylko upper-case',
//           labelPosition: LabelPosition.topLeft,
//           formManager: formManager,
//         ),
//         TextInputs.textFirstUppercaseThenLowercase(
//           keyString: "fisrtuppercase text",
//           label: 'pierwszy upper, potem lower',
//           labelPosition: LabelPosition.topLeft,
//           formManager: formManager,
//         ),
//         TextInputs.textVat(
//           keyString: "vat",
//           label: 'Text input z regexem VAT',
//           labelPosition: LabelPosition.topLeft,
//           formManager: formManager,
//         ),
//       ],
//     );
//
//     return FormUtils.horizontalFormGroup([leftColumn, appSize.spacerBoxHorizontalMedium, rightColumn],
//         label: label, alignment: Alignment.topLeft);
//   }
//
//   TabData _createNumbersPart() {
//     final formKey = GlobalKey<FormBuilderState>();
//     const label = "Liczby";
//     return TabData(
//       label: label,
//       globalKey: formKey,
//       initialStatus: TabStatus.tabOk,
//       makeTabContent: () => _makeNumbers(formKey, label),
//     );
//   }
//
//   Widget _makeNumbers(GlobalKey formKey, String label) {
//     return FormUtils.horizontalFormGroup([
//       NumberInputs.textInteger(
//         keyString: "int",
//         label: "Pole integer",
//         labelPosition: LabelPosition.topLeft,
//         formManager: formManager,
//       ),
//       NumberInputs.textDouble(
//         keyString: "double",
//         label: "Pole double z dwoma miejscami po przecinku",
//         labelPosition: LabelPosition.topLeft,
//         formManager: formManager,
//       ),
//     ], label: label);
//   }
//
//   TabData _createChoicesPart(AppSize appSize) {
//     final formKey = GlobalKey<FormBuilderState>();
//     const label = "Inputy wyborów";
//     return TabData(
//       label: label,
//       globalKey: formKey,
//       initialStatus: TabStatus.tabOk,
//       makeTabContent: () => _makeChoices(appSize, formKey, label),
//     );
//   }
//
//   Widget _makeChoices(AppSize appSize, GlobalKey formKey, String label) {
//     return FormUtils.verticalFormGroup(
//       [
//         ChoiceInputs.checkbox(
//             keyString: "text_freeze_checkbox",
//             label: "Checkbox blokujący pole",
//             labelLeftOfCheckbox: true,
//             valueControllingVar: _dependentTextInputReadonly,
//             onChanged: (val) => setState(() {
//                   print('before: $_dependentTextInputReadonly');
//                   _dependentTextInputReadonly = val ?? false;
//                   print('after: $_dependentTextInputReadonly');
//                 })),
//         appSize.spacerBoxVerticalSmall,
//         TextInputs.textSimple(
//           keyString: "fieldDenpendentOnCheckbox",
//           label: 'Text input zależny od checkbox',
//           labelPosition: LabelPosition.topLeft,
//           formManager: formManager,
//           readonly: _dependentTextInputReadonly,
//         ),
//         appSize.spacerBoxVerticalMedium,
//         ChoiceInputs.radio(
//           id: "radio_id",
//           groupLabel: "Radio buttons",
//           options: {"tab_radio_1": "Label 1", "tab_radio_2": "Label 2", "tab_radio_3": "Label 3"},
//           labelOnTheLeft: true,
//           validator: ValidatorProvider.compose(isRequired: true),
//           formManager: formManager,
//         ),
//         appSize.spacerBoxVerticalMedium,
//         ChoiceInputs.checkbox(
//             keyString: "tab_freeze_checkbox",
//             label: "Checkbox blokujący taba",
//             labelLeftOfCheckbox: false,
//             valueControllingVar: _dependentTabReadonly,
//             onChanged: (val) => setState(() => setTabActive(val))),
//       ],
//       label: label,
//     );
//   }
//
//   void setTabActive(bool? isTabEnabled) {
//     formManager.setDisabled(_lockingTabGlobalKey, isTabEnabled ?? false);
//     _dependentTabReadonly = isTabEnabled ?? false;
//   }
//
//   TabData _createForDisablePart() {
//     final formKey = GlobalKey<FormBuilderState>();
//     var label = "Do oblokowania w sekcji z wyborem";
//     return TabData(
//       label: label,
//       globalKey: _lockingTabGlobalKey,
//       initialStatus: TabStatus.tabOk,
//       makeTabContent: () => _makeForDisable(formKey, label),
//     );
//   }
//
//   Widget _makeForDisable(GlobalKey formKey, String label) {
//     return FormUtils.horizontalFormGroup([
//       TextInputs.textSimple(
//         keyString: "dependentTab",
//         label: 'Text input zależny od poprzedniego taba',
//         labelPosition: LabelPosition.topLeft,
//         validator: ValidatorProvider.compose(isRequired: true),
//         formManager: formManager,
//       ),
//     ], label: label);
//   }
//
//   TabData _createDatesPart(AppSize appSize) {
//     const label = "Daty";
//     return TabData(
//       label: label,
//       globalKey: formKey,
//       initialStatus: TabStatus.tabOk,
//       makeTabContent: () => _makeDates(appSize, label),
//     );
//   }
//
//   Widget _makeDates(AppSize appSize,String label) {
//     return FormUtils.verticalFormGroup([
//       DateTimeInputs.date(
//         keyString: "dateonly",
//         label: "Sama Data",
//         labelPosition: LabelPosition.topLeft,
//         formManager: formManager,
//         context,
//       ),
//       appSize.spacerBoxVerticalSmall,
//       DateTimeInputs.time(
//         keyString: "timeonly",
//         label: "Sam Czas",
//         labelPosition: LabelPosition.topLeft,
//         formManager: formManager,
//         context,
//       ),
//       appSize.spacerBoxVerticalSmall,
//       DateTimeInputs.dateTimeSeparateFields(
//         keyString: "date_time_1",
//         label: "Data i Czas",
//         labelPosition: LabelPosition.topLeft,
//         formManager: formManager,
//         context,
//       ),
//       appSize.spacerBoxVerticalSmall,
//       DateTimeInputs.dateTimeRange(
//         rangeId: "date_time_range_1",
//         label: "Zakres datogodzin",
//         labelPosition: LabelPosition.topLeft,
//         formManager: formManager,
//         context,
//       )
//     ], label: label);
//   }
// }
