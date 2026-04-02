import 'package:flutter/material.dart' show InputDecoration, Widget;
import 'package:flutter_form_bricks/src/form_fields/text/base/icon_button_config.dart';

enum OuterLabelPosition { top, bottom, left, right }

enum ButtonPosition { leftTop, leftFullHeight, rightTop, rightFullHeight }

class InputDecorationBrick {
  final String keyString;
  final Widget? outerLabel;
  final String? outerLabelText;
  final OuterLabelPosition? outerLabelPosition;
  final IconButtonConfig? buttonParams;
  final ButtonPosition? buttonPosition;
  final InputDecoration? inputDecoration;

  InputDecorationBrick({
    required this.keyString,
    this.outerLabel,
    this.outerLabelText,
    this.outerLabelPosition,
    this.buttonParams,
    this.buttonPosition,
    this.inputDecoration,
  })  : assert(
          (outerLabel != null ? 1 : 0) +
                  (outerLabelText != null ? 1 : 0) +
                  (inputDecoration?.label != null ? 1 : 0) +
                  (inputDecoration?.labelText != null ? 1 : 0) <= 1,
          'Only one can be declared: outerLabel, outerLabelText, inputDecoration.label, or inputDecoration.labelText '
              'in "$keyString" field.',
        ),
        assert(
          outerLabel == null || outerLabelText == null,
          'Only one of outerLabel and outerLabelText can be declared in "$keyString" field.',
        ),
        assert(
          outerLabelPosition == null || (inputDecoration?.label == null && inputDecoration?.labelText == null),
          'If outerLabelPosition is declared, inputDecoration must not declare label or labelText in "$keyString" field.',
        ),
        assert(
          (outerLabel == null && outerLabelText == null) || outerLabelPosition != null,
          'If outerLabel or outerLabelText is declared, outerLabelPosition must also be declared in "$keyString" field.',
        ),
        assert(
          outerLabelPosition == null || outerLabel != null || outerLabelText != null,
          'If outerLabelPosition is declared, outerLabel or outerLabelText must also be declared in "$keyString" field.',
        ),
        assert(
          (buttonParams == null) == (buttonPosition == null),
          'buttonParams and buttonPosition must be declared together or both be null in "$keyString" field.',
        ),
        assert(
          inputDecoration?.error == null || inputDecoration?.errorText == null,
          'Only one can be declared: inputDecoration.error or inputDecoration.errorText in "$keyString" field.',
        ),
        assert(
          inputDecoration?.hint == null || inputDecoration?.hintText == null,
          'Only one can be declared: inputDecoration.hint or inputDecoration.hintText in "$keyString" field.',
        ),
        assert(
          inputDecoration?.helper == null || inputDecoration?.helperText == null,
          'Only one can be declared: inputDecoration.helper or inputDecoration.helperText in "$keyString" field.',
        ),
        assert(
          inputDecoration?.counter == null || inputDecoration?.counterText == null,
          'Only one can be declared: inputDecoration.counter or inputDecoration.counterText in "$keyString" field.',
        ),
        assert(
          inputDecoration?.prefix == null || inputDecoration?.prefixText == null,
          'Only one can be declared: inputDecoration.prefix or inputDecoration.prefixText in "$keyString" field.',
        ),
        assert(
          inputDecoration?.suffix == null || inputDecoration?.suffixText == null,
          'Only one can be declared: inputDecoration.suffix or inputDecoration.suffixText in "$keyString" field.',
        );
}
