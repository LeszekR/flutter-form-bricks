import 'dart:async';

import 'package:flutter/material.dart';

import '../style/app_size.dart';

class ProgressInfo {
  ProgressInfo._();

  static Widget spinner({final String message = "Proszę czekać"}) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(AppSize.spinnerInsets),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Center(child: CircularProgressIndicator()),
            AppSize.spacerBoxVerticalMedium,
            Text(message),
          ],
        ),
      ),
    );
  }

  static Future<T?> showLoadingDialog<T>(BuildContext context, Future<T> future,
      {final String message = "Proszę czekać"}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (final BuildContext context) => spinner(message: message),
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
