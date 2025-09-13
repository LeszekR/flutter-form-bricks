import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/ui/inputs/labelled_box/e_label_position.dart';

import '../../visual_params/app_size.dart';
import '../../visual_params/app_style.dart';


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
//  - TextFieldStateAware
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
  final ELabelPosition labelPosition;
  final ValueWidgetBuilder<Set<WidgetState>> widgetBuilder;
  final WidgetStatesController widgetStatesController;
  int? inputHeightMultiplier;
  double? labelWidth;

  LabelledContainer({
    required this.label,
    required this.labelPosition,
    required this.widgetBuilder,
    required this.widgetStatesController,
    final int? inputHeightMultiplier,
    final double? labelWidth,
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

  Widget buildLabelledContainer() {
    double mTextWidth, mTextHeight;
    double mButtonWidth, mButtonHeight;
    double mLabelWidth, mLabelHeight;
    double mInputWidth, mInputHeight;

    final inputLabel = Text(
      label,
      textAlign: TextAlign.left,
      style: AppStyle.inputLabelStyle(),
    );

    switch (labelPosition) {
      case ELabelPosition.left:
        {
          mButtonWidth = AppSize.inputTextHeight;
          mButtonHeight = AppSize.inputTextHeight;

          mLabelWidth = labelWidth ?? AppSize.inputLabelWidth;
          mLabelHeight = AppSize.inputTextHeight;

          mTextWidth = (inputWidth ?? AppSize.inputTextWidth) - mButtonWidth;
          mTextHeight = (AppSize.inputTextHeight * (inputHeightMultiplier ?? 1));

          mInputWidth = mLabelWidth + mTextWidth + mButtonWidth + (2 * AppSize.paddingInputLabel);
          mInputHeight = mTextHeight;

          return makeLeftLabelInputStateAware(mInputWidth, mInputHeight, mLabelWidth, mLabelHeight, inputLabel,
              mTextWidth, inputText, mButtonWidth, mButtonHeight, button);
        }

      default: // EInputNamePosition = topLeft
        {
          mButtonWidth = AppSize.inputTextHeight;
          mButtonHeight = AppSize.inputTextHeight;

          mTextWidth = inputWidth ?? AppSize.inputTextWidth;
          mTextHeight = AppSize.inputTextHeight * (inputHeightMultiplier ?? 1);

          mLabelWidth = mTextWidth;
          mLabelHeight = AppSize.inputLabelHeight;

          mInputWidth = mTextWidth + mButtonWidth;
          mInputHeight = mLabelHeight + mTextHeight;

          return makeTopLabelInputStateAware(mInputWidth, mInputHeight, mLabelHeight, inputLabel, mTextWidth,
              mTextHeight, inputText, mButtonWidth, mButtonHeight, button);
        }
    }
  }

}
}
