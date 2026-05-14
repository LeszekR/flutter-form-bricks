import 'package:flutter/material.dart';

class BottomBorderTopRoundedShape extends OutlinedBorder {
  final double radiusTopLeft;
  final double radiusTopRight;
  final double radiusBottomLeft;
  final double radiusBottomRight;

  const BottomBorderTopRoundedShape({
    super.side = const BorderSide(),
    this.radiusTopLeft = 0,
    this.radiusTopRight = 0,
    this.radiusBottomLeft = 0,
    this.radiusBottomRight = 0,
  });

  BorderRadius get _radius => BorderRadius.only(
    topLeft: Radius.circular(radiusTopLeft),
    topRight: Radius.circular(radiusTopRight),
    bottomLeft: Radius.circular(radiusBottomLeft),
    bottomRight: Radius.circular(radiusBottomRight),
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
    double? radiusTopLeft,
    double? radiusTopRight,
    double? radiusBottomLeft,
    double? radiusBottomRight,
    Color? color,
  }) {
    return BottomBorderTopRoundedShape(
      side: side ?? this.side,
      radiusTopLeft: radiusTopLeft ?? this.radiusTopLeft,
      radiusTopRight: radiusTopRight ?? this.radiusTopRight,
      radiusBottomLeft: radiusBottomLeft ?? this.radiusBottomLeft,
      radiusBottomRight: radiusBottomRight ?? this.radiusBottomRight,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return BottomBorderTopRoundedShape(
      side: side.scale(t),
      radiusTopLeft: radiusTopLeft * t,
      radiusTopRight: radiusTopRight * t,
      radiusBottomLeft: radiusBottomLeft * t,
      radiusBottomRight: radiusBottomRight * t,
    );
  }
}