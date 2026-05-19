import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CompoundWidgetStatesController extends ChangeNotifier {
  late final _WidgetStatesSink fieldStatesSink;
  late final _WidgetStatesSink buttonStatesSink;

  CompoundWidgetStatesController() {
    fieldStatesSink = _WidgetStatesSink(this);
    buttonStatesSink = _WidgetStatesSink(this);
  }

  Set<WidgetState> get states => {
        if (buttonStatesSink.disabled || fieldStatesSink.disabled) WidgetState.disabled,
        if (fieldStatesSink.error) WidgetState.error,
        if (buttonStatesSink.pressed || fieldStatesSink.pressed) WidgetState.pressed,
        if (buttonStatesSink.focused || fieldStatesSink.focused) WidgetState.focused,
        if (fieldStatesSink.hovered) WidgetState.hovered,
      };

  void setWidgetState(VoidCallback change) {
    final oldStates = states;
    change();
    if (!setEquals(oldStates, states)) {
      notifyListeners();
    }
  }

  static Focus wrapWithStateDetectors(
    _WidgetStatesSink statesSink,
    FocusNode focusNode,
    Widget child,
  ) {
    return Focus(
      focusNode: focusNode,
      onFocusChange: (_) {
        if (focusNode.hasFocus) {
          statesSink.setFocused(true);
        } else {
          statesSink.setFocused(false);
          statesSink.setPressed(false);
        }
      },
      child: MouseRegion(
        onEnter: (_) => statesSink.setHovered(true),
        onExit: (_) => statesSink.setHovered(false),
        child: GestureDetector(
          onTapDown: (_) => statesSink.setPressed(true),
          onTapUp: (_) => statesSink.setPressed(false),
          onTapCancel: () => statesSink.setPressed(false),
          child: child,
        ),
      ),
    );
  }
}

class _WidgetStatesSink {
  CompoundWidgetStatesController controller;

  bool hovered = false;
  bool focused = false;
  bool pressed = false;
  bool disabled = false;
  bool error = false;

  _WidgetStatesSink(this.controller);

  void setHovered(bool value) => controller.setWidgetState(() => hovered = value);

  void setFocused(bool value) => controller.setWidgetState(() => focused = value);

  void setPressed(bool value) => controller.setWidgetState(() => pressed = value);

  void setDisabled(bool value) => controller.setWidgetState(() => disabled = value);

  void setError(bool value) => controller.setWidgetState(() => error = value);
}
