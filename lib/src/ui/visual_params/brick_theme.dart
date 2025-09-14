import 'package:flutter/cupertino.dart';

import 'brick_theme_data.dart';

class BrickTheme extends InheritedWidget {
  final BrickThemeData data;

  const BrickTheme({required this.data, required super.child, super.key});

  static BrickThemeData of(BuildContext context) {
    final theme =  context.dependOnInheritedWidgetOfExactType<BrickTheme>();
    return theme?.data ?? BrickThemeData();
  }

  @override
  bool updateShouldNotify(BrickTheme oldWidget) =>
      data != oldWidget.data;
}
