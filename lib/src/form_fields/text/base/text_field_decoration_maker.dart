import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/components/decoration/outline_sides_input_border.dart';
import 'package:flutter_form_bricks/src/form_fields/components/decoration/underline_top_rounded_input_border.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/error_position.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_button_config.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params_data.dart';

class TextFieldDecorationMaker {
  static InputDecoration makeInputDecoration({
    required UiParamsData uiParams,
    required TextFieldBorderType borderType,
    required InputDecoration? decoration,
    required ErrorPosition errorPosition,
    required TextFieldButtonConfig? buttonConfig,
    Set<WidgetState>? states,
    String? errorText,
  }) {
    // TODO support errorWidget
    bool showErrorBelowText = false ||
        errorPosition == ErrorPosition.dynamicSpaceBelowField ||
        errorPosition == ErrorPosition.fixedSpaceBelowField;
    final TextStyle? errorStyle = showErrorBelowText ? null : const TextStyle(fontSize: 0);

    Color? fillColor = uiParams.appColor.getFillColor(states);

    InputBorder? border = _makeInputDecorationBorder(
      uiParams,
      states,
      decoration,
      buttonConfig,
      borderType,
    );

    var appSize = uiParams.appSize;
    double zoom = appSize.zoom;

    if (decoration != null) {
      return decoration.copyWith(
        errorText: errorText,
        errorStyle: errorStyle,
        fillColor: fillColor,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        disabledBorder: border,
      );
    } else {
      return InputDecoration(
        errorText: errorText,
        errorStyle: errorStyle,
        fillColor: fillColor,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        disabledBorder: border,
      );
    }
  }

  static InputBorder? _makeInputDecorationBorder(
    UiParamsData uiParams,
    Set<WidgetState>? states,
    InputDecoration? inputDecoration,
    TextFieldButtonConfig? buttonConfig,
    TextFieldBorderType borderType,
  ) {
    BorderSide borderSide = BorderSide(
      color: uiParams.appColor.getBorderColor(states, uiParams.appColor.borderEnabled),
      width: uiParams.appSize.getBorderWidth(states, uiParams.appSize.borderWidth),
    );

    if (buttonConfig == null) {
      return switch (borderType) {
        TextFieldBorderType.outline => const OutlineInputBorder(),
        TextFieldBorderType.underline => const UnderlineInputBorder(),
        TextFieldBorderType.other => inputDecoration?.border,
      };
    } else if (buttonConfig.distanceFromTextField != null && buttonConfig.distanceFromTextField! > 0) {
      return switch (borderType) {
        TextFieldBorderType.outline => const OutlineInputBorder(),
        TextFieldBorderType.underline => const UnderlineInputBorder(),
        TextFieldBorderType.other => inputDecoration?.border,
      };
    }
    else {
      return switch (borderType) {
        // textFieldBorderType dominates the choice of border
        TextFieldBorderType.outline => switch (buttonConfig.buttonPosition) {
            ButtonPosition.left => OutlineSidesInputBorder(borderSide: borderSide, sideLeft: false),
            ButtonPosition.right => OutlineSidesInputBorder(borderSide: borderSide, sideRight: false),
          },
        TextFieldBorderType.underline => switch (buttonConfig.buttonPosition) {
            ButtonPosition.left => UnderlineTopRoundedInputBorder(borderSide: borderSide, radiusTopLeft: 0),
            ButtonPosition.right => UnderlineTopRoundedInputBorder(borderSide: borderSide, radiusTopRight: 0),
          },

        // when textFieldBorderType does not define the border - use inputDecoration.border or its
        // **FlutterFormBricks'** implementation accommodating the button if present
        TextFieldBorderType.other => switch (inputDecoration?.border) {
            const OutlineInputBorder() => switch (buttonConfig.buttonPosition) {
                ButtonPosition.left => OutlineSidesInputBorder(borderSide: borderSide, sideLeft: false),
                ButtonPosition.right => OutlineSidesInputBorder(borderSide: borderSide, sideRight: false),
              },
            const UnderlineInputBorder() => switch (buttonConfig.buttonPosition) {
                ButtonPosition.left => UnderlineTopRoundedInputBorder(borderSide: borderSide, radiusTopLeft: 0),
                ButtonPosition.right => UnderlineTopRoundedInputBorder(borderSide: borderSide, radiusTopRight: 0),
              },
            InputBorder() => inputDecoration!.border,
            // default:
            null => switch (buttonConfig.buttonPosition) {
                ButtonPosition.left => UnderlineTopRoundedInputBorder(borderSide: borderSide, radiusTopLeft: 0),
                ButtonPosition.right => UnderlineTopRoundedInputBorder(borderSide: borderSide, radiusTopRight: 0),
              },
          }
      };
    }
  }
}
