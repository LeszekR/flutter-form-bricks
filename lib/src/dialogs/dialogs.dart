import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

import '../awaiting_refactoring/ui/buttons/buttons.dart';
import '../awaiting_refactoring/ui/shortcuts/keyboard_shortcuts.dart';
import '../ui_params/ui_params_data.dart';

class Dialogs {
  Dialogs._();

  static Future<void> informationDialog(
    BuildContext context,
    final String title,
    final String content,
  ) async {
    final localizations = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    await _messageDialog(context, content, localizations.buttonOk, title: title);
  }

  static Future<bool> decisionDialogYesNo(
    BuildContext context,
    final String? title,
    final String content, {
    final VoidCallback? action,
    final Duration? closeDuration,
  }) async {
    final localizations = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    return await _messageDialog(
      context,
      content,
      localizations.buttonYes,
      buttonNegativeText: localizations.buttonNo,
      title: title,
      action: action,
      closeDuration: closeDuration,
    );
  }

  static Future<bool> decisionDialogOkCancel(
    BuildContext context,
    final String? title,
    final String content, {
    final VoidCallback? action,
    final Duration? closeDuration,
  }) async {
    final localizations = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    return await _messageDialog(context, content, localizations.buttonOk,
        buttonNegativeText: localizations.buttonCancel, title: title, action: action, closeDuration: closeDuration);
  }

  static Future<bool> _messageDialog(
    BuildContext context,
    final String content,
    final String buttonOkText, {
    final String? title,
    final VoidCallback? action,
    final String? buttonNegativeText,
    final Duration? closeDuration,
  }) async {
    final localizations = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    final appSize = getAppSize(context);
    final appStyle = getAppSize(context);

    Timer? closeTimer = closeDuration != null
        ? Timer(closeDuration, () => Navigator.of(context, rootNavigator: true).pop(false))
        : null;

    void closeDialog(bool isOk) {
      closeTimer?.cancel();
      if (isOk) {
        Navigator.of(context, rootNavigator: true).pop(true);
        if (action != null) action.runChain();
      } else {
        Navigator.of(context, rootNavigator: true).pop(false);
      }
    }

    void handleKeyEvent(RawKeyEvent event) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        closeDialog(true);
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        closeDialog(false);
      } else {
        closeDialog(false);
      }
    }

    KeyboardEvents.instance().subscribe(handleKeyEvent);

    final List<Widget> buttons = <Widget>[
      Buttons.elevatedButton(
        context: context,
        text: buttonOkText,
        onPressed: () => closeDialog(true),
      )
    ];
    if (buttonNegativeText != null) {
      buttons.add(Buttons.elevatedButton(
        context: context,
        text: buttonNegativeText,
        onPressed: () => closeDialog(false),
      ));
    }

    final bool dialogUserChoice = await showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: BeveledRectangleBorder(borderRadius: appStyle.borderRadius),
          title: title != null ? Text(title) : null,
          content: Text(content),
          contentPadding: EdgeInsets.only(
            top: appSize.dialogContentInsetTop,
            left: appSize.dialogContentInsetSide,
            bottom: appSize.dialogContentInsetBottom,
            right: appSize.dialogContentInsetSide,
          ),
          actions: buttons,
        );
      },
    );
    KeyboardEvents.instance().unSubscribe(handleKeyEvent);
    return dialogUserChoice;
  }
}
