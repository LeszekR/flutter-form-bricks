import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/inputs/labelled_box/label_position.dart';
import 'package:flutter_form_bricks/src/inputs/states_controller/double_widget_states_controller.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../../ui_params/ui_params.dart';
import '../../../forms/form_manager/form_manager.dart';
import 'text_field_colored.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';

class BasicTextInput {
  BasicTextInput._();

  static Widget basicTextInput(
      {required BuildContext context,
      required String keyString,
      required String label,
      required LabelPosition labelPosition,
      required AutovalidateMode autovalidateMode,
      dynamic initialValue,
      bool readonly = false,
      List<TextInputFormatter>? inputFormatters,
      required FormManager formManager,
      FormFieldValidator<String>? validator,
      bool? withTextEditingController,
      ValueChanged<String?>? onChanged,
      List<String>? linkedFields,
      bool obscureText = false,
      TextInputType? keyboardType = TextInputType.text,
      int? maxLines,
      bool expands = true,
      ValueTransformer? valueTransformer,
      double? inputWidth,
      int? inputHeightMultiplier,
      double? labelWidth,
      Widget? button,
      DoubleWidgetStatesController? statesController,
      VoidCallback? onEditingComplete,
      TextInputAction? textInputAction,
      ValueChanged<String?>? onSubmitted}) {
    assert(button != null ? statesController != null : true,
        'With button present statesController must be present too in: $keyString');

    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;
    final appStyle = uiParams.appStyle;

    labelWidth ??= appSize.inputLabelWidth;
    inputWidth ??= appSize.textFieldWidth;

    double mTextWidth, mTextHeight;
    double mButtonWidth, mButtonHeight;
    double mLabelWidth, mLabelHeight;
    double mInputWidth, mInputHeight;

    final inputLabel = Text(
      label,
      textAlign: TextAlign.left,
      style: appStyle.inputLabelStyle(),
    );

    //
    //  WITH STATES CONTROLLER - THE COLOR DEPENDS ON THE FIELD STATE
    //  ========================================================================
    if (button != null && statesController != null) {
      //
      final inputText = TextFieldColored(
        keyString,
        initialValue: initialValue,
        readonly: readonly,
        autovalidateMode: autovalidateMode,
        inputFormatters: inputFormatters,
        formManager: formManager,
        validator: validator,
        onChanged: onChanged,
        linkedFields: linkedFields,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        expands: expands,
        valueTransformer: valueTransformer,
        onEditingComplete: onEditingComplete,
        withTextEditingController: withTextEditingController,
        textWidth: inputWidth,
        inputHeightMultiplier: inputHeightMultiplier,
        notifierDoubleStatesController: statesController,
        textInputAction: textInputAction ?? TextInputAction.none,
        onSubmitted: onSubmitted,
      );

      switch (labelPosition) {
        // EInputNamePosition = left
        case LabelPosition.left:
          {
            mButtonWidth = appSize.inputTextLineHeight;
            mButtonHeight = appSize.inputTextLineHeight;

            mLabelWidth = labelWidth;
            mLabelHeight = appSize.inputTextLineHeight;

            mTextWidth = inputWidth - mButtonWidth;
            mTextHeight = (appSize.inputTextLineHeight * (inputHeightMultiplier ?? 1));

            mInputWidth = mLabelWidth + mTextWidth + mButtonWidth + (2 * appSize.paddingInputLabel);
            mInputHeight = mTextHeight;

            return makeLeftLabelInputStateAware(
              context: context,
              mInputWidth: mInputWidth,
              mInputHeight: mInputHeight,
              mLabelWidth: mLabelWidth,
              mLabelHeight: mLabelHeight,
              inputLabel: inputLabel,
              mTextWidth: mTextWidth,
              inputText: inputText,
              mButtonWidth: mButtonWidth,
              mButtonHeight: mButtonHeight,
              button: button,
            );
          }

        // EInputNamePosition = topLeft
        default:
          {
            mButtonWidth = appSize.inputTextLineHeight;
            mButtonHeight = appSize.inputTextLineHeight;

            mTextWidth = inputWidth;
            mTextHeight = appSize.inputTextLineHeight * (inputHeightMultiplier ?? 1);

            mLabelWidth = mTextWidth;
            mLabelHeight = appSize.inputLabelHeight;

            mInputWidth = mTextWidth + mButtonWidth;
            mInputHeight = mLabelHeight + mTextHeight;

            return makeTopLabelInputStateAware(
              context: context,
              mInputWidth: mInputWidth,
              mInputHeight: mInputHeight,
              mLabelHeight: mLabelHeight,
              inputLabel: inputLabel,
              mTextWidth: mTextWidth,
              mTextHeight: mTextHeight,
              inputText: inputText,
              mButtonWidth: mButtonWidth,
              mButtonHeight: mButtonHeight,
              button: button,
            );
          }
      }
    }
    //
    //  NO STATES CONTROLLER - color controlled by appStyle.theme
    //  ========================================================================
    final inputText = TextFieldColored(
      keyString,
      notifierDoubleStatesController: null,
      initialValue: initialValue,
      readonly: readonly,
      autovalidateMode: autovalidateMode,
      inputFormatters: inputFormatters,
      formManager: formManager,
      validator: validator,
      onChanged: onChanged,
      linkedFields: linkedFields,
      obscureText: obscureText,
      withTextEditingController: withTextEditingController,
      keyboardType: keyboardType,
      maxLines: maxLines,
      expands: expands,
      valueTransformer: valueTransformer,
      onEditingComplete: onEditingComplete,
      textWidth: inputWidth,
      inputHeightMultiplier: inputHeightMultiplier,
      onSubmitted: onSubmitted,
    );

    switch (labelPosition) {
      case LabelPosition.left:
        {
          mTextWidth = inputWidth;
          mTextHeight = appSize.inputTextLineHeight * (inputHeightMultiplier ?? 1);

          mLabelWidth = labelWidth;
          mLabelHeight = appSize.inputTextLineHeight;

          mInputWidth = mLabelWidth + mTextWidth + (2 * appSize.paddingInputLabel);
          mInputHeight = mTextHeight;

          return makeLeftLabelInputStateless(
            context: context,
            mInputWidth: mInputWidth,
            mInputHeight: mInputHeight,
            mLabelWidth: mLabelWidth,
            mLabelHeight: mLabelHeight,
            inputLabel: inputLabel,
            mTextWidth: mTextWidth,
            inputText: inputText,
          );
        }

      // EInputNamePosition = topLeft
      default:
        {
          mTextWidth = inputWidth;
          mTextHeight = appSize.inputTextLineHeight * (inputHeightMultiplier ?? 1);

          mLabelWidth = mTextWidth;
          mLabelHeight = appSize.inputLabelHeight;

          mInputWidth = mLabelWidth;
          mInputHeight = mLabelHeight + mTextHeight;

          return makeTopLabelInputStateless(
            context: context,
            mInputWidth: mInputWidth,
            mInputHeight: mInputHeight,
            mLabelHeight: mLabelHeight,
            inputLabel: inputLabel,
            mTextWidth: mTextWidth,
            mTextHeight: mTextHeight,
            inputText: inputText,
          );
        }
    }
  }

  static Widget makeLeftLabelInputStateless({
    required BuildContext context,
    required double mInputWidth,
    required double mInputHeight,
    required double mLabelWidth,
    required double mLabelHeight,
    required double mTextWidth,
    required Widget inputLabel,
    required TextFieldColored inputText,
  }) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;
    final appStyle = uiParams.appStyle;

    return SizedBox(
      width: mInputWidth,
      height: mInputHeight,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        //
        // label column
        // --------------------------
        Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: EdgeInsets.only(right: appSize.paddingInputLabel, left: appSize.paddingInputLabel),
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
          decoration: BoxDecoration(
            border: Border(
              top: appStyle.borderFieldSide,
              left: appStyle.borderFieldSide,
              bottom: appStyle.borderFieldSide,
              right: appStyle.borderFieldSide,
            ),
          ),
          child: inputText,
        ),
      ]),
    );
  }

  static SizedBox makeLeftLabelInputStateAware({
    required BuildContext context,
    required double mInputWidth,
    required double mInputHeight,
    required double mLabelHeight,
    required Text inputLabel,
    required double mTextWidth,
    required TextFieldColored inputText,
    required double mButtonWidth,
    required double mButtonHeight,
    required Widget button,
    double? mLabelWidth,
  }) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;
    final appStyle = uiParams.appStyle;
    final appColor = uiParams.appColor;

    return SizedBox(
      width: mInputWidth,
      height: mInputHeight,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        //
        // label column
        // --------------------------
        Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: EdgeInsets.only(right: appSize.paddingInputLabel, left: appSize.paddingInputLabel),
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
        // inputText
        // --------------------------
        Container(
          width: mTextWidth,
          height: mInputHeight,
          decoration: BoxDecoration(
            border: Border(
              top: appStyle.borderFieldSide,
              left: appStyle.borderFieldSide,
              bottom: appStyle.borderFieldSide,
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
                  top: appStyle.borderFieldSide,
                  bottom: appStyle.borderFieldSide,
                  right: appStyle.borderFieldSide,
                ),
              ),
              child: button,
            ),
            Expanded(
              child: Container(
                width: mButtonWidth,
                decoration: BoxDecoration(
                  border: Border(
                    left: appStyle.borderFieldSide,
                  ),
                  color: appColor.formWorkAreaBackground,
                ),
              ),
            )
          ]),
        )
      ]),
    );
  }

  static SizedBox makeTopLabelInputStateless({
    required BuildContext context,
    required double mInputWidth,
    required double mInputHeight,
    required double mLabelHeight,
    required Text inputLabel,
    required double mTextWidth,
    required double mTextHeight,
    required TextFieldColored inputText,
  }) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;
    final appColor = uiParams.appColor;

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
                  border: Border.all(width: appSize.borderWidth, color: appColor.borderEnabled),
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
      {required BuildContext context,
      required double mInputWidth,
      required double mInputHeight,
      required double mLabelHeight,
      required Text inputLabel,
      required double mTextWidth,
      required double mTextHeight,
      required TextFieldColored inputText,
      required double mButtonWidth,
      required double mButtonHeight,
      required Widget button}) {
    final uiParams = UiParams.of(context);
    final appStyle = uiParams.appStyle;

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
                    top: appStyle.borderFieldSide,
                    left: appStyle.borderFieldSide,
                    bottom: appStyle.borderFieldSide,
                  ),
                ),
                child: inputText,
              ),
              Container(
                width: mButtonWidth,
                height: mButtonHeight,
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                decoration: (BoxDecoration(
                    border: Border(
                  top: appStyle.borderFieldSide,
                  right: appStyle.borderFieldSide,
                  bottom: appStyle.borderFieldSide,
                ))),
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

  static Widget label(String text,double? fontSize,
      {final FontWeight? fontWeight = FontWeight.bold,Color? color = Colors.black}) {
    return SizedBox(
        height: fontSize,
        child: Text(text,
            style: TextStyle(height: 1, fontSize: fontSize, fontWeight: fontWeight, color: color),
            textAlign: TextAlign.left));
  }
}
