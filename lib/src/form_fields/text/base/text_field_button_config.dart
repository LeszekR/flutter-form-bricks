import 'package:flutter/material.dart';

enum ButtonPosition { left, right }

class TextFieldButtonConfig {
  /// Height and width of the `TextFieldButton` - supply unzoomed value, it will be zoomed (multiplied by `AppSize.zoom`).
  ///
  /// Since Flutter exposes no API for reading `InputDecorator's` height it was decided to use this parameter to
  /// adjust the height of the button to match the height of its `TextFieldBrick`. Best way to achieve this: run your
  /// app with FlutterInspector and `AppSize.zoom == 1`, then check the height of the text field and put the same
  /// value as `size` here.
  final double? size;

  /// Default in this lib is `Icons.arrow_drop_down` as simple and not cluttering the UI. You can use any icon you want
  /// however. E.g. `Icons.calendar_today` for `DateField`, etc. Observe other params (`distanceFromTextField`,
  /// `syncStyleWithTextField`, `transparentBackground`) if you want to have the icon as separate widget in the UI.
  final IconData iconData;

  /// Where this `TextFieldButton` will be placed relative to its `TextFieldBrick' - to the left or right
  final ButtonPosition buttonPosition;

  /// Will be used as tooltip for this `TextFieldButton`. Strongly recommended - use `localizations` to create the
  /// tooltip text so it gets translated to the user's language. Also it reduces creation of repeated literals in
  /// your app to a single place in code.
  final String Function(BuildContext)? tooltipMaker;

  /// When `buttonStyle` is not `null`  then `transparentBackground` must be `false` because otherwise
  /// the style will collide with the transparency requirement. (Guarded by `assert` in constructor.)
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
  /// When `syncStyleWithTextField` is `true` then `transparentBackground` must be `false` because otherwise
  /// the style will not be synced.
  ///
  /// See also:
  /// - [CompoundWidgetStatesController]
  /// - [AppColor.getFillColor]
  /// - [AppColor.getBorderColor]
  /// - [AppSize.getBorderWidth]
  final bool syncStyleWithTextField;

  /// If `true` then only the icon will be visible, the shape, background and border will be transparent showing
  /// window background.
  ///
  /// When `buttonStyle` is not `null`  then `transparentBackground` must be `false` because otherwise
  /// the style will collide with the transparency requirement. (Guarded by `assert` in constructor.)
  ///
  /// When `syncStyleWithTextField` is `true` then `transparentBackground` must be `false` because otherwise
  /// the style will not be synced. (Guarded by `assert` in constructor.)
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
  })  : assert(buttonStyle == null || transparentBackground == false,
            'When buttonStyle is not null, transparentBackground must be false'),
        assert(syncStyleWithTextField == false || transparentBackground == false,
            'When syncStyleWithTextField is false, transparentBackground must be false');

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
