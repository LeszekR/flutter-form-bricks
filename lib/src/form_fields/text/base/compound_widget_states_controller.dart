import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CompoundWidgetStatesController extends ValueNotifier<Set<WidgetState>> {
  late final WidgetStatesSink fieldStatesSink;
  late final WidgetStatesSink buttonStatesSink;

  CompoundWidgetStatesController() : super(const {}) {
    fieldStatesSink = WidgetStatesSink(this);
    buttonStatesSink = WidgetStatesSink(this);
    value = _computeStates();
  }

  Set<WidgetState> get states => value;

  void setWidgetState(VoidCallback change) {
    final oldStates = value;

    change();

    final newStates = _computeStates();
    if (!setEquals(oldStates, newStates)) {
      value = newStates;
    }
  }

  Set<WidgetState> _computeStates() {
    return {
      if (buttonStatesSink.disabled || fieldStatesSink.disabled) WidgetState.disabled,
      if (fieldStatesSink.error) WidgetState.error,
      if (buttonStatesSink.pressed || fieldStatesSink.pressed) WidgetState.pressed,
      if (buttonStatesSink.focused || fieldStatesSink.focused) WidgetState.focused,
      if (fieldStatesSink.hovered) WidgetState.hovered,
    };
  }

  /// Wraps [child] with state detectors. If [focusNode] is provided, it uses a Focus wrapper.
  /// If [focusNode] is null, it only detects Hover and Tap/Press states.
  static Widget wrapWithStateDetectors({
    required WidgetStatesSink statesSink,
    FocusNode? focusNode,
    required Widget child,
  }) {
    Widget current = MouseRegion(
      onEnter: (_) => statesSink.setHovered(true),
      onExit: (_) => statesSink.setHovered(false),
      child: GestureDetector(
        onTapDown: (_) => statesSink.setPressed(true),
        onTapUp: (_) => statesSink.setPressed(false),
        onTapCancel: () => statesSink.setPressed(false),
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );

    if (focusNode != null) {
      return Focus(
        focusNode: focusNode,
        onFocusChange: (hasFocus) {
          statesSink.setFocused(hasFocus);
          if (!hasFocus) {
            statesSink.setPressed(false);
          }
        },
        child: current,
      );
    }
    return current;
  }
}

class WidgetStatesSink {
  CompoundWidgetStatesController controller;

  bool hovered = false;
  bool focused = false;
  bool pressed = false;
  bool disabled = false;
  bool error = false;

  WidgetStatesSink(this.controller);

  void setHovered(bool value) => controller.setWidgetState(() => hovered = value);

  void setFocused(bool value) => controller.setWidgetState(() => focused = value);

  void setPressed(bool value) => controller.setWidgetState(() => pressed = value);

  void setDisabled(bool value) => controller.setWidgetState(() => disabled = value);

  void setError(bool value) => controller.setWidgetState(() => error = value);
}
