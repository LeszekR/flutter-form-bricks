import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_decorated_box.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_button.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_config.dart';

abstract class TextFieldBrick<V extends Object> extends FormFieldBrick<TextEditingValue, V> {
  final double? width;
  final TextFieldConfig textFieldConfig;
  final InputDecoration? inputDecoration;
  final OuterLabelConfig? outerLabelConfig;
  final TextFieldButtonConfig? textFieldButtonConfig;

  TextFieldBrick({
    super.key,
    //
    // FormFieldBrick
    required super.keyString,
    required super.formManager,
    required super.validateMode,
    super.colorMaker,
    super.statesController,
    //
    // TextFieldBrick
    this.width,
    this.inputDecoration,
    this.outerLabelConfig,
    this.textFieldButtonConfig,    
    //
    // Flutter TextField
    TextMagnifierConfiguration? magnifierConfiguration,
    Object groupId = EditableText,
    TextEditingController? controller,
    FocusNode? focusNode,
    // InputDecoration? decoration,  => replaced with decorationBrick
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
  })  : assert((expands == true) != (maxLines != null || minLines != null,),
            'TextFieldBrick: when expands is true, both maxLines and minLines must be null'),
        // assert((decorationBrick?.textFieldButtonConfig == null) == (decorationBrick?.buttonPosition == null),
        //     'buttonConfig and buttonPosition must be declared together or both be null'),
        assert(
        (outerLabelConfig != null ? 1 : 0) +
            (inputDecoration?.label != null ? 1 : 0) +
            (inputDecoration?.labelText != null ? 1 : 0) <= 1,
        'Only one can be declared: outerLabel, outerLabelText, inputDecoration.label, or inputDecoration.labelText ',
        ),
        assert(
        (inputDecoration?.suffix != null ? 1 : 0) +
            (inputDecoration?.suffixText != null ? 1 : 0) +
            (inputDecoration?.suffixIcon != null ? 1 : 0) +
            ((textFieldButtonConfig?.buttonSide == ButtonSide.right) ? 1 : 0) <= 1,
        'Only one can be declared: textFieldButtonConfig.buttonSide.right, '
            'inputDecoration.suffix, inputDecoration.suffixText, or inputDecoration.suffixIcon.',
        ),
        assert(
        (inputDecoration?.prefix != null ? 1 : 0) +
            (inputDecoration?.prefixText != null ? 1 : 0) +
            (inputDecoration?.prefixIcon != null ? 1 : 0) +
            ((textFieldButtonConfig?.buttonSide == ButtonSide.left) ? 1 : 0) <= 1,
        'Only one can be declared: textFieldButtonConfig.buttonSide.left, '
            'inputDecoration.prefix, inputDecoration.prefixText, or inputDecoration.prefixIcon.',
        ),
        assert(
        inputDecoration?.error == null || inputDecoration?.errorText == null,
        'Only one can be declared: inputDecoration.error or inputDecoration.errorText.',
        ),
        assert(
        inputDecoration?.hint == null || inputDecoration?.hintText == null,
        'Only one can be declared: inputDecoration.hint or inputDecoration.hintText.',
        ),
        assert(
        inputDecoration?.helper == null || inputDecoration?.helperText == null,
        'Only one can be declared: inputDecoration.helper or inputDecoration.helperText.',
        ),
        assert(
        inputDecoration?.counter == null || inputDecoration?.counterText == null,
        'Only one can be declared: inputDecoration.counter or inputDecoration.counterText.',
        ),
        assert(
        inputDecoration?.prefix == null || inputDecoration?.prefixText == null,
        'Only one can be declared: inputDecoration.prefix or inputDecoration.prefixText.',
        ),
        assert(
        inputDecoration?.suffix == null || inputDecoration?.suffixText == null,
        'Only one can be declared: inputDecoration.suffix or inputDecoration.suffixText.',
        ),
        textFieldConfig = TextFieldConfig(
          magnifierConfiguration: magnifierConfiguration,
          groupId: groupId,
          controller: controller,
          focusNode: focusNode,
          decoration: inputDecoration,
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
  late final WidgetStatesController statesController;
  late final VoidCallback _statesListener;
  late final TextFieldButton? button;
  late double width;
  late TextStyle style;
  String? _errorText;

  @override
  TextEditingValue? getInput() => controller.value;

  @override
  void setInput(TextEditingValue? formattedValue) => controller.value = formattedValue ?? TextEditingValue.empty;

  @override
  void initState() {
    // TODO this strips the field from flutter's restoration - implement restoration pattern as in comments at the end of this file
    statesController = widget.textFieldConfig.statesController ?? WidgetStatesController();
    controller = widget.textFieldConfig.controller ?? TextEditingController();

    setInput(formManager.getInitialInput(keyString));
    _errorText = formManager.getFieldError(keyString);
    super.initState();

    button = widget.textFieldButtonConfig == null
        ? null
        : TextFieldButton(textFieldButtonConfig: widget.textFieldButtonConfig!);

    _statesListener = () {
      if (formUiUpdateCoordinator != null) {
        formUiUpdateCoordinator!.requestRefresh();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
      }
    };
    statesController.addListener(_statesListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var uiParams = UiParams.of(context);
    style = widget.textFieldConfig.style ?? uiParams.appTheme.textStyle();
    width = widget.width ?? uiParams.appSize.textFieldWidth;
  }

  @override
  void dispose() {
    if (widget.textFieldConfig.controller == null) controller.dispose();
    if (widget.textFieldConfig.focusNode == null) focusNode.dispose();
    statesController.removeListener(_statesListener);
    statesController.dispose();
    super.dispose();
  }

  @override
  Widget buildFieldWidget(BuildContext context) {
    var uiParams = UiParams.of(context);

    final decoration = _makeInputDecorationWithButton(_errorText);

    final TextField textField = _makeTextField(
      controller,
      statesController,
      decoration,
      style,
    );

    return TextFieldDecoratedBox(
      uiParamsData: uiParams,
      outerLabelConfig: widget.outerLabelConfig,
      width: width,
      textField: textField,
    );
  }

  TextField _makeTextField(
    TextEditingController controller,
    WidgetStatesController statesController,
    InputDecoration decoration,
    TextStyle style,
  ) {
    return TextField(
      groupId: widget.textFieldConfig.groupId,
      controller: controller,
      focusNode: focusNode,
      undoController: widget.textFieldConfig.undoController,
      decoration: decoration,
      keyboardType: widget.textFieldConfig.keyboardType,
      textInputAction: widget.textFieldConfig.textInputAction,
      textCapitalization: widget.textFieldConfig.textCapitalization,
      style: style,
      strutStyle: widget.textFieldConfig.strutStyle,
      textAlign: widget.textFieldConfig.textAlign,
      textAlignVertical: widget.textFieldConfig.textAlignVertical,
      textDirection: widget.textFieldConfig.textDirection,
      readOnly: widget.textFieldConfig.readOnly,
      // Deprecated: toolbarOptions - not used
      showCursor: widget.textFieldConfig.showCursor,
      // autofocus: widget.config.autofocus,
      statesController: statesController,
      obscuringCharacter: widget.textFieldConfig.obscuringCharacter,
      obscureText: widget.textFieldConfig.obscureText,
      autocorrect: widget.textFieldConfig.autocorrect,
      smartDashesType: widget.textFieldConfig.smartDashesType,
      smartQuotesType: widget.textFieldConfig.smartQuotesType,
      enableSuggestions: widget.textFieldConfig.enableSuggestions,
      maxLines: widget.textFieldConfig.maxLines,
      minLines: widget.textFieldConfig.minLines,
      expands: widget.textFieldConfig.expands,
      maxLength: widget.textFieldConfig.maxLength,
      maxLengthEnforcement: widget.textFieldConfig.maxLengthEnforcement,
      onChanged: (_) => onInputChanged(),
      onEditingComplete: onEditingComplete,
      onSubmitted: widget.textFieldConfig.onSubmitted,
      onAppPrivateCommand: widget.textFieldConfig.onAppPrivateCommand,
      inputFormatters: widget.textFieldConfig.inputFormatters,
      enabled: widget.textFieldConfig.enabled,
      /// ignorePointers tells the TextField to ignore pointer events (taps, clicks, drags) for hit-testing. That means:
      /// user taps won’t focus it, selection/handles won’t respond, mouse interactions won’t apply.
      /// It’s different from / enabled: false / readOnly: true: enabled: false also affects styling and semantics like
      /// a disabled control. / readOnly: true still allows focus/selection/copy in many cases. ignorePointers: true is a
      /// blunt “don’t react to / pointer input” switch.
      /// You’d use it for “overlay intercepts touches”, or when the field / is visually shown but / interaction is
      /// controlled elsewhere.
      ignorePointers: widget.textFieldConfig.ignorePointers,
      cursorWidth: widget.textFieldConfig.cursorWidth,
      cursorHeight: widget.textFieldConfig.cursorHeight,
      cursorRadius: widget.textFieldConfig.cursorRadius,
      cursorOpacityAnimates: widget.textFieldConfig.cursorOpacityAnimates,
      cursorColor: widget.textFieldConfig.cursorColor,
      cursorErrorColor: widget.textFieldConfig.cursorErrorColor,
      selectionHeightStyle: widget.textFieldConfig.selectionHeightStyle,
      selectionWidthStyle: widget.textFieldConfig.selectionWidthStyle,
      keyboardAppearance: widget.textFieldConfig.keyboardAppearance,
      scrollPadding: widget.textFieldConfig.scrollPadding,
      dragStartBehavior: widget.textFieldConfig.dragStartBehavior,
      enableInteractiveSelection: widget.textFieldConfig.enableInteractiveSelection,
      selectAllOnFocus: widget.textFieldConfig.selectAllOnFocus,
      selectionControls: widget.textFieldConfig.selectionControls,
      onTap: widget.textFieldConfig.onTap,
      onTapAlwaysCalled: widget.textFieldConfig.onTapAlwaysCalled,
      onTapOutside: widget.textFieldConfig.onTapOutside,
      onTapUpOutside: widget.textFieldConfig.onTapUpOutside,
      mouseCursor: widget.textFieldConfig.mouseCursor,
      buildCounter: widget.textFieldConfig.buildCounter,
      scrollController: widget.textFieldConfig.scrollController,
      scrollPhysics: widget.textFieldConfig.scrollPhysics,
      autofillHints: widget.textFieldConfig.autofillHints,
      contentInsertionConfiguration: widget.textFieldConfig.contentInsertionConfiguration,
      clipBehavior: widget.textFieldConfig.clipBehavior,
      restorationId: widget.textFieldConfig.restorationId,
      // Deprecated: scribbleEnabled - not used
      stylusHandwritingEnabled: widget.textFieldConfig.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: widget.textFieldConfig.enableIMEPersonalizedLearning,
      contextMenuBuilder: widget.textFieldConfig.contextMenuBuilder,
      canRequestFocus: widget.textFieldConfig.canRequestFocus,
      spellCheckConfiguration: widget.textFieldConfig.spellCheckConfiguration,
      magnifierConfiguration: widget.textFieldConfig.magnifierConfiguration,
      hintLocales: widget.textFieldConfig.hintLocales,
    );
  }

  // TODO move helper methods to a singleton

  InputDecoration _makeInputDecorationWithButton(String? errorText) {
    ButtonSide? buttonSide = widget.textFieldButtonConfig?.buttonSide;

    if (widget.textFieldConfig.decoration != null) {
      return widget.textFieldConfig.decoration!.copyWith(
        errorText: errorText,
        fillColor: makeColor(),
        prefixIcon: buttonSide == null || buttonSide == ButtonSide.right
            ? widget.textFieldConfig.decoration?.prefixIcon
            : button,
        suffixIcon: buttonSide == null || buttonSide == ButtonSide.left
            ? widget.textFieldConfig.decoration?.prefixIcon
            : button,
      );
    } else {
      return InputDecoration(
        errorText: errorText,
        fillColor: makeColor(),
        prefixIcon: buttonSide == ButtonSide.left ? button : null,
        suffixIcon: buttonSide == ButtonSide.right ? button : null,
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
    widget.textFieldConfig.onEditingComplete?.call();
  }

  void _updateUi(FieldContent<TextEditingValue, V> fieldContent) {
    _skipOnChanged = true;
    setState(() {
      setInput(fieldContent.input);
      _errorText = fieldContent.error;
    });
    _skipOnChanged = false;
  }
}
