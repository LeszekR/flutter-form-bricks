import 'dart:math' as math;

import 'package:flutter/material.dart';

class OutlineSidesShape extends OutlinedBorder {
  final double radiusTopLeft;
  final double radiusTopRight;
  final double radiusBottomLeft;
  final double radiusBottomRight;

  final bool sideTop;
  final bool sideLeft;
  final bool sideBottom;
  final bool sideRight;

  const OutlineSidesShape({
    super.side = const BorderSide(),
    this.radiusTopLeft = 4,
    this.radiusTopRight = 4,
    this.radiusBottomLeft = 4,
    this.radiusBottomRight = 4,
    this.sideTop = true,
    this.sideLeft = true,
    this.sideBottom = true,
    this.sideRight = true,
  });

  BorderRadius get _effectiveRadius => BorderRadius.only(
    topLeft: Radius.circular(sideTop && sideLeft ? radiusTopLeft : 0),
    topRight: Radius.circular(sideTop && sideRight ? radiusTopRight : 0),
    bottomLeft:
    Radius.circular(sideBottom && sideLeft ? radiusBottomLeft : 0),
    bottomRight:
    Radius.circular(sideBottom && sideRight ? radiusBottomRight : 0),
  );

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.fromLTRB(
    sideLeft ? side.width : 0,
    sideTop ? side.width : 0,
    sideRight ? side.width : 0,
    sideBottom ? side.width : 0,
  );

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(_effectiveRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
        _effectiveRadius.resolve(textDirection).toRRect(
          rect.deflate(side.width),
        ),
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width == 0) return;

    final Paint paint = side.toPaint();
    final double half = side.width / 2;
    final Rect strokeRect = rect.deflate(half);

    final double maxRadius =
        math.min(strokeRect.width, strokeRect.height) / 2;

    final double tl =
    sideTop && sideLeft ? math.min(radiusTopLeft, maxRadius) : 0;
    final double tr =
    sideTop && sideRight ? math.min(radiusTopRight, maxRadius) : 0;
    final double bl =
    sideBottom && sideLeft ? math.min(radiusBottomLeft, maxRadius) : 0;
    final double br =
    sideBottom && sideRight ? math.min(radiusBottomRight, maxRadius) : 0;

    final Path path = Path();

    if (sideTop) {
      final double startX = sideLeft ? strokeRect.left + tl : rect.left;
      final double endX = sideRight ? strokeRect.right - tr : rect.right;

      path.moveTo(startX, strokeRect.top);
      path.lineTo(endX, strokeRect.top);
    }

    if (sideTop && sideRight && tr > 0) {
      path.arcTo(
        Rect.fromLTWH(
          strokeRect.right - tr * 2,
          strokeRect.top,
          tr * 2,
          tr * 2,
        ),
        -math.pi / 2,
        math.pi / 2,
        false,
      );
    }

    if (sideRight) {
      final double startY = sideTop ? strokeRect.top + tr : rect.top;
      final double endY = sideBottom ? strokeRect.bottom - br : rect.bottom;

      path.moveTo(strokeRect.right, startY);
      path.lineTo(strokeRect.right, endY);
    }

    if (sideRight && sideBottom && br > 0) {
      path.arcTo(
        Rect.fromLTWH(
          strokeRect.right - br * 2,
          strokeRect.bottom - br * 2,
          br * 2,
          br * 2,
        ),
        0,
        math.pi / 2,
        false,
      );
    }

    if (sideBottom) {
      final double startX = sideRight ? strokeRect.right - br : rect.right;
      final double endX = sideLeft ? strokeRect.left + bl : rect.left;

      path.moveTo(startX, strokeRect.bottom);
      path.lineTo(endX, strokeRect.bottom);
    }

    if (sideBottom && sideLeft && bl > 0) {
      path.arcTo(
        Rect.fromLTWH(
          strokeRect.left,
          strokeRect.bottom - bl * 2,
          bl * 2,
          bl * 2,
        ),
        math.pi / 2,
        math.pi / 2,
        false,
      );
    }

    if (sideLeft) {
      final double startY = sideBottom ? strokeRect.bottom - bl : rect.bottom;
      final double endY = sideTop ? strokeRect.top + tl : rect.top;

      path.moveTo(strokeRect.left, startY);
      path.lineTo(strokeRect.left, endY);
    }

    if (sideLeft && sideTop && tl > 0) {
      path.arcTo(
        Rect.fromLTWH(
          strokeRect.left,
          strokeRect.top,
          tl * 2,
          tl * 2,
        ),
        math.pi,
        math.pi / 2,
        false,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  OutlineSidesShape copyWith({
    BorderSide? side,
    double? radiusTopLeft,
    double? radiusTopRight,
    double? radiusBottomLeft,
    double? radiusBottomRight,
    bool? sideTop,
    bool? sideLeft,
    bool? sideBottom,
    bool? sideRight,
    Color? color,
  }) {
    return OutlineSidesShape(
      side: side ?? this.side,
      radiusTopLeft: radiusTopLeft ?? this.radiusTopLeft,
      radiusTopRight: radiusTopRight ?? this.radiusTopRight,
      radiusBottomLeft: radiusBottomLeft ?? this.radiusBottomLeft,
      radiusBottomRight: radiusBottomRight ?? this.radiusBottomRight,
      sideTop: sideTop ?? this.sideTop,
      sideLeft: sideLeft ?? this.sideLeft,
      sideBottom: sideBottom ?? this.sideBottom,
      sideRight: sideRight ?? this.sideRight,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return OutlineSidesShape(
      side: side.scale(t),
      radiusTopLeft: radiusTopLeft * t,
      radiusTopRight: radiusTopRight * t,
      radiusBottomLeft: radiusBottomLeft * t,
      radiusBottomRight: radiusBottomRight * t,
      sideTop: sideTop,
      sideLeft: sideLeft,
      sideBottom: sideBottom,
      sideRight: sideRight,
    );
  }
}