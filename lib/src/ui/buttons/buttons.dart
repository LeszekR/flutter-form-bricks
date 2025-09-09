import 'package:flutter/material.dart';
import 'package:shipping_ui/config/string_assets/translation.dart';
import '../../features/security/service/security_service.dart';
import 'package:shipping_ui/ui/style/app_style.dart';
import 'package:shipping_ui/ui/style/app_color.dart';
import 'package:shipping_ui/ui/style/app_size.dart';

import '../dialogs/dialogs.dart';
import '../inputs/base/double_widget_states_controller.dart';
import '../inputs/states_controller/double_widget_states_controller.dart';
import '../visual_params/app_color.dart';
import '../visual_params/app_size.dart';
import '../visual_params/app_style.dart';
import 'elevated_button_with_disabling.dart';
import '../inputs/text/text_inputs_base/icon_button_state_aware.dart';

class Buttons {
  Buttons._();

  static WidgetStateProperty<OutlinedBorder> makeShape(bool hasBorder) {
    return WidgetStateProperty.all(hasBorder
        ? AppStyle.beveledRectangleBorderHardCorners
        : const BeveledRectangleBorder(side: BorderSide(width: 0, style: BorderStyle.none)));
  }

  static ElevatedButtonWithDisabling elevatedButton({
    final BuildContext? context,
    required final String text,
    required final VoidCallback onPressed,
    final List<String>? requiredRoles,
    final double? width,
    final double? height,
    final double? marginLeft,
    final double? marginRight,
    final bool isEnabled = true,
    final bool hasBorder = true,
  }) {
    assert((requiredRoles != null) == (context != null),
    'If required roles are provided then BuildContext must be provided too');

    final isAllowed = requiredRoles?.contains(SecurityService().getRole()) ?? true;

    final chosenAction = isAllowed
        ? onPressed
        : () => Dialogs.informationDialog(
            context!, Tr.get.dialogsWarning, Tr.get.pagesResetPasswordDialogsNotPermitted(requiredRoles));

    final style = ButtonStyle(
      shape: WidgetStateProperty.all(AppStyle.beveledRectangleBorderHardCorners),
      padding: WidgetStateProperty.all(EdgeInsets.all(AppSize.paddingButton)),
      minimumSize: WidgetStateProperty.all(Size(width ?? AppSize.buttonWidth, height ?? AppSize.buttonHeight)),
      backgroundColor: WidgetStateProperty.all(AppColor.formButtonBackground),
      foregroundColor: WidgetStateProperty.all(isAllowed ? AppColor.buttonFontEnabled : AppColor.buttonFontDisabled),
      textStyle: WidgetStateProperty.all(
        TextStyle(
          fontStyle: isAllowed ? FontStyle.normal : FontStyle.italic,
        ),
      ),
    );

    return ElevatedButtonWithDisabling(
        key: Key(text),
        onPressed: chosenAction,
        style: style,
        isActive: isAllowed,
        child: Text(text));
  }

  /// STATE AWARE - color depends on state
  static ValueListenableBuilder iconButtonStateAware({
    required final IconData iconData,
    required final String tooltip,
    required final VoidCallback? onPressed,
    required final DoubleWidgetStatesController statesController,
  }) {

    return ValueListenableBuilder(
        valueListenable: statesController,
        builder: (context, states, _) {
          return Container(
            width: AppSize.inputTextHeight,
            height: AppSize.inputTextHeight,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            color: AppColor.makeColor(states).withOpacity(1),
            child: IconButtonStateAware(
              iconData,
              onPressed,
              autofocus: true,
              tooltip: tooltip,
              statesObserver: statesController.lateWidgetStatesController,
            ),
          );
        });
  }

  /// STATE IRRELEVANT - color is const from AppStyle.theme
  static Widget iconButtonStateless({
    required final IconData iconData,
    required final String tooltip,
    required final VoidCallback? onPressed,
  }) {
    double iconSize = AppSize.iconSize;
    Alignment alignment = Alignment.center;
    EdgeInsets padding = EdgeInsets.zero;
    bool autofocus = true;
    Color color = AppColor.iconColor;

    return IconButton(
      icon: Icon(iconData),
      iconSize: iconSize,
      alignment: alignment,
      padding: padding,
      autofocus: autofocus,
      color: color,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
