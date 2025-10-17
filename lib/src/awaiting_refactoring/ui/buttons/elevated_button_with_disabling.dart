import 'package:flutter/material.dart';

class ElevatedButtonWithDisabling extends ElevatedButton {

  final bool isActive = true;

  // TODO: method setStyle(bool isActive)

  const ElevatedButtonWithDisabling({
    super.key,
    required super.onPressed,
    required super.child,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    isActive = true
  });

}
