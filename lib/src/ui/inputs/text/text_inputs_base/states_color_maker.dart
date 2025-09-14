import 'package:flutter/cupertino.dart';

import '../../../visual_params/brick_theme.dart';

class StatesColorMaker {
  Color? makeColor(BuildContext context, Set<WidgetState>? states) {
    if (states == null) return null;

    return switch (states) {
      _ when states.contains(WidgetState.disabled) => BrickTheme.of(context).colors.formFieldFillDisabled,
      _ when states.contains(WidgetState.error) => BrickTheme.of(context).colors.formFieldFillError,
      _ when states.contains(WidgetState.focused) => BrickTheme.of(context).colors.formFieldFillFocused,
      _ when states.contains(WidgetState.hovered) => BrickTheme.of(context).colors.formFieldFillHovered,
      _ when states.contains(WidgetState.pressed) => BrickTheme.of(context).colors.formFieldFillPressed,
      _ when states.contains(WidgetState.selected) => BrickTheme.of(context).colors.formFieldFillSelected,
      _ => BrickTheme.of(context).colors.formFieldFillOk,
    };
  }
}
