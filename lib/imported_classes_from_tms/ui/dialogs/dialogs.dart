import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../buttons/buttons.dart';
import '../shortcuts/keyboard_shortcuts.dart';
import '../style/app_size.dart';
import '../style/app_style.dart';

class Dialogs {
  Dialogs._();

  static Future<void> informationDialog(final BuildContext context, final String title, final String content) async {
    await _messageDialog(context, content, Tr.get.buttonOk, title: title);
  }

  static Future<bool> decisionDialogYesNo(final BuildContext context, final String? title, final String content,
      {final VoidCallback? action, final Duration? closeDuration}) async {
    return await _messageDialog(context, content, Tr.get.buttonYes,
        buttonCancelText: Tr.get.buttonNo, title: title, action: action, closeDuration: closeDuration);
  }

  static Future<bool> decisionDialogOkCancel(final BuildContext context, final String? title, final String content,
      {final VoidCallback? action, final Duration? closeDuration}) async {
    return await _messageDialog(context, content, Tr.get.buttonOk, buttonCancelText: Tr.get.buttonCancel, title: title, action: action, closeDuration: closeDuration);
  }

  static Future<bool> _messageDialog(final BuildContext context, final String content, final String buttonOkText,
      {final String? title,
      final VoidCallback? action,
      final String? buttonCancelText,
      final Duration? closeDuration}) async {
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
        text: buttonOkText,
        onPressed: () => closeDialog(true),
      )
    ];
    if (buttonCancelText != null) {
      buttons.add(Buttons.elevatedButton(
        text: buttonCancelText,
        onPressed: () => closeDialog(false),
      ));
    }

    final bool dialogUserChoice = await showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (final BuildContext context) {
        return AlertDialog(
          shape: BeveledRectangleBorder(borderRadius: AppStyle.borderRadius),
          title: title != null ? Text(title) : null,
          content: Text(content),
          contentPadding: EdgeInsets.only(
              top: AppSize.dialogContentInsetTop,
              left: AppSize.dialogContentInsetSide,
              bottom: AppSize.dialogContentInsetBottom,
              right: AppSize.dialogContentInsetSide,
          ),
          actions: buttons,
        );
      },
    );
    KeyboardEvents.instance().unSubscribe(handleKeyEvent);
    return dialogUserChoice;
  }
}
