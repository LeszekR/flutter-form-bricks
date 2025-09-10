import 'package:flutter/cupertino.dart';

import '../../../visual_params/app_color.dart';

class StatesColorMaker {
  Color? makeColor(Set<WidgetState>? states) {
    if (states == null) return null;

    return switch (states) {
      _ when states.contains(WidgetState.disabled) => AppColor.formFieldFillDisabled,
      _ when states.contains(WidgetState.error) => AppColor.formFieldFillError,
      _ when states.contains(WidgetState.focused) => AppColor.formFieldFillFocused,
      _ when states.contains(WidgetState.hovered) => AppColor.formFieldFillHovered,
      _ when states.contains(WidgetState.pressed) => AppColor.formFieldFillPressed,
      _ when states.contains(WidgetState.selected) => AppColor.formFieldFillSelected,
      _ => AppColor.formFieldFillOk,
    };
  }
}
