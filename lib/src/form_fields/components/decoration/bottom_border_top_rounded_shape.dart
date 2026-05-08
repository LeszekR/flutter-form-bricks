import 'package:flutter/material.dart';

class BottomBorderTopRoundedShape extends OutlinedBorder {
  final double borderRadius;

  const BottomBorderTopRoundedShape({
    super.side = const BorderSide(),
    this.borderRadius = 4,
  });

  BorderRadius get _radius => BorderRadius.only(
    topLeft: Radius.circular(borderRadius),
    topRight: Radius.circular(borderRadius),
  );

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: side.width);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
        _radius.resolve(textDirection).toRRect(rect),
      );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
        _radius.resolve(textDirection).toRRect(rect.deflate(side.width)),
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width == 0) return;

    final Paint paint = Paint()
      ..color = side.color
      ..strokeWidth = side.width
      ..style = PaintingStyle.stroke;

    final double y = rect.bottom - side.width / 2;

    canvas.drawLine(
      Offset(rect.left, y),
      Offset(rect.right, y),
      paint,
    );
  }

  @override
  BottomBorderTopRoundedShape copyWith({
    BorderSide? side,
    double? borderRadius,
    Color? color,
  }) {
    return BottomBorderTopRoundedShape(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return BottomBorderTopRoundedShape(
      side: side.scale(t),
      borderRadius: borderRadius * t,
    );
  }
}