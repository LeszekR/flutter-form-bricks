import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/states_controller/double_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/components/states_controller/update_once_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/state_colored_icon_button.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_base_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_bordered_box.dart';

abstract class TextFieldBrick<V extends Object> extends TextFieldBaseBrick<TextEditingValue, V> {
  final double? width;

  TextFieldBrick({
    super.key,
    //
    // FormFieldBrick
    required super.keyString,
    required super.formManager,
    required super.validateMode,
    super.label,
    super.labelPosition,
    super.colorMaker,
    super.statesObserver,
    super.statesNotifier,
    //
    // TextFieldBrick
    this.width,
    //
    // TextFieldBaseBrick
    super.buttonParams,
    //
    // TextField
    super.groupId = EditableText,
    super.controller,
    super.focusNode,
    super.undoController,
    super.decoration,
    super.keyboardType,
    super.textInputAction,
    // TODO use instead of formatter-validator first-upper-then-lower
    super.textCapitalization = TextCapitalization.none,
    super.style,
    super.strutStyle,
    // TODO set constant for Datefield
    super.textAlign = TextAlign.start,
    // TODO set constant for Datefield
    super.textAlignVertical,
    // TODO set constant for Datefield
    super.textDirection,
    super.readOnly = false,
    super.showCursor,
    // super.autofocus = false, => FormData takes over in super
    // super.statesController,  => replaced with statesObserver and statesNotifier
    // TODO remove for all non-password fields
    super.obscuringCharacter = '•',
    // TODO remove for all non-password fields
    super.obscureText = false,
    // TODO remove for all fields where super does not make sense - like DateField etc
    super.autocorrect = true,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions = true,
    // TODO lock in fields where multiline makes no sense like DateField etc
    super.maxLines = 1,
    super.minLines,
    super.expands = false,
    // TODO implement remaining n showing on the screen maximum allowed “characters” (with caveats re: grapheme clusters); shows a counter by default.
    super.maxLength,
    super.maxLengthEnforcement,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onAppPrivateCommand,
    // TODO use for our formatter-validators running in onChange now
    super.inputFormatters,
    super.enabled,
    super.ignorePointers,
    super.cursorWidth = 2.0,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.cursorErrorColor,
    super.selectionHeightStyle = BoxHeightStyle.tight,
    super.selectionWidthStyle = BoxWidthStyle.tight,
    super.keyboardAppearance,
    super.scrollPadding = const EdgeInsets.all(20.0),
    super.dragStartBehavior = DragStartBehavior.start,
    super.enableInteractiveSelection,
    super.selectAllOnFocus,
    super.selectionControls,
    super.onTap,
    super.onTapAlwaysCalled = false,
    super.onTapOutside,
    super.onTapUpOutside,
    super.mouseCursor,
    // TODO use? to implement remaining n showing on the screen of maximum allowed “characters”
    super.buildCounter,
    // TODO lock for single-line fields like DateField
    super.scrollController,
    // TODO lock for single-line fields like DateField
    super.scrollPhysics,
    // TODO NameField (use also capitalisation there, add other fields of similar specialisation):
    super.autofillHints = const <String>[],
    // TODO lock for fields where no content will ever be inserted like DateField
    super.contentInsertionConfiguration,
    // TODO lock for fields where no content will ever be inserted like DateField
    super.clipBehavior = Clip.hardEdge,
    super.restorationId,
    super.stylusHandwritingEnabled = EditableText.defaultStylusHandwritingEnabled,
    super.enableIMEPersonalizedLearning = true,
    super.contextMenuBuilder,
    super.canRequestFocus = true,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
    super.hintLocales,
  });
}

abstract class TextFieldStateBrick<V extends Object, B extends TextFieldBrick<V>>
    extends TextFieldBaseStateBrick<TextEditingValue, V, B> {
  late final TextEditingController controller;

  @override
  TextEditingValue? getInput() => controller.value;

  @override
  void setInput(TextEditingValue? formattedValue) => controller.value = formattedValue ?? TextEditingValue.empty;

  @override
  void initState() {
    // TODO this strips the field from flutter's restoration - implement restoration pattern as in comments at the end of this file
    controller = widget.controller ?? TextEditingController();
    setInput(formManager.getInitialInput(keyString));

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var uiParams = UiParams.of(context);

    var statesObserver;
    var statesNotifier;
    TextField textField;
    TextStyle style;
    double lineHeight, textHeight, buttonWidth, buttonHeight;
    StateColoredIconButton? button;

    if (widget.style == null) {
      style = uiParams.appTheme.textStyle();
      lineHeight = uiParams.appTheme.textLineHeight;
    } else {
      style = widget.style!;
      lineHeight = uiParams.appTheme.calculateLineHeight(widget.style!);
    }

    int maxLines = widget.maxLines ?? 1;
    double width = widget.width ?? uiParams.appSize.textFieldWidth;

// TODO SizedBox still not tall correctly
    textHeight = lineHeight * maxLines;

    if (widget.buttonParams == null) {
      var statesController = WidgetStatesController();
      statesObserver = statesController;
      statesNotifier = statesController;
    } else {
      var statesController = DoubleWidgetStatesController();
      statesObserver = statesController.lateWidgetStatesController;
      statesNotifier = statesController.receiverStatesController;

      buttonWidth = widget.buttonParams!.width ?? uiParams.appSize.textFieldButtonWidth;
      assert(buttonWidth <= width / 2, 'BrickTextField button must not be wider than half of the field width');

      buttonHeight = widget.buttonParams!.height ?? uiParams.appSize.textFieldButtonHeight;
      buttonHeight = min(buttonHeight, textHeight);

      button = _makeButton(statesObserver, statesNotifier, buttonWidth, buttonHeight);
    }

    textField = _makeTextField(context, statesObserver, statesNotifier, style);

    return ValueListenableBuilder(
      valueListenable: statesNotifier,
      builder: (context, states, _) {
        return TextFieldBorderedBox.build(
          uiParamsData: uiParams,
          width: width,
          lineHeight: lineHeight,
          nLines: maxLines,
          textField: textField,
          button: button,
        );
      },
    );
  }

  TextField _makeTextField(
    BuildContext context,
    WidgetStatesController statesObserver,
    WidgetStatesController statesNotifier,
    TextStyle style,
  ) {
    return TextField(
      // key: Key(keyString),
      groupId: widget.groupId,
      controller: controller,
      focusNode: widget.focusNode,
      undoController: widget.undoController,
      decoration: _makeInputDecoration(widget.decoration),
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly,
      // Deprecated: toolbarOptions - not used
      showCursor: widget.showCursor,
      // autofocus: widget.autofocus,
      statesController: widget.statesObserver,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      onChanged: (_) => onInputChanged(),
      onEditingComplete: onEditingComplete,
      onSubmitted: widget.onSubmitted,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,

      /// ignorePointers tells the TextField to ignore pointer events (taps, clicks, drags) for hit-testing. That means:
      /// user taps won’t focus it, selection/handles won’t respond, mouse interactions won’t apply.
      /// It’s different from / enabled: false / readOnly: true: enabled: false also affects styling and semantics like
      /// a disabled control. / readOnly: true still allows focus/selection/copy in many cases. ignorePointers: true is a
      /// blunt “don’t react to / pointer input” switch.
      /// You’d use it for “overlay intercepts touches”, or when the field / is visually shown but / interaction is
      /// controlled elsewhere.
      ignorePointers: widget.ignorePointers,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorOpacityAnimates: widget.cursorOpacityAnimates,
      cursorColor: widget.cursorColor,
      cursorErrorColor: widget.cursorErrorColor,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectAllOnFocus: widget.selectAllOnFocus,
      selectionControls: widget.selectionControls,
      onTap: widget.onTap,
      onTapAlwaysCalled: widget.onTapAlwaysCalled,
      onTapOutside: widget.onTapOutside,
      onTapUpOutside: widget.onTapUpOutside,
      mouseCursor: widget.mouseCursor,
      buildCounter: widget.buildCounter,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      contentInsertionConfiguration: widget.contentInsertionConfiguration,
      clipBehavior: widget.clipBehavior,
      restorationId: widget.restorationId,
      // Deprecated: scribbleEnabled - not used
      stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      contextMenuBuilder: widget.contextMenuBuilder,
      canRequestFocus: widget.canRequestFocus,
      spellCheckConfiguration: widget.spellCheckConfiguration,
      magnifierConfiguration: widget.magnifierConfiguration,
      hintLocales: widget.hintLocales,
    );
  }

  StateColoredIconButton? _makeButton(
    UpdateOnceWidgetStatesController statesObserver,
    WidgetStatesController statesNotifier,
    double width,
    double height,
  ) {
    if (widget.buttonParams == null) {
      return null;
    }
    return StateColoredIconButton(
      width: width,
      height: height,
      statesObserver: statesObserver,
      statesNotifier: statesNotifier,
      colorMaker: widget.colorMaker,
      iconData: widget.buttonParams!.iconData,
      onPressed: widget.buttonParams!.onPressed,
      autofocus: widget.buttonParams!.autofocus,
      tooltip: widget.buttonParams!.tooltip,
    );
  }

  // TODO move helper methods to a singleton
  // TODO move this to FormFieldBrick?
  InputDecoration _makeInputDecoration(InputDecoration? decoration) {
    if (decoration == null) {
      return InputDecoration(
        // isDense: true,
        // isCollapsed: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        fillColor: makeColor(),
      );
    }
    return decoration.copyWith(
      fillColor: makeColor(),
    );
  }
}
