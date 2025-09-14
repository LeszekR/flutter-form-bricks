import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/inputs/text/text_inputs_base/state_colored_icon_button.dart';
import 'package:flutter_form_bricks/src/visual_params/app_size/app_size.dart';

import '../../../visual_params/app_style/app_style.dart';
import '../../../visual_params/brick_theme.dart';

class TextFieldBorderedBox {
  static Widget build({
    required BuildContext context,
    required double width,
    required double lineHeight,
    required int nLines,
    required TextField textField,
    StateColoredIconButton? button,
  }) {
    if (button == null) {
      return _wrapTextField(context, width, lineHeight, nLines, textField);
    }
    if (nLines == 1) {
      return _wrapSingleLineTextFieldWithButton(context, width, lineHeight, textField, button);
    }
    return _wrapMultiLineTextFieldWithButton(context, width, lineHeight, nLines, textField, button);
  }

  static Widget _wrapTextField(
    BuildContext context,
    double width,
    double lineHeight,
    int nLines,
    TextField textField,
  ) {
    return SizedBox(
      width: width,
      height: lineHeight * nLines,
      child: _wrapInBorder(
        context,
        _BorderSet(true, true, true, true),
        textField,
      ),
    );
  }

  static Widget _wrapSingleLineTextFieldWithButton(
    BuildContext context,
    double width,
    double lineHeight,
    TextField textField,
    StateColoredIconButton? button,
  ) {
    return SizedBox(
      width: width,
      height: lineHeight,
      child: _wrapInBorder(
        context,
        _BorderSet(true, true, true, true),
        Row(children: [textField, button!]),
      ),
    );
  }

  static Widget _wrapMultiLineTextFieldWithButton(
    BuildContext context,
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
            context,
            _BorderSet(true, true, true, false),
            textField,
          ),
          Column(
            children: [
              _wrapInBorder(
                context,
                _BorderSet(true, false, true, true),
                button,
              ),
              Expanded(
                child: _wrapInBorder(
                  context,
                  _BorderSet(false, true, false, false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _wrapInBorder(BuildContext context, _BorderSet borderSet, [Widget? child]) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: borderSet.top ?  BrickTheme.of(context).styles.borderFieldSide : BorderSide.none,
          left: borderSet.left ?  BrickTheme.of(context).styles.borderFieldSide : BorderSide.none,
          bottom: borderSet.bottom ?  BrickTheme.of(context).styles.borderFieldSide : BorderSide.none,
          right: borderSet.right ?  BrickTheme.of(context).styles.borderFieldSide : BorderSide.none,
        ),
      ),
      child: child,
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
