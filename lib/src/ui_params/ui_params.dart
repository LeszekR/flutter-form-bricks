import 'package:flutter/material.dart';

import 'ui_params_data.dart';

class UiParams extends InheritedWidget {
  final UiParamsData data;

  const UiParams({
    required this.data,
    required super.child,
    super.key,
  });

  static UiParamsData of(BuildContext context) {
    final uiParams = context.dependOnInheritedWidgetOfExactType<UiParams>();
    if (uiParams == null) {
      throw FlutterError(
        'UiParams.of() called with a context that does not contain a UiParams.\n'
        'Wrap your app with UiParams.',
      );
    }
    return uiParams.data;
  }

  @override
  bool updateShouldNotify(UiParams oldWidget) => data != oldWidget.data;
}
