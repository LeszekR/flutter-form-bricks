import 'package:flutter/material.dart';

enum Side { top, bottom, left, right }

class OuterLabelConfig {
  final Widget? labelWidget;
  final String? labelText;
  final Side side;
  final Alignment align;
  final double? width;
  final double? height;

  const OuterLabelConfig({
    this.labelWidget,
    this.labelText,
    this.side = Side.top,
    this.align = Alignment.bottomLeft,
    this.width,
    this.height,
  })  : assert((labelWidget == null) != (labelText == null), 'Either labelWidget or labelText must be declared'),
        assert(
          (side == Side.left || side == Side.right) ? width != null : true,
          'width must be provided when side is left or right',
        ),
        assert(
          side == Side.left || side == Side.right ? width != null : true,
          'width must be provided when side is left or right',
        ),
        assert(
          side == Side.top || side == Side.bottom ? height != null : true,
          'height must be provided when side is top or bottom',
        );

  OuterLabelConfig fillFrom(OuterLabelConfig? other) {
    return OuterLabelConfig(
      labelWidget: labelWidget,
      labelText: labelText,
      side: other?.side ?? this.side,
      align: other?.align ?? this.align,
      width: other?.width ?? this.width,
      height: other?.height ?? this.height,
    );
  }
}
