import 'package:flutter/cupertino.dart';

import '../../../ui_params/ui_params.dart';

class StatesColorMaker {
  Color? makeColor(BuildContext context, Set<WidgetState>? states) {
    if (states == null) return null;

    return switch (states) {
      _ when states.contains(WidgetState.disabled) => UiParams.of(context).color.formFieldFillDisabled,
      _ when states.contains(WidgetState.error) => UiParams.of(context).color.formFieldFillError,
      _ when states.contains(WidgetState.focused) => UiParams.of(context).color.formFieldFillFocused,
      _ when states.contains(WidgetState.hovered) => UiParams.of(context).color.formFieldFillHovered,
      _ when states.contains(WidgetState.pressed) => UiParams.of(context).color.formFieldFillPressed,
      _ when states.contains(WidgetState.selected) => UiParams.of(context).color.formFieldFillSelected,
      _ => UiParams.of(context).color.formFieldFillOk,
    };
  }
}
