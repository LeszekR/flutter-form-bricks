import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/input_decoration_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/state_colored_icon_button.dart';

class TextFieldBorderedBox {
  static Widget build({
    required UiParamsData uiParamsData,
    required InputDecorationBrick decorationBrick,
    required double width,
    required double lineHeight,
    required int nLines,
    required TextField textField,
    IconButtonConfig? buttonParams,
    StateColoredIconButton? button,
  }) {
    assert((buttonParams == null) == (button == null),
        'buttonParams and button must be declared together or both be null');

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
      height: lineHeight * nLines + uiParamsData.appSize.borderWidth * 2,
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
      height: lineHeight + uiParamsData.appSize.borderWidth * 2,
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
      height: lineHeight * nLines + uiParamsData.appSize.borderWidth * 2,
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
    var borderWidth = uiParamsData.appSize.borderWidth;
    var borderFieldSide = uiParamsData.appStyle.borderFieldSide;
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

  // ==============================================================
  static _buildNew({
    required UiParamsData uiParamsData,
    required InputDecorationBrick decorationBrick,
    required double width,
    required double lineHeight,
    required int nLines,
    required TextField textField,
    IconButtonConfig? buttonConfig,
    StateColoredIconButton? button,
  }) {
    InputBorder? border = decorationBrick.inputDecoration?.border;

    Widget body = (button == null)
        ? textField
        : _buildTextFieldWithButton(
            decorationBrick: decorationBrick,
            nLines: nLines,
            textField: textField,
            button: button,
          );

    if (decorationBrick.outerLabel == null && decorationBrick.outerLabelText == null) {
      return body;
    } else {
      return _buildBodyWit
    }
  }

  static Widget _buildTextFieldWithButton({
    required InputDecorationBrick decorationBrick,
    required int nLines,
    required TextField textField,
    required button,
  }) {
    switch (decorationBrick.buttonPosition) {
      case null:
      case ButtonPosition.rightTop:
        if (nLines == 1) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: textField),
              button,
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: textField),
              Column(
                children: [
                  button,
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          );
        }

      case ButtonPosition.leftTop:
        if (nLines == 1) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              button,
              Expanded(child: textField),
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  button,
                  const Expanded(child: SizedBox()),
                ],
              ),
              Expanded(child: textField),
            ],
          );
        }

      case ButtonPosition.leftFullHeight:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            button,
            Expanded(child: textField),
          ],
        );

      case ButtonPosition.rightFullHeight:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: textField),
            button,
          ],
        );
    }
  }

  static Widget _buildBodyWithOuterLabel({
    required InputDecorationBrick decorationBrick,
  required double width,
  required double lineHeight,
  required int nLines,
  required TextField textField,
  }) {
    switch (decorationBrick.outerLabelPosition) {

  }


}

class _BorderSet {
  final bool top;
  final bool start;
  final bool bottom;
  final bool end;

  const _BorderSet(this.top, this.start, this.bottom, this.end);
}
