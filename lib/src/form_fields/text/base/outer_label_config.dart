import 'package:flutter/material.dart';

enum Side { top, bottom, left, right }

class OuterLabelConfig {
  final Widget? labelWidget;
  final String? labelText;
  final Side side;
  final Alignment align;

  const OuterLabelConfig({
    this.labelWidget,
    this.labelText,
    this.side = Side.top,
    this.align = Alignment.bottomLeft,
  }) : assert((labelWidget == null) != (labelText == null), 'Either labelWidget or labelText must be declared');
}
