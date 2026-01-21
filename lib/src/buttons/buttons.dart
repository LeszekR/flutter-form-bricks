// TODO uncomment and refactor
// import 'package:flutter/material.dart';
// import 'package:shipping_ui/config/string_assets/translation.dart';
// import '../../features/security/service/security_service.dart';
// import 'package:shipping_ui/ui/style/app_style.dart';
// import 'package:shipping_ui/ui/style/app_color.dart';
// import 'package:shipping_ui/ui/style/app_size.dart';
//
// import '../dialogs/dialogs.dart';
// import '../form_fields/base/double_widget_states_controller.dart';
// import '../form_fields/states_controller/double_widget_states_controller.dart';
// import '../ui_params/app_color.dart';
// import '../ui_params/app_size.dart';
// import '../ui_params/app_style.dart';
// import 'elevated_button_with_disabling.dart';
// import '../form_fields/text/text_field_base/state_colored_icon_button.dart';
//
// class Buttons {
//   Buttons._();
//
//   static WidgetStateProperty<OutlinedBorder> makeShape(bool hasBorder) {
//     return WidgetStateProperty.all(hasBorder
//         ? AppStyle.beveledRectangleBorderHardCorners
//         : const BeveledRectangleBorder(side: BorderSide(width: 0, style: BorderStyle.none)));
//   }
//
//   static ElevatedButtonWithDisabling elevatedButton({
//     final BuildContext? context,
//     required String text,
//     required VoidCallback onPressed,
//     final List<String>? requiredRoles,
//     final double? width,
//     final double? height,
//     final double? marginLeft,
//     final double? marginRight,
//     final bool isEnabled = true,
//     final bool hasBorder = true,
//   }) {
//     assert((requiredRoles != null) == (context != null),
//     'If required roles are provided then BuildContext must be provided too');
//
//     final isAllowed = requiredRoles?.contains(SecurityService().getRole()) ?? true;
//
//     final chosenAction = isAllowed
//         ? onPressed
//         : () => Dialogs.informationDialog(
//             context!, localizations.dialogsWarning, localizations.pagesResetPasswordDialogsNotPermitted(requiredRoles));
//
//     final style = ButtonStyle(
//       shape: WidgetStateProperty.all(AppStyle.beveledRectangleBorderHardCorners),
//       padding: WidgetStateProperty.all(EdgeInsets.all(AppSize.paddingButton)),
//       minimumSize: WidgetStateProperty.all(Size(width ?? AppSize.buttonWidth, height ?? AppSize.buttonHeight)),
//       backgroundColor: WidgetStateProperty.all(AppColor.formButtonBackground),
//       foregroundColor: WidgetStateProperty.all(isAllowed ? AppColor.buttonFontEnabled : AppColor.buttonFontDisabled),
//       textStyle: WidgetStateProperty.all(
//         TextStyle(
//           fontStyle: isAllowed ? FontStyle.normal : FontStyle.italic,
//         ),
//       ),
//     );
//
//     return ElevatedButtonWithDisabling(
//         key: Key(text),
//         onPressed: chosenAction,
//         style: style,
//         isActive: isAllowed,
//         child: Text(text));
//   }
//
//   /// STATE AWARE - color depends on state
//   static ValueListenableBuilder iconButtonStateAware({
//     required IconData iconData,
//     required String tooltip,
//     required VoidCallback? onPressed,
//     required DoubleWidgetStatesController statesController,
//   }) {
//
//     return ValueListenableBuilder(
//         valueListenable: statesController,
//         builder: (context, states, _) {
//           return Container(
//             width: AppSize.inputTextLineHeight,
//             height: AppSize.inputTextLineHeight,
//             padding: EdgeInsets.zero,
//             alignment: Alignment.center,
//             color: AppColor.makeColor(states).withOpacity(1),
//             child: StateAwareIconButton(
//               iconData,
//               onPressed,
//               autofocus: true,
//               tooltip: tooltip,
//               statesObserver: statesController.lateWidgetStatesController,
//             ),
//           );
//         });
//   }
//
//   /// STATE IRRELEVANT - color is const from AppStyle.theme
//   static Widget iconButtonStateless({
//     required IconData iconData,
//     required String tooltip,
//     required VoidCallback? onPressed,
//   }) {
//     double iconSize = AppSize.iconSize;
//     Alignment alignment = Alignment.center;
//     EdgeInsets padding = EdgeInsets.zero;
//     bool autofocus = true;
//     Color color = AppColor.iconColor;
//
//     return IconButton(
//       icon: Icon(iconData),
//       iconSize: iconSize,
//       alignment: alignment,
//       padding: padding,
//       autofocus: autofocus,
//       color: color,
//       tooltip: tooltip,
//       onPressed: onPressed,
//     );
//   }
// }
