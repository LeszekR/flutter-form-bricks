import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/state_colored_icon_button.dart';

class TextFieldBorderedBoxOLD {
  // static Widget buildWithBorder({
  //   required UiParamsData uiParamsData,
  //   required InputDecorationBrick decorationBrick,
  //   required double width,
  //   required double lineHeight,
  //   required int nLines,
  //   required TextField textField,
  //   IconButtonConfig? buttonParams,
  //   StateColoredIconButton? button,
  // }) {
  //   assert((buttonParams == null) == (button == null),
  //       'buttonParams and button must be declared together or both be null');
  //
  //   if (button == null) {
  //     return _wrapTextField(uiParamsData, width, lineHeight, nLines, textField);
  //   }
  //   if (nLines == 1) {
  //     return _wrapSingleLineTextFieldWithButton(uiParamsData, width, lineHeight, textField, button);
  //   }
  //   return _wrapMultiLineTextFieldWithButton(uiParamsData, width, lineHeight, nLines, textField, button);
  // }
  //
  // static Widget _wrapTextField(
  //   UiParamsData uiParamsData,
  //   double width,
  //   double lineHeight,
  //   int nLines,
  //   TextField textField,
  // ) {
  //   return SizedBox(
  //     width: width,
  //     height: lineHeight * nLines + uiParamsData.appSize.borderWidth * 2,
  //     child: _wrapInBorder(
  //       uiParamsData,
  //       _BorderSet(true, true, true, true),
  //       textField,
  //     ),
  //   );
  // }
  //
  // static Widget _wrapSingleLineTextFieldWithButton(
  //   UiParamsData uiParamsData,
  //   double width,
  //   double lineHeight,
  //   TextField textField,
  //   StateColoredIconButton? button,
  // ) {
  //   return SizedBox(
  //     width: width,
  //     height: lineHeight + uiParamsData.appSize.borderWidth * 2,
  //     child: _wrapInBorder(
  //       uiParamsData,
  //       _BorderSet(true, true, true, true),
  //       Row(children: [textField, button!]),
  //     ),
  //   );
  // }
  //
  // static Widget _wrapMultiLineTextFieldWithButton(
  //   UiParamsData uiParamsData,
  //   double width,
  //   double lineHeight,
  //   int nLines,
  //   TextField textField,
  //   StateColoredIconButton? button,
  // ) {
  //   return SizedBox(
  //     width: width,
  //     height: lineHeight * nLines + uiParamsData.appSize.borderWidth * 2,
  //     child: Row(
  //       children: [
  //         _wrapInBorder(
  //           uiParamsData,
  //           _BorderSet(true, true, true, false),
  //           textField,
  //         ),
  //         Column(
  //           children: [
  //             _wrapInBorder(
  //               uiParamsData,
  //               _BorderSet(true, false, true, true),
  //               button,
  //             ),
  //             Expanded(
  //               child: _wrapInBorder(
  //                 uiParamsData,
  //                 _BorderSet(false, true, false, false),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // static Widget _wrapInBorder(UiParamsData uiParamsData, _BorderSet borderSet, [Widget? child]) {
  //   var borderWidth = uiParamsData.appSize.borderWidth;
  //   var borderFieldSide = uiParamsData.appStyle.borderFieldSide;
  //   return DecoratedBox(
  //     decoration: BoxDecoration(
  //       border: Border(
  //         top: borderSet.top ? borderFieldSide : BorderSide.none,
  //         left: borderSet.start ? borderFieldSide : BorderSide.none,
  //         bottom: borderSet.bottom ? borderFieldSide : BorderSide.none,
  //         right: borderSet.end ? borderFieldSide : BorderSide.none,
  //       ),
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.only(
  //         top: borderSet.top ? borderWidth : 0,
  //         left: borderSet.start ? borderWidth : 0,
  //         bottom: borderSet.bottom ? borderWidth : 0,
  //         right: borderSet.end ? borderWidth : 0,
  //       ),
  //       child: child,
  //     ),
  //   );
  // }

  // ==============================================================
  static build({
    required UiParamsData uiParamsData,
    required DecorationConfig decorationBrick,
    required double width,
    required double lineHeight,
    required int nLines,
    required TextField textField,
    IconButtonConfig? buttonConfig,
    StateColoredIconButton? button,
  }) {
    InputBorder? border = decorationBrick.inputDecoration?.border;

    Widget body, textFieldWithButton;

    textFieldWithButton = (button == null)
        ? textField
        : _buildTextFieldWithButton(
            decorationBrick,
            nLines,
            textField,
            button,
          );

    if (decorationBrick.outerLabelConfig?.outerLabel == null &&
        decorationBrick.outerLabelConfig?.outerLabelText == null) {
      body = textFieldWithButton;
    } else {
      Widget label = _makeOuterLabel(decorationBrick);

      _Body bodyWithOuterLabel = _buildBodyWithOuterLabel(
        decorationBrick,
        width,
        lineHeight,
        nLines,
        textFieldWithButton,
        label,
      );
      body = bodyWithOuterLabel.body;
      width = bodyWithOuterLabel.width;
      lineHeight = bodyWithOuterLabel.height;
    }

    return SizedBox(width: width, height: nLines * lineHeight, child: body);
  }

  static Widget _buildTextFieldWithButton(
    DecorationConfig decorationBrick,
    int nLines,
    TextField textField,
    button,
  ) {
    CrossAxisAlignment crossAxisAlignment = switch (decorationBrick.iconButtonConfig!.buttonAlign) {
      ButtonAlign.top => CrossAxisAlignment.start,
      ButtonAlign.stretch => CrossAxisAlignment.stretch,
      ButtonAlign.bottom => CrossAxisAlignment.end,
    };

    switch (decorationBrick.iconButtonConfig!.buttonSide) {
      case ButtonSide.right:
        return Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Expanded(child: textField),
            button,
          ],
        );

      case ButtonSide.left:
        return Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            button,
            Expanded(child: textField),
          ],
        );
    }
  }

  static Widget _makeOuterLabel(DecorationConfig decorationBrick) {
    if (decorationBrick.outerLabelConfig?.outerLabel != null) {
      return decorationBrick.outerLabelConfig!.outerLabel!;
    }
    return Text(decorationBrick.outerLabelConfig!.outerLabelText!);
  }

  static _Body _buildBodyWithOuterLabel(
    DecorationConfig decorationBrick,
    double width,
    double lineHeight,
    int nLines,
    Widget textField,
    Widget label,
  ) {
    Widget body;
    double bodyWidth, bodyHeight;
    switch (decorationBrick.outerLabelConfig!.outerLabelSide) {
      case OuterLabelSide.top:
        body = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [label, textField]);
        bodyWidth = width;
        bodyHeight = lineHeight * nLines;
      case OuterLabelSide.bottom:
        body = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [textField, label]);
        bodyWidth = width;
        bodyHeight = lineHeight * nLines;
      case OuterLabelSide.left:
        body = Row(crossAxisAlignment: CrossAxisAlignment.start, children: [label, textField]);
        bodyWidth = width;
        bodyHeight = lineHeight * nLines;
      case OuterLabelSide.right:
        body = Row(crossAxisAlignment: CrossAxisAlignment.start, children: [textField, label]);
        bodyWidth = width;
        bodyHeight = lineHeight * nLines;
    }
    return _Body(body, bodyWidth, bodyHeight);
  }
}

class _Body {
  final Widget body;
  final double width;
  final double height;

  const _Body(this.body, this.width, this.height);
}

class _BorderSet {
  final bool top;
  final bool start;
  final bool bottom;
  final bool end;

  const _BorderSet(this.top, this.start, this.bottom, this.end);
}
