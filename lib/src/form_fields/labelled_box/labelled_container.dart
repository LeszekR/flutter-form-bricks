import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/labelled_box/label_position.dart';



// LabelledBox
//   - label position: top, left, right
//   - label width? - when on the side
//   - child
//
// StateAwareContainer
//  - WidgetStatesController - single or double depending on button absence/presence
//  - ValueListenableBuilder
//  - SizedBox: width, height
//  - button? -> Row
//  - TextfieldContentAware
//  - button? -> IconButtonStateAware
//
// TextFieldWithButton
//   - SizedBox -> Row
//   - TextFieldColored
//   - IconButtonStateAware
//
// TextFieldColored
//   - width
//   - nLines
//   - WidgetStatesController
//   - FormManager
//   - formatter
//   - validator
//   - all other text field params
//
// IconButtonStateAware
//   - MouseRegion
//   - GestureDetector
//   - Focus
//   - WidgetStatesController

class LabelledContainer extends StatelessWidget {
  final String label;
  final LabelPosition labelPosition;
  final ValueWidgetBuilder<Set<WidgetState>> widgetBuilder;
  final WidgetStatesController widgetStatesController;
  final double labelWidth;
  final int inputHeightMultiplier;

  LabelledContainer({
    required this.label,
    required this.labelPosition,
    required this.widgetBuilder,
    required this.widgetStatesController,
    required this.labelWidth,
    this.inputHeightMultiplier = 1,
  });

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  ValueListenableBuilder<Set<WidgetState>> buildContent() {
    return ValueListenableBuilder(
      valueListenable: widgetStatesController,
      builder: (context, states, _) {
        return widgetBuilder(context, states, null);
      });
  }

// TODO refactor to final version - use InputDecoration where possible
  // Widget buildLabelledContainer(BuildContext context) {
  //   final uiParams = UiParams.of(context);
  //   final appStyle = uiParams.appStyle;
  //   final appSize = uiParams.appSize;
  //
  //   double mTextWidth, mTextHeight;
  //   double mButtonWidth, mButtonHeight;
  //   double mLabelWidth, mLabelHeight;
  //   double mInputWidth, mInputHeight;
  //
  //   final inputLabel = Text(
  //     label,
  //     textAlign: TextAlign.left,
  //     style: appStyle.inputLabelStyle(),
  //   );
  //
    // switch (labelPosition) {
    //   case LabelPosition.left:
    //     {
    //       mButtonWidth = appSize.inputTextLineHeight;
    //       mButtonHeight = appSize.inputTextLineHeight;
    //
    //       mLabelWidth = labelWidth ?? appSize.inputLabelWidth;
    //       mLabelHeight = appSize.inputTextLineHeight;
    //
    //       mTextWidth = (inputWidth ?? appSize.textFieldWidth) - mButtonWidth;
    //       mTextHeight = (appSize.inputTextLineHeight * (inputHeightMultiplier ?? 1));
    //
    //       mInputWidth = mLabelWidth + mTextWidth + mButtonWidth + (2 * appSize.paddingInputLabel);
    //       mInputHeight = mTextHeight;
    //
    //       return makeLeftLabelInputStateAware(mInputWidth, mInputHeight, mLabelWidth, mLabelHeight, inputLabel,
    //           mTextWidth, inputText, mButtonWidth, mButtonHeight, button);
    //     }
    //
    //   default: // EInputNamePosition = topLeft
    //     {
    //       mButtonWidth = appSize.inputTextLineHeight;
    //       mButtonHeight = appSize.inputTextLineHeight;
    //
    //       mTextWidth = inputWidth ?? appSize.textFieldWidth;
    //       mTextHeight = appSize.inputTextLineHeight * (inputHeightMultiplier ?? 1);
    //
    //       mLabelWidth = mTextWidth;
    //       mLabelHeight = appSize.inputLabelHeight;
    //
    //       mInputWidth = mTextWidth + mButtonWidth;
    //       mInputHeight = mLabelHeight + mTextHeight;
    //
    //       return makeTopLabelInputStateAware(mInputWidth, mInputHeight, mLabelHeight, inputLabel, mTextWidth,
    //           mTextHeight, inputText, mButtonWidth, mButtonHeight, button);
    //     }
    // }
  // }
}
