import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CompoundWidgetStatesController extends ChangeNotifier {
  bool _buttonHovered = false;
  bool _buttonFocused = false;
  bool _buttonPressed = false;
  bool _buttonDisabled = false;

  bool _fieldHovered = false;
  bool _fieldFocused = false;
  bool _fieldPressed = false;
  bool _fieldDisabled = false;
  bool _fieldError = false;

  Set<WidgetState> get states => {
        if (_buttonHovered || _fieldHovered) WidgetState.hovered,
        if (_buttonFocused || _fieldFocused) WidgetState.focused,
        if (_buttonPressed || _fieldPressed) WidgetState.pressed,
        if (_buttonDisabled || _fieldDisabled) WidgetState.disabled,
        if (_fieldError) WidgetState.error,
      };

  void setButtonHovered(bool value) => _set(() => _buttonHovered = value);
  void setButtonFocused(bool value) => _set(() => _buttonFocused = value);
  void setButtonPressed(bool value) => _set(() => _buttonPressed = value);
  void setButtonDisabled(bool value) => _set(() => _buttonDisabled = value);
  void setFieldHovered(bool value) => _set(() => _fieldHovered = value);
  void setFieldFocused(bool value) => _set(() => _fieldFocused = value);
  void setFieldPressed(bool value) => _set(() => _fieldPressed = value);
  void setFieldDisabled(bool value) => _set(() => _fieldDisabled = value);
  void setFieldError(bool value) => _set(() => _fieldError = value);

  void _set(VoidCallback change) {
    final oldStates = states;
    change();
    if (!setEquals(oldStates, states)) {
      notifyListeners();
    }
  }

  static MouseRegion wrapWithStateDetectors(
    CompoundWidgetStatesController compoundController,
    FocusNode focusNode,
    Widget child,
  ) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        compoundController.setButtonFocused(true);
      } else {
        compoundController.setButtonFocused(false);
        compoundController.setButtonPressed(false);
      }
    });
    return MouseRegion(
      onHover: (event) {
        compoundController.setButtonHovered(true);
      },
      onEnter: (event) {
        compoundController.setButtonHovered(false);
      },
      onExit: (event) {
        compoundController.setButtonHovered(false);
      },
      child: GestureDetector(
        onTapDown: (_) {
          // TODO #101 make the field get focus after the button has been clicked
          compoundController.setButtonPressed(true);
        },
        onDoubleTapDown: (_) {
          compoundController.setButtonPressed(true);
        },
        onForcePressStart: (_) {
          compoundController.setButtonPressed(true);
        },
        onLongPress: () {
          compoundController.setButtonPressed(true);
        },
        child: Focus(
          focusNode: focusNode,
          child: child,
        ),
      ),
    );
  }
}
