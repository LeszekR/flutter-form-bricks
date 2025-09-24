import 'package:flutter/cupertino.dart';

import 'bricks_theme_data.dart';

class BricksTheme extends InheritedWidget {
  final BricksThemeData data;

  const BricksTheme({required this.data, required super.child, super.key});

  static BricksThemeData of(BuildContext context) {
    final theme =  context.dependOnInheritedWidgetOfExactType<BricksTheme>();
    return theme?.data ?? BricksThemeData();
  }

  @override
  bool updateShouldNotify(BricksTheme oldWidget) =>
      data != oldWidget.data;
}
