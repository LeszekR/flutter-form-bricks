import 'package:flutter/material.dart';

enum OuterLabelPosition { top, bottom, left, right }

class OuterLabelConfig {
  final Widget? outerLabel;
  final String? outerLabelText;
  final OuterLabelPosition outerLabelPosition;

  const OuterLabelConfig({
    required this.outerLabelPosition,
    this.outerLabel,
    this.outerLabelText,
  }) : assert((outerLabel == null) != (outerLabelText == null), 'Either outerLabel or outerLabelText must be declared');
}
