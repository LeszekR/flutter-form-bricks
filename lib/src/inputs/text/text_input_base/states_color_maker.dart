import 'package:flutter/cupertino.dart';

import '../../../ui_params/ui_params.dart';

class StatesColorMaker {
  Color? makeColor(BuildContext context, Set<WidgetState>? states) {
    if (states == null) return null;

    return switch (states) {
      _ when states.contains(WidgetState.disabled) => UiParams.of(context).appColor.formFieldFillDisabled,
      _ when states.contains(WidgetState.error) => UiParams.of(context).appColor.formFieldFillError,
      _ when states.contains(WidgetState.focused) => UiParams.of(context).appColor.formFieldFillFocused,
      _ when states.contains(WidgetState.hovered) => UiParams.of(context).appColor.formFieldFillHovered,
      _ when states.contains(WidgetState.pressed) => UiParams.of(context).appColor.formFieldFillPressed,
      _ when states.contains(WidgetState.selected) => UiParams.of(context).appColor.formFieldFillSelected,
      _ => UiParams.of(context).appColor.formFieldFillOk,
    };
  }
}
