import 'package:flutter/cupertino.dart';

import '../../../visual_params/bricks_theme.dart';

class StatesColorMaker {
  Color? makeColor(BuildContext context, Set<WidgetState>? states) {
    if (states == null) return null;

    return switch (states) {
      _ when states.contains(WidgetState.disabled) => BricksTheme.of(context).colors.formFieldFillDisabled,
      _ when states.contains(WidgetState.error) => BricksTheme.of(context).colors.formFieldFillError,
      _ when states.contains(WidgetState.focused) => BricksTheme.of(context).colors.formFieldFillFocused,
      _ when states.contains(WidgetState.hovered) => BricksTheme.of(context).colors.formFieldFillHovered,
      _ when states.contains(WidgetState.pressed) => BricksTheme.of(context).colors.formFieldFillPressed,
      _ when states.contains(WidgetState.selected) => BricksTheme.of(context).colors.formFieldFillSelected,
      _ => BricksTheme.of(context).colors.formFieldFillOk,
    };
  }
}
