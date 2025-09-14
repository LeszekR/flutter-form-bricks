import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../forms/form_manager/form_manager.dart';
import '../../../visual_params/app_color.dart';
import '../../../visual_params/app_size.dart';
import '../../../visual_params/app_style.dart';
import '../../states_controller/double_widget_states_controller.dart';
import '../../components/e_label_position.dart';
import 'states_color_maker.dart';
import 'state_aware_text_field.dart';

class BasicTextInput {
  BasicTextInput._();

  static Widget basicTextInput(
      {required final String keyString,
      required final String label,
      required final ELabelPosition labelPosition,
      required final AutovalidateMode autoValidateMode,
      required final StatesColorMaker widgetColor,
      required final FormManager formManager,
      final FormFieldValidator<String>? validator,
      final dynamic initialValue,
      final bool readonly = false,
      final List<TextInputFormatter>? inputFormatters,
      final bool? withTextEditingController,
      final bool obscureText = false,
      final TextInputType? keyboardType = TextInputType.text,
      final int? maxLines,
      final bool expands = true,
      final ValueTransformer? valueTransformer,
      final double? inputWidth,
      final int? inputHeightMultiplier,
      final double? labelWidth,
      final Widget? button,
      final DoubleWidgetStatesController? statesController,
      final VoidCallback? onEditingComplete,
      final TextInputAction? textInputAction,
      final ValueChanged<String?>? onChanged,
      final ValueChanged<String?>? onSubmitted}) {
    assert(button != null ? statesController != null : true,
        'With button present statesController must be present too in: $keyString');

    double mTextWidth, mTextHeight;
    double mButtonWidth, mButtonHeight;
    double mLabelWidth, mLabelHeight;
    double mInputWidth, mInputHeight;

    final inputLabel = Text(
      label,
      textAlign: TextAlign.left,
      style: AppStyle.inputLabelStyle(),
    );

    //
    //  WITH STATES CONTROLLER - THE COLOR DEPENDS ON THE FIELD STATE
    //  ========================================================================
    if (button != null && statesController != null) {
      //
      final inputText = StateAwareTextField(
        keyString,
        colorMaker: widgetColor,
        initialValue: initialValue,
        readonly: readonly,
        autoValidateMode: autoValidateMode,
        inputFormatters: inputFormatters,
        formManager: formManager,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        expands: expands,
        valueTransformer: valueTransformer,
        onEditingComplete: onEditingComplete,
        withTextEditingController: withTextEditingController,
        width: inputWidth,
        nLines: inputHeightMultiplier,
        statesObserver: statesController,
        textInputAction: textInputAction ?? TextInputAction.none,
        onSubmitted: onSubmitted,
      );

      switch (labelPosition) {
        // EInputNamePosition = left
        case ELabelPosition.left:
          {
            mButtonWidth = AppSize.inputTextLineHeight;
            mButtonHeight = AppSize.inputTextLineHeight;

            mLabelWidth = labelWidth ?? AppSize.inputLabelWidth;
            mLabelHeight = AppSize.inputTextLineHeight;

            mTextWidth = (inputWidth ?? AppSize.inputTextWidth) - mButtonWidth;
            mTextHeight = (AppSize.inputTextLineHeight * (inputHeightMultiplier ?? 1));

            mInputWidth = mLabelWidth + mTextWidth + mButtonWidth + (2 * AppSize.paddingInputLabel);
            mInputHeight = mTextHeight;

            return makeLeftLabelInputStateAware(mInputWidth, mInputHeight, mLabelWidth, mLabelHeight, inputLabel,
                mTextWidth, inputText, mButtonWidth, mButtonHeight, button);
          }

        // EInputNamePosition = topLeft
        default:
          {
            mButtonWidth = AppSize.inputTextLineHeight;
            mButtonHeight = AppSize.inputTextLineHeight;

            mTextWidth = inputWidth ?? AppSize.inputTextWidth;
            mTextHeight = AppSize.inputTextLineHeight * (inputHeightMultiplier ?? 1);

            mLabelWidth = mTextWidth;
            mLabelHeight = AppSize.inputLabelHeight;

            mInputWidth = mTextWidth + mButtonWidth;
            mInputHeight = mLabelHeight + mTextHeight;

            return makeTopLabelInputStateAware(mInputWidth, mInputHeight, mLabelHeight, inputLabel, mTextWidth,
                mTextHeight, inputText, mButtonWidth, mButtonHeight, button);
          }
      }
    }
    //
    //  NO STATES CONTROLLER - color controlled by AppStyle.theme
    //  ========================================================================
    final inputText = StateAwareTextField(
      keyString,
      colorMaker: widgetColor,
      statesObserver: null,
      initialValue: initialValue,
      readonly: readonly,
      autoValidateMode: autoValidateMode,
      inputFormatters: inputFormatters,
      formManager: formManager,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      withTextEditingController: withTextEditingController,
      keyboardType: keyboardType,
      maxLines: maxLines,
      expands: expands,
      valueTransformer: valueTransformer,
      onEditingComplete: onEditingComplete,
      width: inputWidth,
      nLines: inputHeightMultiplier,
      onSubmitted: onSubmitted,
    );

    switch (labelPosition) {
      case ELabelPosition.left:
        {
          mTextWidth = inputWidth ?? AppSize.inputTextWidth;
          mTextHeight = AppSize.inputTextLineHeight * (inputHeightMultiplier ?? 1);

          mLabelWidth = (labelWidth ?? AppSize.inputLabelWidth);
          mLabelHeight = AppSize.inputTextLineHeight;

          mInputWidth = mLabelWidth + mTextWidth + (2 * AppSize.paddingInputLabel);
          mInputHeight = mTextHeight;

          return makeLeftLabelInputStateless(
              mInputWidth, mInputHeight, mLabelWidth, mLabelHeight, inputLabel, mTextWidth, inputText);
        }

      // EInputNamePosition = topLeft
      default:
        {
          mTextWidth = (inputWidth ?? AppSize.inputTextWidth);
          mTextHeight = AppSize.inputTextLineHeight * (inputHeightMultiplier ?? 1);

          mLabelWidth = mTextWidth;
          mLabelHeight = AppSize.inputLabelHeight;

          mInputWidth = mLabelWidth;
          mInputHeight = mLabelHeight + mTextHeight;

          return makeTopLabelInputStateless(
              mInputWidth, mInputHeight, mLabelHeight, inputLabel, mTextWidth, mTextHeight, inputText);
        }
    }
  }

  static Widget makeLeftLabelInputStateless(
      mInputWidth, mInputHeight, mLabelWidth, mLabelHeight, inputLabel, mTextWidth, inputText) {
    //
    return SizedBox(
      width: mInputWidth,
      height: mInputHeight,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        //
        // label column
        // --------------------------
        Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: EdgeInsets.only(right: AppSize.paddingInputLabel, left: AppSize.paddingInputLabel),
            child: SizedBox(
              width: mLabelWidth,
              height: mLabelHeight,
              child: Align(
                alignment: Alignment.centerRight,
                child: inputLabel,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: mLabelWidth,
            ),
          ),
        ]),
        //
        // input text column
        // --------------------------
        Container(
          width: mTextWidth,
          height: mInputHeight,
          decoration: BoxDecoration(
            border: Border(
              top: AppStyle.borderFieldSide,
              left: AppStyle.borderFieldSide,
              bottom: AppStyle.borderFieldSide,
              right: AppStyle.borderFieldSide,
            ),
          ),
          child: inputText,
        ),
      ]),
    );
  }

  static SizedBox makeLeftLabelInputStateAware(
      double mInputWidth,
      double mInputHeight,
      double? mLabelWidth,
      double mLabelHeight,
      Text inputLabel,
      double mTextWidth,
      StateAwareTextField inputText,
      double mButtonWidth,
      double mButtonHeight,
      Widget button) {
    //
    return SizedBox(
      width: mInputWidth,
      height: mInputHeight,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        //
        // label column
        // --------------------------
        Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: EdgeInsets.only(right: AppSize.paddingInputLabel, left: AppSize.paddingInputLabel),
            child: SizedBox(
              width: mLabelWidth,
              height: mLabelHeight,
              child: Align(
                alignment: Alignment.centerRight,
                child: inputLabel,
              ),
            ),
          ),
          // TODO only build this Expanded when the input is multiline
          Expanded(
            child: SizedBox(
              width: mLabelWidth,
            ),
          ),
        ]),
        //
        // inputText
        // --------------------------
        Container(
          width: mTextWidth,
          height: mInputHeight,
          decoration: BoxDecoration(
            border: Border(
              top: AppStyle.borderFieldSide,
              left: AppStyle.borderFieldSide,
              bottom: AppStyle.borderFieldSide,
            ),
          ),
          child: inputText,
        ),
        //
        // button
        // --------------------------
        SizedBox(
          width: mButtonWidth,
          height: mInputHeight,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: mButtonWidth,
              height: mButtonHeight,
              decoration: BoxDecoration(
                border: Border(
                  top: AppStyle.borderFieldSide,
                  bottom: AppStyle.borderFieldSide,
                  right: AppStyle.borderFieldSide,
                ),
              ),
              child: button,
            ),
            // TODO only build this Expanded when the input is multiline
            Expanded(
              child: Container(
                width: mButtonWidth,
                decoration: BoxDecoration(
                  border: Border(
                    left: AppStyle.borderFieldSide,
                  ),
                  color: AppColor.formWorkAreaBackground,
                ),
              ),
            )
          ]),
        )
      ]),
    );
  }

  static SizedBox makeTopLabelInputStateless(double mInputWidth, double mInputHeight, double mLabelHeight,
      Text inputLabel, double mTextWidth, double mTextHeight, StateAwareTextField inputText) {
    return SizedBox(
      width: mInputWidth,
      height: mInputHeight,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: mInputWidth,
          height: mLabelHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: inputLabel,
          ),
        ),
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  border: Border.all(width: AppSize.borderWidth, color: AppColor.borderEnabled),
                ),
                width: mTextWidth,
                height: mTextHeight,
                child: inputText,
              ),
            ]),
      ]),
    );
  }

  static SizedBox makeTopLabelInputStateAware(
      double mInputWidth,
      double mInputHeight,
      double mLabelHeight,
      Text inputLabel,
      double mTextWidth,
      double mTextHeight,
      StateAwareTextField inputText,
      double mButtonWidth,
      double mButtonHeight,
      Widget button) {
    //
    return SizedBox(
      width: mInputWidth,
      height: mInputHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: mInputWidth,
            height: mLabelHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: inputLabel,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: mTextWidth,
                height: mTextHeight,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  border: Border(
                    top: AppStyle.borderFieldSide,
                    left: AppStyle.borderFieldSide,
                    bottom: AppStyle.borderFieldSide,
                  ),
                ),
                child: inputText,
              ),
              Container(
                width: mButtonWidth,
                height: mButtonHeight,
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    top: AppStyle.borderFieldSide,
                    right: AppStyle.borderFieldSide,
                    bottom: AppStyle.borderFieldSide,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: button,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  static Widget label(final String text, final double? fontSize,
      {final FontWeight? fontWeight = FontWeight.bold, final Color? color = Colors.black}) {
    return SizedBox(
        height: fontSize,
        child: Text(text,
            style: TextStyle(height: 1, fontSize: fontSize, fontWeight: fontWeight, color: color),
            textAlign: TextAlign.left));
  }
}
