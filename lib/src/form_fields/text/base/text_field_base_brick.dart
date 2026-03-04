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
  void _fillInitialInput(I? initialInput);

  @override
  void initState() {
    super.initState();

    // TODO this strips the field from flutter's restoration - implement restoration pattern as in comments at the end of this file
    _fillInitialInput(formManager.getInitialInput(keyString));
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

  void _onChanged(_) {
    onInputChanged(_getInput(), defaultValue);
  }

  var _skipOnChanged = false;

  @mustCallSuper
  @override
  I? onInputChanged(I? input, V? defaultValue) {
    // Stop infinite call here at changing the field value to trimmed one
    if (_skipOnChanged) return null;

    // Here FormManager:
    // - validates the input and shows error message
    // - formats the input and returns formatted input text in TextEditingValue
    // - saves results of format-validation in FormData -> FormFieldData -> FieldContent
    I? formattedInput = super.onInputChanged(input, defaultValue);

    // draw formatted input in UI
    if (widget.validateMode == ValidateModeBrick.onChange) _updateUi(formattedInput);

    // Run custom onChanged callback if provided
    widget.onChanged?.call(input!);

    return null;
  }

  @mustCallSuper
  void _onEditingComplete() {
    // Here FormManager:
    // - validates the input and shows error message
    // - formats the input and returns formatted input text in TextEditingValue
    // - saves results of format-validation in FormData -> FormFieldData -> FieldContent
    I? formattedValue = super.onInputChanged(_getInput(), defaultValue);

    // draw formatted input in UI
    if (widget.validateMode == ValidateModeBrick.onEditingComplete) _updateUi(formattedValue);

    // Run custom onEditingComplete callback if provided
    widget.onEditingComplete?.call();
  }

  void _updateUi(I? formattedValue) {
    _skipOnChanged = true;
    setState(() => _setInput(formattedValue));
    _skipOnChanged = false;
  }

  I? _getInput();

  void _setInput(I? formattedValue);
}

// RESTORATION PATTERN
//===========================
// // lib/src/form_fields/text/text_input_base/text_field_state_brick.dart
// import 'package:flutter/material.dart';
//
// /// Pattern: state-restorable controller for TextFieldBrick.
// /// - Uses RestorableTextEditingController when widget.controller is NOT injected.
// /// - If widget.controller is injected, we use it directly (non-restorable, external ownership).
// /// - On first init (or restore), we hydrate from FormManager initial input.
// /// - On changes, we push TextEditingValue back to FormManager.
// ///
// /// Assumptions:
// /// - TextFieldBrick has: keyString, formManager, controller?, restorationId? (optional)
// /// - formManager exposes: getInitialInput(keyString) -> String?
// /// - formManager exposes: onTextEditingValueChanged(keyString, TextEditingValue)
// mixin _FormManagerTextSync {
//   void pushToManager(String keyString, dynamic formManager, TextEditingValue v) {
//     // Adapt to your API:
//     // e.g. formManager.onFieldChangedTextValue(keyString, v);
//     formManager.onTextEditingValueChanged(keyString, v);
//   }
// }
//
// class TextFieldBrick extends StatefulWidget {
//   final String keyString;
//   final dynamic formManager;
//
//   /// If provided, caller owns lifecycle and restoration is caller’s responsibility.
//   final TextEditingController? controller;
//
//   /// Optional: enables restoration for this field when using internal controller.
//   /// If null, restoration still works if your State uses restorationId in the widget tree,
//   /// but having a stable id per-field is recommended.
//   final String? restorationId;
//
//   const TextFieldBrick({
//     super.key,
//     required this.keyString,
//     required this.formManager,
//     this.controller,
//     this.restorationId,
//   });
//
//   @override
//   State<TextFieldBrick> createState() => _TextFieldBrickState();
// }
//
// class _TextFieldBrickState extends State<TextFieldBrick> with RestorationMixin, _FormManagerTextSync {
//   // Only used when widget.controller == null.
//   final RestorableTextEditingController _restorableController = RestorableTextEditingController();
//
//   // Cached listener so we can remove it safely.
//   VoidCallback? _listener;
//
//   // Whether we hydrated from manager at least once (avoid reapplying after user types).
//   bool _didHydrate = false;
//
//   TextEditingController get _controller =>
//       widget.controller ?? _restorableController.value;
//
//   @override
//   String? get restorationId {
//     // Tie to widget-provided id if given; else leave null (no restoration for this subtree).
//     // In a form, you usually want something stable like:
//     //   '${widget.formManager.formId}.${widget.keyString}'
//     return widget.restorationId;
//   }
//
//   @override
//   void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
//     if (widget.controller == null && restorationId != null) {
//       registerForRestoration(_restorableController, 'text_controller');
//     }
//     // After restoration attaches, hydrate initial input if needed.
//     _hydrateInitialIfNeeded();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _attachListener();
//     // If restoration is disabled (restorationId == null) we still want to hydrate once.
//     WidgetsBinding.instance.addPostFrameCallback((_) => _hydrateInitialIfNeeded());
//   }
//
//   @override
//   void didUpdateWidget(covariant TextFieldBrick oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.controller != widget.controller) {
//       _detachListener(oldWidget.controller ?? _restorableController.value);
//       _attachListener();
//       // On controller swap, re-hydrate if we haven't yet.
//       _didHydrate = false;
//       WidgetsBinding.instance.addPostFrameCallback((_) => _hydrateInitialIfNeeded());
//     }
//   }
//
//   void _attachListener() {
//     final c = _controller;
//     _listener = () => pushToManager(widget.keyString, widget.formManager, c.value);
//     c.addListener(_listener!);
//   }
//
//   void _detachListener(TextEditingController c) {
//     final l = _listener;
//     if (l != null) c.removeListener(l);
//     _listener = null;
//   }
//
//   void _hydrateInitialIfNeeded() {
//     if (!mounted || _didHydrate) return;
//
//     final initial = widget.formManager.getInitialInput(widget.keyString) as String?;
//     if (initial == null) {
//       _didHydrate = true;
//       return;
//     }
//
//     final c = _controller;
//
//     // Only set if controller is "empty" to avoid wiping restored/user state.
//     if (c.text.isEmpty) {
//       c.value = TextEditingValue(
//         text: initial,
//         selection: TextSelection.collapsed(offset: initial.length),
//         composing: TextRange.empty,
//       );
//     }
//
//     _didHydrate = true;
//   }
//
//   @override
//   void dispose() {
//     _detachListener(_controller);
//     // Only dispose the restorable controller; injected controller belongs to caller.
//     _restorableController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: _controller, // IMPORTANT: prevents TextField from creating its own
//       restorationId: widget.restorationId, // optional; can be null
//       onChanged: (_) {
//         // Optional: if you already listen to controller, you may not need this.
//         // Keeping it empty avoids double updates.
//       },
//     );
//   }
// }
