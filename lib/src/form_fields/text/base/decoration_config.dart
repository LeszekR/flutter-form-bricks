import 'package:flutter/material.dart' show InputDecoration, Widget;
import 'package:flutter_form_bricks/src/form_fields/text/base/icon_button_config.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/outer_label_config.dart';

class DecorationConfig {
  final String keyString;
  final InputDecoration? inputDecoration;
  final OuterLabelConfig? outerLabelConfig;
  final IconButtonConfig? iconButtonConfig;

  DecorationConfig({
    required this.keyString,
    this.inputDecoration,
    this.outerLabelConfig,
    this.iconButtonConfig,
  })  : assert(
          (outerLabelConfig != null ? 1 : 0) +
                  (inputDecoration?.label != null ? 1 : 0) +
                  (inputDecoration?.labelText != null ? 1 : 0) <= 1,
          'Only one can be declared: outerLabel, outerLabelText, inputDecoration.label, or inputDecoration.labelText '
              'in "$keyString" field.',
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
