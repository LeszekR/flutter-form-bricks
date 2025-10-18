import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/inputs/states_controller/double_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

import '../../../ui_helpers/ui_helpers.dart';
import 'elevated_button_with_disabling.dart';
import 'icon_button_state_aware.dart';

class Buttons {
  Buttons._();

  static WidgetStateProperty<OutlinedBorder> makeShape(BuildContext context, bool hasBorder) {
    return WidgetStateProperty.all(hasBorder
        ? getAppStyle(context).beveledRectangleBorderHardCorners
        : const BeveledRectangleBorder(side: BorderSide(width: 0, style: BorderStyle.none)));
  }

  static ElevatedButtonWithDisabling elevatedButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    final List<String>? requiredRoles,
    final double? width,
    final double? height,
    final double? marginLeft,
    final double? marginRight,
    final bool isEnabled = true,
    final bool hasBorder = true,
  }) {
    final txt = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    final appSize = getAppSize(context);
    final appStyle = getAppStyle(context);
    final appColor = getAppColor(context);

    final isAllowed = true; // replace with permissions check
    // final isAllowed = requiredRoles?.contains(SecurityService().getRole()) ?? true;

    // TODO refactor - set not-allowed-action as onPressed after prior permitions check
    // final chosenAction = isAllowed
    //     ? onPressed
    //     : () => Dialogs.informationDialog(
    //         context, txt.dialogsWarning, txt.pagesResetPasswordDialogsNotPermitted(requiredRoles));

    final style = ButtonStyle(
      shape: WidgetStateProperty.all(appStyle.beveledRectangleBorderHardCorners),
      padding: WidgetStateProperty.all(EdgeInsets.all(appSize.paddingButton)),
      minimumSize: WidgetStateProperty.all(Size(width ?? appSize.buttonWidth, height ?? appSize.buttonHeight)),
      backgroundColor: WidgetStateProperty.all(appColor.formButtonBackground),
      foregroundColor: WidgetStateProperty.all(isAllowed ? appColor.buttonFontEnabled : appColor.buttonFontDisabled),
      textStyle: WidgetStateProperty.all(TextStyle(fontStyle: isAllowed ? FontStyle.normal : FontStyle.italic)),
    );

    return ElevatedButtonWithDisabling(
      key: Key(text),
      onPressed: onPressed,
      style: style,
      isActive: isAllowed,
      child: Text(text),
    );
  }

  /// STATE AWARE - color depends on state
  static ValueListenableBuilder iconButtonStateAware({
    required BuildContext context,
    required IconData iconData,
    required String tooltip,
    required VoidCallback? onPressed,
    required DoubleWidgetStatesController statesController,
  }) {
    final txt = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
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
    required BuildContext context,
    required IconData iconData,
    required String tooltip,
    required VoidCallback? onPressed,
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
