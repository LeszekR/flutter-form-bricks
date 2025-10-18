import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:flutter_form_bricks/src/ui_helpers/ui_helpers.dart';

import '../buttons/buttons.dart';
import '../shortcuts/keyboard_shortcuts.dart';

class Dialogs {
  Dialogs._();

  static Future<void> informationDialog(
    BuildContext context,
    final String title,
    final String content,
  ) async {
    final txt = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    await _messageDialog(context, content, txt.buttonOk, title: title);
  }

  static Future<bool> decisionDialogYesNo(
    BuildContext context,
    final String? title,
    final String content, {
    final VoidCallback? action,
    final Duration? closeDuration,
  }) async {
    final txt = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    return await _messageDialog(
      context,
      content,
      txt.buttonYes,
      buttonNegativeText: txt.buttonNo,
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
    final txt = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    return await _messageDialog(context, content, txt.buttonOk,
        buttonNegativeText: txt.buttonCancel, title: title, action: action, closeDuration: closeDuration);
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
    final txt = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    final appSize = getAppSize(context);
    final appStyle = getAppSize(context);

    Timer? closeTimer = closeDuration != null
        ? Timer(closeDuration, () => Navigator.of(context, rootNavigator: true).pop(false))
        : null;

    void closeDialog(bool isOk) {
      closeTimer?.cancel();
      if (isOk) {
        Navigator.of(context, rootNavigator: true).pop(true);
        if (action != null) action.call();
      } else {
        Navigator.of(context, rootNavigator: true).pop(false);
      }
    }

    void handleKeyEvent(final RawKeyEvent event) {
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
