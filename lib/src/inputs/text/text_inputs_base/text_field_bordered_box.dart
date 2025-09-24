import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/inputs/text/text_inputs_base/state_colored_icon_button.dart';

import '../../../visual_params/bricks_theme_data.dart';

class TextFieldBorderedBox {
  static Widget build({
    required BricksThemeData theme,
    required double width,
    required double lineHeight,
    required int nLines,
    required TextField textField,
    StateColoredIconButton? button,
  }) {
    if (button == null) {
      return _wrapTextField(theme, width, lineHeight, nLines, textField);
    }
    if (nLines == 1) {
      return _wrapSingleLineTextFieldWithButton(theme, width, lineHeight, textField, button);
    }
    return _wrapMultiLineTextFieldWithButton(theme, width, lineHeight, nLines, textField, button);
  }

  static Widget _wrapTextField(
    BricksThemeData theme,
    double width,
    double lineHeight,
    int nLines,
    TextField textField,
  ) {
    return SizedBox(
      width: width,
      height: lineHeight * nLines,
      child: _wrapInBorder(
        theme,
        _BorderSet(true, true, true, true),
        textField,
      ),
    );
  }

  static Widget _wrapSingleLineTextFieldWithButton(
    BricksThemeData theme,
    double width,
    double lineHeight,
    TextField textField,
    StateColoredIconButton? button,
  ) {
    return SizedBox(
      width: width,
      height: lineHeight,
      child: _wrapInBorder(
        theme,
        _BorderSet(true, true, true, true),
        Row(children: [textField, button!]),
      ),
    );
  }

  static Widget _wrapMultiLineTextFieldWithButton(
    BricksThemeData theme,
    double width,
    double lineHeight,
    int nLines,
    TextField textField,
    StateColoredIconButton? button,
  ) {
    return SizedBox(
      width: width,
      height: lineHeight * nLines,
      child: Row(
        children: [
          _wrapInBorder(
            theme,
            _BorderSet(true, true, true, false),
            textField,
          ),
          Column(
            children: [
              _wrapInBorder(
                theme,
                _BorderSet(true, false, true, true),
                button,
              ),
              Expanded(
                child: _wrapInBorder(
                  theme,
                  _BorderSet(false, true, false, false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _wrapInBorder(BricksThemeData theme, _BorderSet borderSet, [Widget? child]) {
    var borderWidth = theme.sizes.borderWidth;
    var borderFieldSide = theme.styles.borderFieldSide;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: borderSet.top ? borderFieldSide : BorderSide.none,
          left: borderSet.left ? borderFieldSide : BorderSide.none,
          bottom: borderSet.bottom ? borderFieldSide : BorderSide.none,
          right: borderSet.right ? borderFieldSide : BorderSide.none,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: borderSet.top ? borderWidth : 0,
          left: borderSet.left ? borderWidth : 0,
          bottom: borderSet.bottom ? borderWidth : 0,
          right: borderSet.right ? borderWidth : 0,
        ),
        child: child,
      ),
    );
  }
}

class _BorderSet {
  final bool top;
  final bool left;
  final bool bottom;
  final bool right;

  const _BorderSet(this.top, this.left, this.bottom, this.right);
}
