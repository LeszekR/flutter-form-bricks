import 'package:flutter/material.dart';

enum OuterLabelSide { top, bottom, left, right }

class OuterLabelConfig {
  final Widget? outerLabel;
  final String? outerLabelText;
  final OuterLabelSide outerLabelSide;
  final Alignment outerLabelAlign;

  const OuterLabelConfig({
    this.outerLabel,
    this.outerLabelText,
    this.outerLabelSide = OuterLabelSide.top,
    this.outerLabelAlign = Alignment.bottomLeft,
  }) : assert((outerLabel == null) != (outerLabelText == null), 'Either outerLabel or outerLabelText must be declared');
}
