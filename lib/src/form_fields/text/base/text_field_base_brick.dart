import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/states_controller/double_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/components/states_controller/update_once_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/state_colored_icon_button.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_bordered_box.dart';

abstract class TextFieldBaseBrick<I extends Object, V extends Object> extends FormFieldBrick<I, V> {
  // // TextFieldBrick
  // final double? width;
  final IconButtonParams? buttonParams;
  //
  // Flutter TextField
  final TextMagnifierConfiguration? magnifierConfiguration;
  final Object groupId;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;

  // TODO set constant for Datefield - number or datetime
  final TextInputType? keyboardType;

  // TODO set TextInputAction.newline? in multiline fields? Or it will be default there?
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;

  // final bool autofocus; => FormData takes over initial focus in form
  // final MaterialStatesController? statesController; => replaced with statesObserver and statesNotifier
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;

  // TODO turn off and lock it for strictly formatting fields like DateField
  final SmartDashesType? smartDashesType;

  // TODO turn off and lock it for strictly formatting fields like DateField
  final SmartQuotesType? smartQuotesType;

  // TODO turn off and lock it for strictly formatting fields like DateField
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  final bool? showCursor;
  static const int noMaxLength = -1;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
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

  // TODO turn off and lock it for strictly formatting fields like DateField
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final bool canRequestFocus;
  final UndoHistoryController? undoController;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final List<Locale>? hintLocales;

  TextFieldBaseBrick({
    super.key,
    //
    // TextFieldBaseBrick
    this.buttonParams,
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
    // TextField
    this.groupId = EditableText,
    this.controller,
    this.focusNode,
    this.undoController,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    // TODO use instead of formatter-validator first-upper-then-lower
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    // TODO set constant for Datefield
    this.textAlign = TextAlign.start,
    // TODO set constant for Datefield
    this.textAlignVertical,
    // TODO set constant for Datefield
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    // this.autofocus = false, => FormData takes over in this
    // this.statesController,  => replaced with statesObserver and statesNotifier
    // TODO remove for all non-password fields
    this.obscuringCharacter = '•',
    // TODO remove for all non-password fields
    this.obscureText = false,
    // TODO remove for all fields where this does not make sense - like DateField etc
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    // TODO lock in fields where multiline makes no sense like DateField etc
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    // TODO implement remaining n showing on the screen maximum allowed “characters” (with caveats re: grapheme clusters); shows a counter by default.
    this.maxLength,
    this.maxLengthEnforcement,
    super.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    // TODO use for our formatter-validators running in onChange now
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
    // TODO use? to implement remaining n showing on the screen of maximum allowed “characters”
    this.buildCounter,
    // TODO lock for single-line fields like DateField
    this.scrollController,
    // TODO lock for single-line fields like DateField
    this.scrollPhysics,
    // TODO NameField (use also capitalisation there, add other fields of similar specialisation):
    this.autofillHints = const <String>[],
    // TODO lock for fields where no content will ever be inserted like DateField
    this.contentInsertionConfiguration,
    // TODO lock for fields where no content will ever be inserted like DateField
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.stylusHandwritingEnabled = EditableText.defaultStylusHandwritingEnabled,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder,
    this.canRequestFocus = true,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.hintLocales,
  });
}

abstract class TextFieldBaseStateBrick<I extends Object, V extends Object, B extends TextFieldBaseBrick<I, V>>
    extends FormFieldStateBrick<I, V, B> {

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

  bool _skipOnChanged = false;

  @mustCallSuper
  @override
  I? onInputChanged() {
    // Stop infinite call here at changing the field value to formatted one
    if (_skipOnChanged) return null;

    // Here FormManager does the following:
    // - validates the input and shows error message
    // - formats the input and returns formatted input text in TextEditingValue
    // - saves results of format and validation in FormData -> FormFieldData -> FieldContent
    I? formattedInput = super.onInputChanged();

    // draw formatted input in UI
    if (widget.validateMode == ValidateModeBrick.onChange) _updateUi(formattedInput);

    // Run custom onChanged callback if provided
    widget.onChanged?.call(getInput()!);

    return null;
  }

  @mustCallSuper
  void onEditingComplete() {
    // Here FormManager:
    // - validates the input and shows error message
    // - formats the input and returns formatted input text in TextEditingValue
    // - saves results of format-validation in FormData -> FormFieldData -> FieldContent
    I? formattedValue = super.onInputChanged();

    // draw formatted input in UI
    if (widget.validateMode == ValidateModeBrick.onEditingComplete) _updateUi(formattedValue);

    // Run custom onEditingComplete callback if provided
    widget.onEditingComplete?.call();
  }

  void _updateUi(I? formattedValue) {
    _skipOnChanged = true;
    setState(() => setInput(formattedValue));
    _skipOnChanged = false;
  }
}
