import 'package:flutter/material.dart';

enum OuterLabelSide { top, bottom, left, right }

enum OuterLabelAlign { start, center, end }

class OuterLabelConfig {
  final Widget? outerLabel;
  final String? outerLabelText;
  final OuterLabelSide outerLabelSide;
  final OuterLabelAlign outerLabelAlign;

  const OuterLabelConfig({
    this.outerLabel,
    this.outerLabelText,
    this.outerLabelSide = OuterLabelSide.top,
    this.outerLabelAlign = OuterLabelAlign.start,
  }) : assert((outerLabel == null) != (outerLabelText == null), 'Either outerLabel or outerLabelText must be declared');
}
