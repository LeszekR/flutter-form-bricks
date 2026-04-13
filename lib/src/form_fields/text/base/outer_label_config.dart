import 'package:flutter/material.dart';

enum Side { top, bottom, left, right }

class OuterLabelConfig {
  final Widget? labelWidget;
  final String? labelText;
  final Side side;
  final Alignment align;
  final double? width;

  const OuterLabelConfig({
    this.labelWidget,
    this.labelText,
    this.side = Side.top,
    this.align = Alignment.bottomLeft,
    this.width,
  })  : assert((labelWidget == null) != (labelText == null), 'Either labelWidget or labelText must be declared'),
        assert(
          (side == Side.left || side == Side.right) ? width != null : true,
          'width must be provided when side is left or right',
        );

  OuterLabelConfig fillFrom(OuterLabelConfig? other) {
    return OuterLabelConfig(
      labelWidget: labelWidget,
      labelText: labelText,
      side: other?.side ?? this.side,
      align: other?.align ?? this.align,
      width: other?.width ?? this.width,
    );
  }
}
