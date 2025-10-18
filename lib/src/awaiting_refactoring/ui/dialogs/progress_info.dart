import 'dart:async';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_helpers/ui_helpers.dart';

class ProgressInfo {
  ProgressInfo._();

  static Widget spinner({required BuildContext context, final String message = "Proszę czekać"}) {
    final appSize = getAppSize(context);
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(appSize.spinnerInsets),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Center(child: CircularProgressIndicator()),
            appSize.spacerBoxVerticalMedium,
            Text(message),
          ],
        ),
      ),
    );
  }

  static Future<T?> showLoadingDialog<T>(
    BuildContext context,
    Future<T> future, {
    String? message,
  }) async {
    final txt = Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => spinner(context: context, message: message ?? txt.progressPleaseWait),
    );

    try {
      return await future;
    } catch (e) {
      debugPrint("Error occurred: $e");
      return null;
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
