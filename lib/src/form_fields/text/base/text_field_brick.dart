import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/components/states_controller/double_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/components/states_controller/update_once_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/state_colored_icon_button.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_bordered_box.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_config.dart';
import 'package:flutter_form_bricks/src/ui_params/theme_data/bricks_theme_data.dart';

abstract class TextFieldBrick<V extends Object> extends FormFieldBrick<TextEditingValue, V> {
  final double? width;
  final TextFieldConfig config;

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
    // TextFieldConfig
    IconButtonParams? buttonParams,
    //
    // Flutter TextField
    TextMagnifierConfiguration? magnifierConfiguration,
    Object groupId = EditableText,
    TextEditingController? controller,
    FocusNode? focusNode,
    InputDecoration? decoration,
    // TODO set constant for Datefield - number or datetime
    TextInputType? keyboardType,
    // TODO set TextInputAction.newline? in multiline fields? Or it will be default there?
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    TextDirection? textDirection,
    bool readOnly = false,
    // bool autofocus, => FormData takes over initial focus in form
    // MaterialStatesController? statesController, => replaced with statesObserver and statesNotifier
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool? autocorrect,
    // TODO turn off and lock it for strictly formatting fields like DateField
    SmartDashesType? smartDashesType,
    // TODO turn off and lock it for strictly formatting fields like DateField
    SmartQuotesType? smartQuotesType,
    // TODO turn off and lock it for strictly formatting fields like DateField
    bool enableSuggestions = true,
    int? maxLines,
    int? minLines,
    bool expands = false,
    bool? showCursor,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
    VoidCallback? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    AppPrivateCommandCallback? onAppPrivateCommand,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    bool? ignorePointers,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    bool? cursorOpacityAnimates,
    Color? cursorColor,
    Color? cursorErrorColor,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool? enableInteractiveSelection,
    bool? selectAllOnFocus,
    TextSelectionControls? selectionControls,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    GestureTapCallback? onTap,
    bool onTapAlwaysCalled = false,
    TapRegionCallback? onTapOutside,
    TapRegionUpCallback? onTapUpOutside,
    MouseCursor? mouseCursor,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    ScrollController? scrollController,
    Iterable<String>? autofillHints,
    Clip clipBehavior = Clip.hardEdge,
    String? restorationId,
    bool stylusHandwritingEnabled = EditableText.defaultStylusHandwritingEnabled,
    bool enableIMEPersonalizedLearning = true,
    // TODO turn off and lock it for strictly formatting fields like DateField
    ContentInsertionConfiguration? contentInsertionConfiguration,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    bool canRequestFocus = true,
    UndoHistoryController? undoController,
    SpellCheckConfiguration? spellCheckConfiguration,
    List<Locale>? hintLocales,
  }) : config = TextFieldConfig(
          // // TextFieldConfig
          buttonParams: buttonParams,
          //
          // Flutter TextField
          magnifierConfiguration: magnifierConfiguration,
          groupId: groupId,
          controller: controller,
          focusNode: focusNode,
          decoration: decoration,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          textDirection: textDirection,
          //  bool autofocus: //  bool autofocus, => FormData takes over initial focus in form
          //  MaterialStatesController statesController: //  MaterialStatesController statesController, => replaced with statesObserver and statesNotifier
          obscuringCharacter: obscuringCharacter,
          obscureText: obscureText,
          autocorrect: autocorrect,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          enableSuggestions: enableSuggestions,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          readOnly: readOnly,
          showCursor: showCursor,
          maxLength: maxLength,
          maxLengthEnforcement: maxLengthEnforcement,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          onAppPrivateCommand: onAppPrivateCommand,
          inputFormatters: inputFormatters,
          enabled: enabled,
          ignorePointers: ignorePointers,
          cursorWidth: cursorWidth,
          cursorHeight: cursorHeight,
          cursorRadius: cursorRadius,
          cursorOpacityAnimates: cursorOpacityAnimates,
          cursorColor: cursorColor,
          cursorErrorColor: cursorErrorColor,
          selectionHeightStyle: selectionHeightStyle,
          selectionWidthStyle: selectionWidthStyle,
          keyboardAppearance: keyboardAppearance,
          scrollPadding: scrollPadding,
          enableInteractiveSelection: enableInteractiveSelection,
          selectAllOnFocus: selectAllOnFocus,
          selectionControls: selectionControls,
          dragStartBehavior: dragStartBehavior,
          onTap: onTap,
          onTapAlwaysCalled: onTapAlwaysCalled,
          onTapOutside: onTapOutside,
          onTapUpOutside: onTapUpOutside,
          mouseCursor: mouseCursor,
          buildCounter: buildCounter,
          scrollPhysics: scrollPhysics,
          scrollController: scrollController,
          autofillHints: autofillHints,
          clipBehavior: clipBehavior,
          restorationId: restorationId,
          stylusHandwritingEnabled: stylusHandwritingEnabled,
          enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
          contentInsertionConfiguration: contentInsertionConfiguration,
          contextMenuBuilder: contextMenuBuilder,
          canRequestFocus: canRequestFocus,
          undoController: undoController,
          spellCheckConfiguration: spellCheckConfiguration,
          hintLocales: hintLocales,
        );
}

abstract class TextFieldStateBrick<V extends Object, B extends TextFieldBrick<V>>
    extends FormFieldStateBrick<TextEditingValue, V, B> {
  //
  late final TextEditingController controller;
  late WidgetStatesController statesObserver;
  late WidgetStatesController statesNotifier;
  late double lineHeight, textHeight, buttonWidth, buttonHeight, width;
  late int maxLines;
  late TextStyle style;

  @override
  TextEditingValue? getInput() => controller.value;

  @override
  void setInput(TextEditingValue? formattedValue) => controller.value = formattedValue ?? TextEditingValue.empty;

  @override
  void initState() {

    // TODO this strips the field from flutter's restoration - implement restoration pattern as in comments at the end of this file
    controller = widget.config.controller ?? TextEditingController();
    setInput(formManager.getInitialInput(keyString));

    if (widget.config.buttonParams != null) {
      var statesController = DoubleWidgetStatesController();
      statesObserver = statesController.lateWidgetStatesController;
      statesNotifier = statesController.receiverStatesController;
    } else {
      var statesController = WidgetStatesController();
      statesObserver = statesController;
      statesNotifier = statesController;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var uiParams = UiParams.of(context);

    if (widget.config.style == null) {
      style = uiParams.appTheme.textStyle();
      lineHeight = uiParams.appTheme.getFontDimension(TextDimension.lineHeight);
    } else {
      style = widget.config.style!;
      lineHeight = uiParams.appTheme.computeFontDimension(widget.config.style!, TextDimension.lineHeight);
    }

    maxLines = widget.config.maxLines ?? 1;
    width = widget.width ?? uiParams.appSize.textFieldWidth;

    // TODO SizedBox still not tall correctly
    textHeight = lineHeight * maxLines;

    // TODO verify / test / fix passing-using ststesObserver - note: TextFieldBrick costructs it INSIDE - then what about the one in FormFieldBrick??

    if (widget.config.buttonParams != null) {
      buttonWidth = widget.config.buttonParams!.width ?? uiParams.appSize.textFieldButtonWidth;
      assert(buttonWidth <= width / 2, 'BrickTextField button must not be wider than half of the field width');

      buttonHeight = widget.config.buttonParams!.height ?? uiParams.appSize.textFieldButtonHeight;
      buttonHeight = min(buttonHeight, textHeight);
    }
  }

  @override
  void dispose() {
    if(widget.config.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var uiParams = UiParams.of(context);

    final button = widget.config.buttonParams == null
        ? null
        : _makeButton(buttonWidth, buttonHeight);

    return ValueListenableBuilder(
      valueListenable: statesNotifier,
      builder: (context, states, _) {
        return TextFieldBorderedBox.build(
          uiParamsData: uiParams,
          width: width,
          lineHeight: lineHeight,
          nLines: maxLines,
          textField: _makeTextField(style),
          button: button,
        );
      },
    );
  }

  TextField _makeTextField(TextStyle style) {
    return TextField(
      // key: Key(keyString),
      groupId: widget.config.groupId,
      controller: controller,
      focusNode: focusNode,
      undoController: widget.config.undoController,
      decoration: _makeInputDecoration(),
      keyboardType: widget.config.keyboardType,
      textInputAction: widget.config.textInputAction,
      textCapitalization: widget.config.textCapitalization,
      style: style,
      strutStyle: widget.config.strutStyle,
      textAlign: widget.config.textAlign,
      textAlignVertical: widget.config.textAlignVertical,
      textDirection: widget.config.textDirection,
      readOnly: widget.config.readOnly,
      // Deprecated: toolbarOptions - not used
      showCursor: widget.config.showCursor,
      // autofocus: widget.config.autofocus,
      statesController: statesObserver,
      obscuringCharacter: widget.config.obscuringCharacter,
      obscureText: widget.config.obscureText,
      autocorrect: widget.config.autocorrect,
      smartDashesType: widget.config.smartDashesType,
      smartQuotesType: widget.config.smartQuotesType,
      enableSuggestions: widget.config.enableSuggestions,
      maxLines: widget.config.maxLines,
      minLines: widget.config.minLines,
      expands: widget.config.expands,
      maxLength: widget.config.maxLength,
      maxLengthEnforcement: widget.config.maxLengthEnforcement,
      onChanged: (_) => onInputChanged(),
      onEditingComplete: onEditingComplete,
      onSubmitted: widget.config.onSubmitted,
      onAppPrivateCommand: widget.config.onAppPrivateCommand,
      inputFormatters: widget.config.inputFormatters,
      enabled: widget.config.enabled,

      /// ignorePointers tells the TextField to ignore pointer events (taps, clicks, drags) for hit-testing. That means:
      /// user taps won’t focus it, selection/handles won’t respond, mouse interactions won’t apply.
      /// It’s different from / enabled: false / readOnly: true: enabled: false also affects styling and semantics like
      /// a disabled control. / readOnly: true still allows focus/selection/copy in many cases. ignorePointers: true is a
      /// blunt “don’t react to / pointer input” switch.
      /// You’d use it for “overlay intercepts touches”, or when the field / is visually shown but / interaction is
      /// controlled elsewhere.
      ignorePointers: widget.config.ignorePointers,
      cursorWidth: widget.config.cursorWidth,
      cursorHeight: widget.config.cursorHeight,
      cursorRadius: widget.config.cursorRadius,
      cursorOpacityAnimates: widget.config.cursorOpacityAnimates,
      cursorColor: widget.config.cursorColor,
      cursorErrorColor: widget.config.cursorErrorColor,
      selectionHeightStyle: widget.config.selectionHeightStyle,
      selectionWidthStyle: widget.config.selectionWidthStyle,
      keyboardAppearance: widget.config.keyboardAppearance,
      scrollPadding: widget.config.scrollPadding,
      dragStartBehavior: widget.config.dragStartBehavior,
      enableInteractiveSelection: widget.config.enableInteractiveSelection,
      selectAllOnFocus: widget.config.selectAllOnFocus,
      selectionControls: widget.config.selectionControls,
      onTap: widget.config.onTap,
      onTapAlwaysCalled: widget.config.onTapAlwaysCalled,
      onTapOutside: widget.config.onTapOutside,
      onTapUpOutside: widget.config.onTapUpOutside,
      mouseCursor: widget.config.mouseCursor,
      buildCounter: widget.config.buildCounter,
      scrollController: widget.config.scrollController,
      scrollPhysics: widget.config.scrollPhysics,
      autofillHints: widget.config.autofillHints,
      contentInsertionConfiguration: widget.config.contentInsertionConfiguration,
      clipBehavior: widget.config.clipBehavior,
      restorationId: widget.config.restorationId,
      // Deprecated: scribbleEnabled - not used
      stylusHandwritingEnabled: widget.config.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: widget.config.enableIMEPersonalizedLearning,
      contextMenuBuilder: widget.config.contextMenuBuilder,
      canRequestFocus: widget.config.canRequestFocus,
      spellCheckConfiguration: widget.config.spellCheckConfiguration,
      magnifierConfiguration: widget.config.magnifierConfiguration,
      hintLocales: widget.config.hintLocales,
    );
  }

  StateColoredIconButton? _makeButton(double width, double height) {
    return StateColoredIconButton(
      width: width,
      height: height,
      statesObserver: statesObserver as UpdateOnceWidgetStatesController,
      statesNotifier: statesNotifier,
      colorMaker: widget.colorMaker,
      iconData: widget.config.buttonParams!.iconData,
      onPressed: widget.config.buttonParams!.onPressed,
      autofocus: widget.config.buttonParams!.autofocus,
      tooltip: widget.config.buttonParams!.tooltip,
    );
  }

  // TODO move helper methods to a singleton

  InputDecoration _makeInputDecoration() {
    if (widget.config.decoration != null) {
      return widget.config.decoration!.copyWith(
        errorText: formManager.getFieldError(keyString),
        // fillColor: makeColor(),
      );
    } else {
      return InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        // TU PRZERWALEM - uncomment and it will throw
        // errorText: formManager.getFieldError(keyString),
        // fillColor: makeColor(),
      );
    }
  }

  bool _skipOnChanged = false;

  @mustCallSuper
  @override
  FieldContent<TextEditingValue, V>? onInputChanged() {
    // Stop infinite call here at changing the field value to formatted one
    if (_skipOnChanged) return null;

    if (widget.validateMode != ValidateModeBrick.onChange) return null;

    // Here FormManager does the following:
    // - validates the input and shows error message
    // - formats the input and returns formatted input text in TextEditingValue
    // - saves results of format and validation in FormData -> FormFieldData -> FieldContent
    FieldContent<TextEditingValue, V> fieldContent = super.onInputChanged()!;

    // draw formatted input in UI
    _updateUi(fieldContent);

    // Run custom onChanged callback if provided
    widget.onChanged?.call(getInput()!);

    return null;
  }

  @mustCallSuper
  void onEditingComplete() {
    if (widget.validateMode != ValidateModeBrick.onEditingComplete) return;

    // Here FormManager:
    // - validates the input and shows error message
    // - formats the input and returns formatted input text in TextEditingValue
    // - saves results of format-validation in FormData -> FormFieldData -> FieldContent
    FieldContent<TextEditingValue, V> fieldContent = super.onInputChanged()!;

    // draw formatted input in UI
    _updateUi(fieldContent);

    // Run custom onEditingComplete callback if provided
    widget.config.onEditingComplete?.call();
  }

  void _updateUi(FieldContent<TextEditingValue, V> fieldContent) {
    _skipOnChanged = true;
    setState(() {
      setInput(fieldContent.input);
      // _inputDecoration = _inputDecoration.copyWith(errorText: fieldContent.error);
    });
    _skipOnChanged = false;
  }
}
