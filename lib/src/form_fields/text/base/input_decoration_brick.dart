import 'package:flutter/material.dart';

class InputDecorationBrick {
  final InputDecoration decoration;
  final Widget Function(BuildContext context, String text)? errorBuilder;
  final Widget Function(BuildContext context, String text)? helperBuilder;

  InputDecorationBrick({
    this.decoration = const InputDecoration(),
    this.errorBuilder,
    this.helperBuilder,
  }) : assert(
          decoration.error == null && decoration.helper == null,
          'Use errorBuilder/helperBuilder instead of InputDecoration.error/helper.',
        );
}
