import 'package:flutter/material.dart';

enum ButtonPosition { left, right }

class TextFieldButtonConfig {
  final double? size;

  final IconData iconData;

  /// Where this `TextFieldButton` will be placed relative to its `TextFieldBrick' - to the left or right
  final ButtonPosition buttonPosition;

  final String Function(BuildContext)? tooltipMaker;

  final ButtonStyle? buttonStyle;

  /// pixels between the `TextFieldBrick` and this `TextFieldButton` - supply unzoomed value, it will be zoomed
  /// (multiplied by `AppSize.zoom`
  final double? distanceFromTextField;

  /// If `true`, the button background and border will change in unison with
  /// its `TextFieldBrick`'s background and border.
  ///
  /// They will follow the current `Set<WidgetState>` of both widgets and show
  /// colors and thickness assigned to the dominant state of the two.
  ///
  /// See also:
  /// - [CompoundWidgetStatesController]
  /// - [AppColor.getFillColor]
  /// - [AppColor.getBorderColor]
  /// - [AppSize.getBorderWidth]
  final bool syncStyleWithTextField;

  /// If `true` then only the icon will be visible, the shape, background and border will be transparent showing window background
  final bool transparentBackground;

  final bool autofocus;

  const TextFieldButtonConfig({
    this.size,
    this.iconData = Icons.arrow_drop_down,
    this.buttonPosition = ButtonPosition.right,
    this.tooltipMaker,
    this.buttonStyle,
    this.distanceFromTextField,
    this.syncStyleWithTextField = true,
    this.transparentBackground = false,
    this.autofocus = false,
  }) : assert(buttonStyle == null || transparentBackground == false,
            'When buttonStyle is not null, transparentBackground must be false');

  TextFieldButtonConfig fillFrom(TextFieldButtonConfig? other) {
    return TextFieldButtonConfig(
      size: other?.size ?? size,
      iconData: other?.iconData ?? iconData,
      buttonPosition: other?.buttonPosition ?? buttonPosition,
      tooltipMaker: tooltipMaker,
      buttonStyle: other?.buttonStyle ?? buttonStyle,
      distanceFromTextField: other?.distanceFromTextField ?? distanceFromTextField,
      syncStyleWithTextField: other?.syncStyleWithTextField ?? syncStyleWithTextField,
      transparentBackground: transparentBackground,
      autofocus: other?.autofocus ?? autofocus,
    );
  }

  TextFieldButtonConfig copyWith({
    double? size,
    IconData? iconData,
    ButtonPosition? buttonPosition,
    String Function(BuildContext)? tooltipMaker,
    ButtonStyle? style,
    double? distanceFromTextField,
    bool? syncStyleWithTextField,
    bool? transparentBackground,
    bool? autofocus,
  }) {
    return TextFieldButtonConfig(
      size: size ?? this.size,
      iconData: iconData ?? this.iconData,
      buttonPosition: buttonPosition ?? this.buttonPosition,
      tooltipMaker: tooltipMaker ?? this.tooltipMaker,
      buttonStyle: style ?? this.buttonStyle,
      distanceFromTextField: distanceFromTextField ?? this.distanceFromTextField,
      syncStyleWithTextField: syncStyleWithTextField ?? this.syncStyleWithTextField,
      transparentBackground: transparentBackground ?? this.transparentBackground,
      autofocus: autofocus ?? this.autofocus,
    );
  }
}
