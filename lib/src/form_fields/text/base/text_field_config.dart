import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldConfig {
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
  final bool? autocorrect;
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
  final VoidCallback? onChanged;
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
  final BoxHeightStyle? selectionHeightStyle;
  final BoxWidthStyle? selectionWidthStyle;
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

  TextFieldConfig({
    // TextField
    this.groupId = EditableText,
    this.controller,
    this.focusNode,
    this.undoController,
    this.decoration = const InputDecoration(),
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
    this.onChanged,
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
