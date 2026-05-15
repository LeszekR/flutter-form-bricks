import 'package:flutter/material.dart';

class UnderlineTopRoundedInputBorder extends InputBorder {
  final double radiusTopLeft;
  final double radiusTopRight;
  final double radiusBottomLeft;
  final double radiusBottomRight;

  const UnderlineTopRoundedInputBorder({
    super.borderSide = const BorderSide(),
    this.radiusTopLeft = 4,
    this.radiusTopRight = 4,
    this.radiusBottomLeft = 0,
    this.radiusBottomRight = 0,
  });

  BorderRadius get borderRadius => BorderRadius.only(
    topLeft: Radius.circular(radiusTopLeft),
    topRight: Radius.circular(radiusTopRight),
    bottomLeft: Radius.circular(radiusBottomLeft),
    bottomRight: Radius.circular(radiusBottomRight),
  );

  @override
  bool get isOutline => false;

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: borderSide.width);

  @override
  UnderlineTopRoundedInputBorder copyWith({
    BorderSide? borderSide,
    double? radiusTopLeft,
    double? radiusTopRight,
    double? radiusBottomLeft,
    double? radiusBottomRight,
  }) {
    return UnderlineTopRoundedInputBorder(
      borderSide: borderSide ?? this.borderSide,
      radiusTopLeft: radiusTopLeft ?? this.radiusTopLeft,
      radiusTopRight: radiusTopRight ?? this.radiusTopRight,
      radiusBottomLeft: radiusBottomLeft ?? this.radiusBottomLeft,
      radiusBottomRight: radiusBottomRight ?? this.radiusBottomRight,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return UnderlineTopRoundedInputBorder(
      borderSide: borderSide.scale(t),
      radiusTopLeft: radiusTopLeft * t,
      radiusTopRight: radiusTopRight * t,
      radiusBottomLeft: radiusBottomLeft * t,
      radiusBottomRight: radiusBottomRight * t,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
        borderRadius.resolve(textDirection).toRRect(
          rect.deflate(borderSide.width),
        ),
      );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
        borderRadius.resolve(textDirection).toRRect(rect),
      );
  }

  @override
  void paint(
      Canvas canvas,
      Rect rect, {
        double? gapStart,
        double gapExtent = 0,
        double gapPercentage = 0,
        TextDirection? textDirection,
      }) {
    if (borderSide.style == BorderStyle.none ||
        borderSide.width == 0) {
      return;
    }

    final Paint paint = borderSide.toPaint();

    final double y = rect.bottom - borderSide.width / 2;

    final double left =
        rect.left + radiusBottomLeft;

    final double right =
        rect.right - radiusBottomRight;

    canvas.drawLine(
      Offset(left, y),
      Offset(right, y),
      paint,
    );

    if (radiusBottomLeft > 0) {
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(
            rect.left + radiusBottomLeft,
            rect.bottom - radiusBottomLeft,
          ),
          radius: radiusBottomLeft,
        ),
        3.1415926535 / 2,
        3.1415926535 / 2,
        false,
        paint,
      );
    }

    if (radiusBottomRight > 0) {
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(
            rect.right - radiusBottomRight,
            rect.bottom - radiusBottomRight,
          ),
          radius: radiusBottomRight,
        ),
        0,
        3.1415926535 / 2,
        false,
        paint,
      );
    }
  }
}