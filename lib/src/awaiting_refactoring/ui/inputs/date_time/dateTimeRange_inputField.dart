// import 'package:flutter/cupertino.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:shipping_ui/ui/inputs/date_time/date_time_inputs.dart';
//
// import '../../../../config/objects/model/time_stamp.dart';
// import '../../../../config/string_assets/translation.dart';
// import '../../forms/form_manager/form_manager.dart';
// import '../../style/app_size.dart';
// import '../base/e_input_name_position.dart';
// import 'dateTimeRange_validator.dart';
//
// class DateTimeRangeInputField extends StatefulWidget {
//   final String label;
//   final LabelPosition labelPosition;
//   final FormManagerOLD formManager;
//   final DateTimeRangeValidator validator;
//   final bool readonly;
//   final BuildContext? context;
//
//   const DateTimeRangeInputField({
//     super.key,
//     required this.formKey,
//     required this.label,
//     required this.labelPosition,
//     required this.formManager,
//     required this.validator,
//     this.readonly = false,
//     this.context,
//   });
//
//   final static keyStringDateStart = "keyStringDateStart";
//   String get keyStringDateStart => "${formKey}${keyStringDateStart}";
//
//   String get keyStringTimeStart => "${formKey}_keyStringTimeStart";
//
//   String get keyStringDateEnd => "${formKey}_keyStringDateEnd";
//
//   String get keyStringTimeEnd => "${formKey}_keyStringTimeEnd";
//
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
// }
//
// class _DateTimeRangeInputFieldState extends State<StatefulWidget> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     final linkedStartDate = [keyStringDateStart];
//
//     // TODO attach
//     final rangeStart = DateTimeInputs.dateTimeSeparateFields(
//         formKey: formKey,
//         keyStringDate: keyStringDateStart,
//         keyStringTime: keyStringTimeStart,
//         labelPosition: labelPosition,
//         label: "$label ${Tr.get.start}",
//         formManager: formManager,
//         timeLinkedFields: linkedStartDate,
//         context,
//         dateRequired: true);
//     final rangeEnd = DateTimeInputs.dateTimeSeparateFields(
//         formKey: formKey,
//         keyStringDate: keyStringDateEnd,
//         keyStringTime: keyStringTimeEnd,
//         label: "$label ${Tr.get.end}",
//         labelPosition: labelPosition,
//         formManager: formManager,
//         dateLinkedFields: linkedStartDate,
//         timeLinkedFields: linkedStartDate,
//         context);
//     return Row(children: [rangeStart, AppSize.spacerBoxHorizontalMedium, rangeEnd]);
//   }
//
// }
