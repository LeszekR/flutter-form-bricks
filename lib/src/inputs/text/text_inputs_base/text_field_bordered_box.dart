import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/inputs/text/text_inputs_base/state_colored_icon_button.dart';

import '../../../ui_params/ui_params_data.dart';

class TextFieldBorderedBox {
  static Widget build({
    required UiParamsData uiParamsData,
    required double width,
    required double lineHeight,
    required int nLines,
    required TextField textField,
    StateColoredIconButton? button,
  }) {
    if (button == null) {
      return _wrapTextField(uiParamsData, width, lineHeight, nLines, textField);
    }
    if (nLines == 1) {
      return _wrapSingleLineTextFieldWithButton(uiParamsData, width, lineHeight, textField, button);
    }
    return _wrapMultiLineTextFieldWithButton(uiParamsData, width, lineHeight, nLines, textField, button);
  }

  static Widget _wrapTextField(
    UiParamsData uiParamsData,
    double width,
    double lineHeight,
    int nLines,
    TextField textField,
  ) {
    return SizedBox(
      width: width,
      height: lineHeight * nLines + uiParamsData.size.borderWidth * 2,
      child: _wrapInBorder(
        uiParamsData,
        _BorderSet(true, true, true, true),
        textField,
      ),
    );
  }

  static Widget _wrapSingleLineTextFieldWithButton(
    UiParamsData uiParamsData,
    double width,
    double lineHeight,
    TextField textField,
    StateColoredIconButton? button,
  ) {
    return SizedBox(
      width: width,
      height: lineHeight + uiParamsData.size.borderWidth * 2,
      child: _wrapInBorder(
        uiParamsData,
        _BorderSet(true, true, true, true),
        Row(children: [textField, button!]),
      ),
    );
  }

  static Widget _wrapMultiLineTextFieldWithButton(
    UiParamsData uiParamsData,
    double width,
    double lineHeight,
    int nLines,
    TextField textField,
    StateColoredIconButton? button,
  ) {
    return SizedBox(
      width: width,
      height: lineHeight * nLines + uiParamsData.size.borderWidth * 2,
      child: Row(
        children: [
          _wrapInBorder(
            uiParamsData,
            _BorderSet(true, true, true, false),
            textField,
          ),
          Column(
            children: [
              _wrapInBorder(
                uiParamsData,
                _BorderSet(true, false, true, true),
                button,
              ),
              Expanded(
                child: _wrapInBorder(
                  uiParamsData,
                  _BorderSet(false, true, false, false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _wrapInBorder(UiParamsData uiParamsData, _BorderSet borderSet, [Widget? child]) {
    var borderWidth = uiParamsData.size.borderWidth;
    var borderFieldSide = uiParamsData.style.borderFieldSide;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: borderSet.top ? borderFieldSide : BorderSide.none,
          left: borderSet.start ? borderFieldSide : BorderSide.none,
          bottom: borderSet.bottom ? borderFieldSide : BorderSide.none,
          right: borderSet.end ? borderFieldSide : BorderSide.none,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: borderSet.top ? borderWidth : 0,
          left: borderSet.start ? borderWidth : 0,
          bottom: borderSet.bottom ? borderWidth : 0,
          right: borderSet.end ? borderWidth : 0,
        ),
        child: child,
      ),
    );
  }
}

class _BorderSet {
  final bool top;
  final bool start;
  final bool bottom;
  final bool end;

  const _BorderSet(this.top, this.start, this.bottom, this.end);
}
