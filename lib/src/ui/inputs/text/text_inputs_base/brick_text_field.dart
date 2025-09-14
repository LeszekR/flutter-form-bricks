import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/ui/inputs/states_controller/double_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/ui/inputs/states_controller/update_once_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/ui/inputs/text/text_inputs_base/state_aware_icon_button.dart';
import 'package:flutter_form_bricks/src/ui/inputs/text/text_inputs_base/text_field_container.dart';

import '../../../visual_params/app_size.dart';
import '../../base/brick_field.dart';
import '../../states_controller/error_message_notifier.dart';

class BrickTextField extends BrickField {
  // BrickTextField
  final double? width;
  final double? lineHeight;
  final int nLines;
  final bool? withTextEditingController;

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
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
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

  final IconButtonParams? buttonParams;

  BrickTextField({
    super.key,
    //
    // BrickFormField
    required super.keyString,
    required super.formManager,
    required super.colorMaker,
    super.statesObserver,
    super.statesNotifier,
    super.autoValidateMode = AutovalidateMode.disabled,
    //
    // BrickTextField
    this.width,
    this.lineHeight,
    this.nLines = 1,
    this.withTextEditingController,
    //
    // TextField
    this.groupId = EditableText,
    this.controller,
    this.focusNode,
    this.undoController,
    this.decoration = const InputDecoration(),
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
    // this.statesController,
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
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
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
  });

  @override
  State<StatefulWidget> createState() => _StateAwareTextFieldState();
}

class _StateAwareTextFieldState extends BrickFieldState<BrickTextField> with ErrorMessageNotifier {
  dynamic initialValue;
  Set<WidgetState>? _states;

  @override
  void initState() {
    super.initState();

    super.setErrorMessageListener(widget.formManager, widget.keyString);

    // TODO uncomment and finish
    _states = widget.statesNotifier?.value;
    widget.statesNotifier?.addListener(_onStatesChanged);

    // TODO uncomment and finish
    // if (widget.withTextEditingController ?? true) {
    //   var controllerValue = widget.initialValue;
    //   if (controllerValue != null) controllerValue = controllerValue.toString();
    //   widget.formManager.setEditingController(widget.keyString, controllerValue);
    // } else {
    //   initialValue = widget.initialValue;
    // }
  }

  @override
  void dispose() {
    widget.statesNotifier?.removeListener(_onStatesChanged);
    super.dispose();
  }

  void _onStatesChanged() {
    setState(() {
      _states = widget.statesNotifier?.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var statesObserver;
    var statesNotifier;
    TextField textField;
    StateAwareIconButton? button;

    if (widget.buttonParams == null) {
      var statesController = WidgetStatesController();
      statesObserver = statesController;
      statesNotifier = statesController;
    } else {
      var statesController = DoubleWidgetStatesController();
      statesObserver = statesController.lateWidgetStatesController;
      statesNotifier = statesController.receiverStatesController;

      button = _makeButton(statesObserver, statesNotifier);
    }

    textField = _makeTextField(statesObserver, statesNotifier);

    return ValueListenableBuilder(
      valueListenable: statesNotifier,
      builder: (__, states, _) {
        return TextFieldBorderedBox.build(
          width: widget.width ?? AppSize.inputTextWidth,
          lineHeight: widget.lineHeight ?? AppSize.inputTextLineHeight,
          nLines: widget.nLines,
          textField: textField,
          button: button,
        );
      },
    );
  }

  TextField _makeTextField(WidgetStatesController statesObserver, WidgetStatesController statesNotifier) {
    return TextField(
      key: Key(widget.keyString),
      groupId: widget.groupId,

      controller: widget.formManager.getTextEditingController(widget.keyString),
      focusNode: widget.formManager.getFocusNode(widget.keyString),
      undoController: widget.undoController,

      decoration: InputDecoration(
        border: InputBorder.none,
        fillColor: widget.colorMaker.makeColor(_states),
      ),

      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: widget.style,
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
    );
  }

  StateAwareIconButton? _makeButton(
    UpdateOnceWidgetStatesController statesObserver,
    WidgetStatesController statesNotifier,
  ) {
    if (widget.buttonParams == null) {
      return null;
    }
    return StateAwareIconButton(
      statesObserver: statesObserver,
      statesNotifier: statesNotifier,
      colorMaker: widget.colorMaker,
      iconData: widget.buttonParams!.iconData,
      onPressed: widget.buttonParams!.onPressed,
      autofocus: widget.buttonParams!.autofocus,
      tooltip: widget.buttonParams!.tooltip,
    );
  }

  var _skipOnChanged = false;

  void _onChanged(value) {
    // stop infinite call here at changing the field value to trimmed one
    if (_skipOnChanged) return;

    widget.onChanged?.call(value?.trim());

    // we need formManager to validate and show error when onEditingComplete will NEVER be called.
    // If onEditingComplete is called then formManager.onFieldChanged is called there so we skip it here
    if (widget.onEditingComplete == null || widget.onEditingComplete == () {}) {
      _skipOnChanged = true;
      widget.formManager.onFieldChanged(widget.keyString, value);
      _skipOnChanged = false;
    }
  }

  void _onEditingComplete() {
    // TODO uncomment and finish
    // _skipOnChanged = true;
    // var value = widget.onEditingComplete?.call();
    // _skipOnChanged = false;
    // widget.formManager.onFieldChanged(widget.keyString, value);
  }
}
