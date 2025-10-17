import 'package:flutter/material.dart';

import '../../../ui_helpers/ui_helpers.dart';
import '../../../ui_params/ui_params.dart';
import '../dialogs/dialogs.dart';
import '../inputs/base/double_widget_states_controller.dart';
import 'elevated_button_with_disabling.dart';
import 'icon_button_state_aware.dart';
import 'package:flutter_form_bricks/src/ui_params/app_style/app_style.dart';

class Buttons {
  Buttons._();

  static WidgetStateProperty<OutlinedBorder> makeShape(BuildContext context, bool hasBorder) {
    return WidgetStateProperty.all(hasBorder
        ? getAppStyle(context).beveledRectangleBorderHardCorners
        : const BeveledRectangleBorder(side: BorderSide(width: 0, style: BorderStyle.none)));
  }

  static ElevatedButtonWithDisabling elevatedButton({
    required final BuildContext context,
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
    final appSize = getAppSize(context);
    final appStyle = getAppStyle(context);
    final appColor = getAppColor(context);

    final isAllowed = true; // replace with permissions check
    // final isAllowed = requiredRoles?.contains(SecurityService().getRole()) ?? true;

    final chosenAction = isAllowed
        ? onPressed
        : () => Dialogs.informationDialog(
            context!, Tr.get.dialogsWarning, Tr.get.pagesResetPasswordDialogsNotPermitted(requiredRoles));

    final style = ButtonStyle(
      shape: WidgetStateProperty.all(appStyle.beveledRectangleBorderHardCorners),
      padding: WidgetStateProperty.all(EdgeInsets.all(appSize.paddingButton)),
      minimumSize: WidgetStateProperty.all(Size(width ?? appSize.buttonWidth, height ?? appSize.buttonHeight)),
      backgroundColor: WidgetStateProperty.all(appColor.formButtonBackground),
      foregroundColor: WidgetStateProperty.all(isAllowed ? appColor.buttonFontEnabled : appColor.buttonFontDisabled),
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
    required final BuildContext context,
    required final IconData iconData,
    required final String tooltip,
    required final VoidCallback? onPressed,
    required final DoubleWidgetStatesController statesController,
  }) {
    final appSize = getAppSize(context);
    final appColor = getAppColor(context);

    return ValueListenableBuilder(
        valueListenable: statesController,
        builder: (context, states, _) {
          return Container(
            width: appSize.inputTextLineHeight,
            height: appSize.inputTextLineHeight,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            color: appColor.makeColor(states).withOpacity(1),
            child: IconButtonStateAware(
              iconData,
              onPressed,
              autofocus: true,
              tooltip: tooltip,
              receiverColorController: statesController.lateWidgetStatesController,
            ),
          );
        });
  }

  /// STATE IRRELEVANT - color is const from appStyle.theme
  static Widget iconButtonStateless({
    required final BuildContext context,
    required final IconData iconData,
    required final String tooltip,
    required final VoidCallback? onPressed,
  }) {
    final appSize = getAppSize(context);
    final appColor = getAppColor(context);

    double iconSize = appSize.iconSize;
    Alignment alignment = Alignment.center;
    EdgeInsets padding = EdgeInsets.zero;
    bool autofocus = true;
    Color color = appColor.iconColor;

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
