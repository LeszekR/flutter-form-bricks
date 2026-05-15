import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class OutlineSidesInputBorder extends InputBorder {
  final double radiusTopLeft;
  final double radiusTopRight;
  final double radiusBottomLeft;
  final double radiusBottomRight;

  final bool sideTop;
  final bool sideLeft;
  final bool sideBottom;
  final bool sideRight;

  final double gapPadding;

  const OutlineSidesInputBorder({
    super.borderSide = const BorderSide(),
    this.radiusTopLeft = 4,
    this.radiusTopRight = 4,
    this.radiusBottomLeft = 4,
    this.radiusBottomRight = 4,
    this.sideTop = true,
    this.sideLeft = true,
    this.sideBottom = true,
    this.sideRight = true,
    this.gapPadding = 4.0,
  });

  BorderRadius get borderRadius => BorderRadius.only(
    topLeft: Radius.circular(sideTop && sideLeft ? radiusTopLeft : 0),
    topRight: Radius.circular(sideTop && sideRight ? radiusTopRight : 0),
    bottomLeft:
    Radius.circular(sideBottom && sideLeft ? radiusBottomLeft : 0),
    bottomRight:
    Radius.circular(sideBottom && sideRight ? radiusBottomRight : 0),
  );

  @override
  bool get isOutline => true;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.fromLTRB(
    sideLeft ? borderSide.width : 0,
    sideTop ? borderSide.width : 0,
    sideRight ? borderSide.width : 0,
    sideBottom ? borderSide.width : 0,
  );

  @override
  OutlineSidesInputBorder copyWith({
    BorderSide? borderSide,
    double? radiusTopLeft,
    double? radiusTopRight,
    double? radiusBottomLeft,
    double? radiusBottomRight,
    bool? sideTop,
    bool? sideLeft,
    bool? sideBottom,
    bool? sideRight,
    double? gapPadding,
  }) {
    return OutlineSidesInputBorder(
      borderSide: borderSide ?? this.borderSide,
      radiusTopLeft: radiusTopLeft ?? this.radiusTopLeft,
      radiusTopRight: radiusTopRight ?? this.radiusTopRight,
      radiusBottomLeft: radiusBottomLeft ?? this.radiusBottomLeft,
      radiusBottomRight: radiusBottomRight ?? this.radiusBottomRight,
      sideTop: sideTop ?? this.sideTop,
      sideLeft: sideLeft ?? this.sideLeft,
      sideBottom: sideBottom ?? this.sideBottom,
      sideRight: sideRight ?? this.sideRight,
      gapPadding: gapPadding ?? this.gapPadding,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return OutlineSidesInputBorder(
      borderSide: borderSide.scale(t),
      radiusTopLeft: radiusTopLeft * t,
      radiusTopRight: radiusTopRight * t,
      radiusBottomLeft: radiusBottomLeft * t,
      radiusBottomRight: radiusBottomRight * t,
      sideTop: sideTop,
      sideLeft: sideLeft,
      sideBottom: sideBottom,
      sideRight: sideRight,
      gapPadding: gapPadding * t,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
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
  void paint(
      Canvas canvas,
      Rect rect, {
        double? gapStart,
        double gapExtent = 0,
        double gapPercentage = 0,
        TextDirection? textDirection,
      }) {
    if (borderSide.style == BorderStyle.none || borderSide.width == 0) {
      return;
    }

    final Paint paint = borderSide.toPaint();
    final double half = borderSide.width / 2;
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

    _addTopSide(
      path: path,
      rect: rect,
      strokeRect: strokeRect,
      topLeftRadius: tl,
      topRightRadius: tr,
      gapStart: gapStart,
      gapExtent: gapExtent,
      gapPercentage: gapPercentage,
      textDirection: textDirection,
    );

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

  void _addTopSide({
    required Path path,
    required Rect rect,
    required Rect strokeRect,
    required double topLeftRadius,
    required double topRightRadius,
    required double? gapStart,
    required double gapExtent,
    required double gapPercentage,
    required TextDirection? textDirection,
  }) {
    if (!sideTop) return;

    final double startX =
    sideLeft ? strokeRect.left + topLeftRadius : rect.left;
    final double endX =
    sideRight ? strokeRect.right - topRightRadius : rect.right;

    if (gapStart == null || gapExtent <= 0 || gapPercentage == 0) {
      path.moveTo(startX, strokeRect.top);
      path.lineTo(endX, strokeRect.top);
      return;
    }

    final double animatedGapExtent = lerpDouble(
      0,
      gapExtent + gapPadding * 2,
      gapPercentage,
    )!;

    final double rawGapLeft;
    final double rawGapRight;

    switch (textDirection) {
      case TextDirection.rtl:
        rawGapLeft = rect.width - gapStart - animatedGapExtent;
        rawGapRight = rect.width - gapStart;
        break;
      case TextDirection.ltr:
      case null:
        rawGapLeft = gapStart - gapPadding;
        rawGapRight = gapStart + gapExtent + gapPadding;
        break;
    }

    final double gapLeft = rect.left + rawGapLeft.clamp(0.0, rect.width);
    final double gapRight = rect.left + rawGapRight.clamp(0.0, rect.width);

    if (gapLeft > startX) {
      path.moveTo(startX, strokeRect.top);
      path.lineTo(math.min(gapLeft, endX), strokeRect.top);
    }

    if (gapRight < endX) {
      path.moveTo(math.max(gapRight, startX), strokeRect.top);
      path.lineTo(endX, strokeRect.top);
    }
  }
}