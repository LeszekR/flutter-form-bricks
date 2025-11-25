import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/inputs/states_controller/double_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/inputs/states_controller/update_once_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/inputs/text/text_input_base/state_colored_icon_button.dart';
import 'package:flutter_form_bricks/src/inputs/text/text_input_base/text_field_bordered_box.dart';

import '../../../ui_params/ui_params.dart';
import '../../base/form_field_brick.dart';
import 'icon_button_params.dart';

abstract class TextFieldBrick extends FormFieldBrick {
  // TextFieldBrick
  final double? width;

  // Flutter TextField
  final TextMagnifierConfiguration? magnifierConfiguration;
  final Object groupId;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool autofocus;

  // final MaterialStatesController? statesController;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  final bool? showCursor;
  static const int noMaxLength = -1;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool? ignorePointers;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final bool? cursorOpacityAnimates;
  final Color? cursorColor;
  final Color? cursorErrorColor;
  final BoxHeightStyle selectionHeightStyle;
  final BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final bool? selectAllOnFocus;
  final TextSelectionControls? selectionControls;
  final DragStartBehavior dragStartBehavior;
  final GestureTapCallback? onTap;
  final bool onTapAlwaysCalled;
  final TapRegionCallback? onTapOutside;
  final TapRegionUpCallback? onTapUpOutside;
  final MouseCursor? mouseCursor;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final Clip clipBehavior;
  final String? restorationId;
  final bool stylusHandwritingEnabled;
  final bool enableIMEPersonalizedLearning;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final bool canRequestFocus;
  final UndoHistoryController? undoController;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final List<Locale>? hintLocales;

  final IconButtonParams? buttonParams;

  TextFieldBrick({
    super.key,
    //
    // FormFieldBrick
    required super.keyString,
    required super.formManager,
    required super.colorMaker,
    required super.withValidator,
    super.statesObserver,
    super.statesNotifier,
    super.autoValidateMode = AutovalidateMode.disabled,
    //
    // BrickTextField
    this.width,
    //
    // TextField
    this.groupId = EditableText,
    this.controller,
    this.focusNode,
    this.undoController,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    // this.statesController,  => replaced with statesObserver and statesNotifier
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.cursorErrorColor,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectAllOnFocus,
    this.selectionControls,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.onTapUpOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.stylusHandwritingEnabled = EditableText.defaultStylusHandwritingEnabled,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder,
    this.canRequestFocus = true,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.buttonParams,
    this.hintLocales,
  });

  @override
  TextFieldStateBrick createState() => TextFieldStateBrick();
}

class TextFieldStateBrick extends FormFieldStateBrick<String, TextEditingValue, TextFieldBrick> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  Set<WidgetState>? _states;

  @override
  TextEditingValue getValue() => _controller.value;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();
    formManager.setFocusListener(_focusNode, keyString);
    if (formManager.isFocusedOnStart(keyString)) _focusNode.requestFocus();

    if (widget.controller == null) {
      _controller = TextEditingController(text: formManager.getInitialInput(keyString));
    } else {
      _controller = widget.controller!;
      _controller.text = (formManager.getInitialInput(keyString) as TextEditingValue).text;
    }

    _states = widget.statesNotifier?.value;
    widget.statesNotifier?.addListener(_onStatesChanged);
  }

  @override
  void dispose() {
    widget.statesNotifier?.removeListener(_onStatesChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onStatesChanged() {
    setState(() {
      _states = widget.statesNotifier?.value;
    });
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
      key: Key(keyString),
      groupId: widget.groupId,
      controller: widget.controller,
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
      autofocus: widget.autofocus,
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
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
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
  InputDecoration _makeInputDecoration(InputDecoration? decoration) {
    if (decoration == null) {
      return InputDecoration(
        // isDense: true,
        // isCollapsed: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        fillColor: _makeColor(),
      );
    }
    return decoration.copyWith(
      fillColor: _makeColor(),
    );
  }

  // TODO move helper methods to a singleton
  Color? _makeColor() => widget.colorMaker.makeColor(context, _states);

  var _skipOnChanged = false;

  void _onChanged(value) {
    // stop infinite call here at changing the field value to trimmed one
    if (_skipOnChanged) return;

    widget.onChanged?.call(value?.trim());

    // we need formManager to validate and show error when onEditingComplete will NEVER be called.
    // If onEditingComplete is called then formManager.onFieldChanged is called there so we skip it here
    if (widget.onEditingComplete == null || widget.onEditingComplete == () {}) {
      _skipOnChanged = true;
      // TODO REFACTOR - formatting and validation done in FormManager, formatted value passed back here
      // widget.formManager.onFieldChanged(keyString, value);
      _skipOnChanged = false;
    }
  }

  void _onEditingComplete() {
    // TODO uncomment and finish
    // _skipOnChanged = true;
    // var value = widget.onEditingComplete?.call();
    // _skipOnChanged = false;
    // TODO REFACTOR - formatting and validation done in FormManager, formatted value passed back here
    // widget.formManager.onFieldChanged(widget.keyString, value);
  }
}
