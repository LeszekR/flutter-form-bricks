import 'package:flutter/material.dart';

enum Side { top, bottom, left, right }

class OuterLabelConfig {
  final double? width;
  final double? height;
  final Widget? labelWidget;
  final String? labelText;
  final Side side;
  final Alignment align;
  // TODO add style of the label - when it is not a widget but text

  const OuterLabelConfig({
    this.width,
    this.height,
    this.labelWidget,
    this.labelText,
    this.side = Side.top,
    this.align = Alignment.bottomLeft,
  })  : assert((labelWidget == null) != (labelText == null), 'Either labelWidget or labelText must be declared'),
        assert(
          (side == Side.left || side == Side.right) ? width != null : true,
          'width must be provided when side is left or right',
        ),
        assert(
          side == Side.top || side == Side.bottom ? width == null : true,
          'width must be null when side is left or right',
        ),
        assert(
          side == Side.top || side == Side.bottom ? height != null : true,
          'height must be provided when side is top or bottom',
        );

  OuterLabelConfig fillFrom(OuterLabelConfig? other) {
    return OuterLabelConfig(
      width: other?.width ?? this.width,
      height: other?.height ?? this.height,
      labelWidget: labelWidget,
      labelText: labelText,
      side: other?.side ?? this.side,
      align: other?.align ?? this.align,
    );
  }
}
