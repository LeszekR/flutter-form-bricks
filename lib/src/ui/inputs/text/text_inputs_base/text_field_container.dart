import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui/inputs/text/text_inputs_base/state_aware_icon_button.dart';
import 'package:flutter_form_bricks/src/ui/visual_params/app_size.dart';

import '../../../visual_params/app_style.dart';

class TextFieldBorderedBox {
  static Widget build({
    required double width,
    required double lineHeight,
    required int nLines,
    required TextField textField,
    StateAwareIconButton? button,
  }) {
    if (button == null) {
      return _wrapTextField(width, lineHeight, nLines, textField);
    }
    if (nLines == 1) {
      return _wrapSingleLineTextFieldWithButton(width, lineHeight, textField, button);
    }
    return _wrapMultiLineTextFieldWithButton(width, lineHeight, nLines, textField, button);
  }

  static Widget _wrapTextField(
    double width,
    double lineHeight,
    int nLines,
    TextField textField,
  ) {
    return SizedBox(
      width: width,
      height: lineHeight * nLines,
      child: _wrapInBorder(_BorderSet(true, true, true, true), textField),
    );
  }

  static Widget _wrapSingleLineTextFieldWithButton(
    double width,
    double lineHeight,
    TextField textField,
    StateAwareIconButton? button,
  ) {
    return SizedBox(
      width: width,
      height: lineHeight,
      child: _wrapInBorder(
        _BorderSet(true, true, true, true),
        Row(children: [textField, button!]),
      ),
    );
  }

  static Widget _wrapMultiLineTextFieldWithButton(
    double width,
    double lineHeight,
    int nLines,
    TextField textField,
    StateAwareIconButton? button,
  ) {
    return SizedBox(
      width: width,
      height: lineHeight * nLines,
      child: Row(
        children: [
          _wrapInBorder(
            _BorderSet(true, true, true, false),
            textField,
          ),
          Column(
            children: [
              _wrapInBorder(
                _BorderSet(true, false, true, true),
                button,
              ),
              Expanded(
                child: _wrapInBorder(_BorderSet(false, true, false, false)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _wrapInBorder(_BorderSet borderSet, [Widget? child]) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: borderSet.top ? BorderSide.none : AppStyle.borderFieldSide,
          left: borderSet.left ? BorderSide.none : AppStyle.borderFieldSide,
          bottom: borderSet.bottom ? BorderSide.none : AppStyle.borderFieldSide,
          right: borderSet.right ? BorderSide.none : AppStyle.borderFieldSide,
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
