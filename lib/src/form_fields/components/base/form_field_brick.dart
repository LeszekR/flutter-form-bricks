import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/components/labelled_box/label_position.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/states_color_maker.dart';
import 'package:flutter_form_bricks/src/forms/base/form_ui_update_coordinator.dart';
import 'package:flutter_form_bricks/src/forms/base/form_ui_update_scope.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

abstract class FormFieldBrick<I extends Object, V extends Object> extends StatefulWidget {
  final String keyString;

  final FormManager formManager;
  final StatesColorMaker colorMaker;
  final WidgetStatesController? statesObserver;
  final WidgetStatesController? statesNotifier;
  final ValueChanged<I>? onChanged;
  final String? label;
  final LabelPosition labelPosition;

  // TODO implement identical functionality as in flutter_form_builder using onChange, onEditingComplete, onSave
  final ValidateModeBrick validateMode;

  FormFieldBrick({
    Key? key,
    required this.keyString,
    // TODO add field label, required if has validator so FormManager shows error for a named field
    required this.formManager,
    required this.validateMode,
    this.label,
    this.labelPosition = LabelPosition.topLeft,
    StatesColorMaker? colorMaker,
    // TODO verify / test / fix passing-using ststesObserver - note: TextFieldBrick costructs it INSIDE - bug?
    this.statesObserver,
    this.statesNotifier,
    this.onChanged,
  })  : this.colorMaker = colorMaker ?? StatesColorMaker(),
        super(key: key ?? ValueKey(keyString));
}

abstract class FormFieldStateBrick<I extends Object, V extends Object, F extends FormFieldBrick<I, V>>
    extends State<F> {
  FormUiUpdateCoordinator? formUiUpdateCoordinator;

  Set<WidgetState>? _states;

  I? getInput();

  void setInput(I? formattedValue);

  Widget buildFieldWidget(BuildContext context);

  /// Value of the field saved in `FieldData` and used on form save when the field has no
  /// `FormatterValidator` (which otherwise provides formatted value).
  V? get defaultValue;

  /// Object holding state of this `FormFieldBrick`. Fetched from `FormManager` prior to `build()`
  /// and updated in `setState()`;
  late I? _input;

  /// Controls the field's color and is passed to `InputDecoration` if the field shows its error this way.
  String? _error;

  late final FocusNode focusNode;

  FormManager get formManager => widget.formManager;

  String get keyString => widget.keyString;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FormUiUpdateScope.of(context),
      builder: (context, _) =>  buildFieldWidget(context),
    );
  }

  @mustCallSuper
  @override
  void initState() {
    formManager.registerField<F>(keyString, _hasFormatterValidator());

    focusNode = FocusNode();
    formManager.setFocusListener(focusNode, keyString);

    _input = formManager.getFieldContent(keyString).input as I?;

    // _states = widget.statesNotifier?.value;
    _onStatesChanged();
    widget.statesNotifier?.addListener(_onStatesChanged);

    if (formManager.isFocusedOnStart(keyString)) focusNode.requestFocus();

    // TODO this strips the field from flutter's restoration - implement restoration pattern as in comments at the end of this file
    setInput(formManager.getInitialInput(keyString));

    super.initState();
  }

  @mustCallSuper
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formUiUpdateCoordinator = FormUiUpdateScope.of(context);
  }

  @mustCallSuper
  @override
  void dispose() {
    widget.statesNotifier?.removeListener(_onStatesChanged);
    focusNode.dispose();
    super.dispose();
  }

  void _onStatesChanged() {
    setState(() {
      _states = widget.statesNotifier?.value;
    });
  }

  /// **Must be called** either in `onChanged` or `onEditingComplete`. If not called there neither of the below
  /// functions will be performed.
  /// ---
  /// Makes `FormManager`:
  /// - format the input
  /// - validate the input
  /// - register both new value and error in `FormManager` -> `FormStateBrick` -> `FieldContent`
  /// - return new `FieldContent` which then sets the field's input (if formatted), controls its color,
  ///   displays error if the field uses `InputDecoration` for this (error alternatively it can be displayed in
  ///   dedicated `FormBrick` area by `FormManager`).
  @mustCallSuper
  FieldContent<I, V>? onInputChanged() {
    // Here FormManager:
    // - validates the input
    // - saves results of format and validation in FormData -> FormFieldData -> FieldContent
    return formManager.onFieldChanged<I, V>(BricksLocalizations.of(context), keyString, getInput(), defaultValue);
  }

  bool _hasFormatterValidator() => widget.validateMode != ValidateModeBrick.noValidator;

  Color? makeColor() => widget.colorMaker.makeColor(context, _states);
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
