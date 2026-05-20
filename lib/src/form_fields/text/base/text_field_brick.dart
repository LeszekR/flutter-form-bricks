import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/decoration/outline_sides_input_border.dart';
import 'package:flutter_form_bricks/src/form_fields/components/decoration/underline_top_rounded_input_border.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/compound_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/labelled_box.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_config.dart';

enum TextFieldBorderType { outline, underline, other }

abstract class TextFieldBrick<V extends Object> extends FormFieldBrick<TextEditingValue, V> {
  final double? width;

  // TODO docs for all my params added to flutter API
  final TextFieldConfig textFieldConfig;
  final InputDecoration? inputDecoration;
  final ErrorPosition errorPosition;
  final TextFieldButtonConfig? buttonConfig;
  final TextFieldBorderType textFieldBorderType;
  final double? height;

  TextFieldBrick({
    super.key,
    //
    // FormFieldBrick
    required super.keyString,
    required super.formManager,
    required super.validateMode,
    super.outerLabelConfig,
    super.statesController,
    //
    // TextFieldBrick
    this.width,
    this.inputDecoration,
    this.errorPosition = ErrorPosition.dynamicSpaceBelowField,
    this.buttonConfig,
    this.textFieldBorderType = TextFieldBorderType.outline,
    this.height,
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
    // WidgetStatesController? statesController,  => moved to FormFieldBrick
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
    bool? selectAllOnFocus = false,
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
        assert(
          (outerLabelConfig != null ? 1 : 0) +
                  (inputDecoration?.label != null ? 1 : 0) +
                  (inputDecoration?.labelText != null ? 1 : 0) <=
              1,
          'Only one can be declared: outerLabel, outerLabelText, inputDecoration.label, or inputDecoration.labelText ',
        ),
        assert(
          (inputDecoration?.suffix != null ? 1 : 0) +
                  (inputDecoration?.suffixText != null ? 1 : 0) +
                  (inputDecoration?.suffixIcon != null ? 1 : 0) +
                  ((buttonConfig?.buttonPosition == ButtonPosition.right) ? 1 : 0) <=
              1,
          'Only one can be declared: textFieldButtonConfig.buttonPosition.right, '
          'inputDecoration.suffix, inputDecoration.suffixText, or inputDecoration.suffixIcon.',
        ),
        assert(
          (inputDecoration?.prefix != null ? 1 : 0) +
                  (inputDecoration?.prefixText != null ? 1 : 0) +
                  (inputDecoration?.prefixIcon != null ? 1 : 0) +
                  ((buttonConfig?.buttonPosition == ButtonPosition.left) ? 1 : 0) <=
              1,
          'Only one can be declared: textFieldButtonConfig.buttonPosition.left, '
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
        assert(inputDecoration == null || textFieldBorderType == TextFieldBorderType.other,
            'When inputDecoration is not null, textFieldBorderType must be TextFieldBorderType.other'),
        assert(buttonConfig?.syncStyleWithTextField == true ? statesController == null : true,
            'When syncStyleWithTextField is true, statesController must not be declared'),
        assert(buttonConfig == null ? statesController == null : true,
            'When buttonConfig is declared then statesController must not be declared, because it will be ignored'),
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
          statesController: statesController,
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
  @visibleForTesting
  late final TextEditingController textEditingController;

  late double _width;
  late double _height;
  late TextStyle _style;
  late final CompoundWidgetStatesController? _compoundWidgetStatesController;
  late final WidgetStatesController? _statesController;
  TextEditingValue? oldValue;

  // String? errorText;

  void onButtonTap() => throw UnimplementedError('onButtonTap not implemented');

  ///  Inheriting fields can override this method to set their default width.
  double getWidth(AppSize appSize) => appSize.textFieldWidth;

  @override
  TextEditingValue? getInput() => textEditingController.value;

  @override
  void setInput(TextEditingValue? formattedValue) =>
      textEditingController.value = formattedValue ?? TextEditingValue.empty;

  @override
  void initState() {
    // must be called before super.initState()
    textEditingController = widget.textFieldConfig.controller ?? TextEditingController();

    // uses textEditingController, sets focusNode
    super.initState();

    // must be called after super.initState()
    focusNode.addListener(_onFocusChange);

    if (widget.buttonConfig?.syncStyleWithTextField == true) {
      _compoundWidgetStatesController = CompoundWidgetStatesController();
      _statesController = null;
      _compoundWidgetStatesController!.fieldStatesSink.setError(errorText != null && errorText!.isNotEmpty);
    } else {
      _compoundWidgetStatesController = null;
      _statesController = widget.textFieldConfig.statesController ?? WidgetStatesController();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var uiParams = UiParams.of(context);
    var appSize = uiParams.appSize;
    _style = widget.textFieldConfig.style ?? uiParams.appTheme.textStyle();

    _height = widget.height != null ? widget.height! : appSize.textFieldHeight;

    if (widget.width != null) {
      _width = widget.width! * appSize.zoom;
    } else {
      _width = getWidth(appSize);
    }
  }

  @override
  void dispose() {
    if (widget.textFieldConfig.controller == null) textEditingController.dispose();
    if (widget.textFieldConfig.statesController == null) _statesController?.dispose();
    _compoundWidgetStatesController?.dispose();
    focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget buildFieldWidget(BuildContext context) {
    if (_compoundWidgetStatesController == null) {
      final decoration = _makeInputDecoration(UiParams.of(context), _getStates());

      final TextField textField = _makeTextField(
        textEditingController,
        decoration,
        _style,
      );

      return LabelledBox(
        fieldBody: textField,
        width: _width,
        height: _height,
        outerLabelConfig: widget.outerLabelConfig,
        buttonConfig: widget.buttonConfig,
        textFieldBorderType: widget.textFieldBorderType,
        targetFocusNode: focusNode,
        compoundWidgetStatesController: _compoundWidgetStatesController,
        onButtonTap: onButtonTap,
      );
    } else {
      return CompoundWidgetStatesController.wrapWithStateDetectors(
        _compoundWidgetStatesController!.fieldStatesSink,
        focusNode,
        AnimatedBuilder(
          animation: _compoundWidgetStatesController!,
          builder: (context, _) {
            final decoration = _makeInputDecoration(UiParams.of(context), _compoundWidgetStatesController!.states);
            final textField = _makeTextField(textEditingController, decoration, _style);

            return LabelledBox(
              fieldBody: textField,
              width: _width,
              height: _height,
              outerLabelConfig: widget.outerLabelConfig,
              buttonConfig: widget.buttonConfig,
              textFieldBorderType: widget.textFieldBorderType,
              targetFocusNode: focusNode,
              compoundWidgetStatesController: _compoundWidgetStatesController,
              onButtonTap: onButtonTap,
            );
          },
        ),
      );
    }
  }

  TextField _makeTextField(
    TextEditingController controller,
    InputDecoration decoration,
    TextStyle style,
  ) {
    return TextField(
      groupId: widget.textFieldConfig.groupId,
      controller: controller,
      focusNode: widget.buttonConfig == null ? focusNode : null,
      // focus node becomes parent when button is present
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
      statesController: _statesController,
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

  InputDecoration _makeInputDecoration(UiParamsData uiParams, Set<WidgetState>? states) {
    // TODO support errorWidget
    bool showErrorBelowText = false ||
        widget.errorPosition == ErrorPosition.dynamicSpaceBelowField ||
        widget.errorPosition == ErrorPosition.fixedSpaceBelowField;
    final TextStyle? errorStyle = showErrorBelowText ? null : TextStyle(fontSize: 0);

    Color? fillColor = uiParams.appColor.getFillColor(states);

    InputBorder? border = _makeInputDecorationBorder(uiParams, states);

    InputDecoration? decoration = widget.textFieldConfig.decoration;

    var appSize = uiParams.appSize;
    double zoom = appSize.zoom;

    if (decoration != null) {
      return decoration.copyWith(
        errorText: errorText,
        errorStyle: errorStyle,
        fillColor: fillColor,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        disabledBorder: border,
        contentPadding: decoration.contentPadding ?? EdgeInsets.symmetric(
          horizontal: appSize.inputDecorationPaddingHorizontal * zoom,
          vertical: appSize.inputDecorationPaddingVertical * zoom,
        ),
      );
    } else {
      return InputDecoration(
        errorText: errorText,
        errorStyle: errorStyle,
        fillColor: fillColor,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        disabledBorder: border,
        contentPadding: EdgeInsets.symmetric(
          horizontal: appSize.inputDecorationPaddingHorizontal * zoom,
          vertical: appSize.inputDecorationPaddingVertical * zoom,
        ),
      );
    }
  }

  Set<WidgetState>? _getStates() {
    if (_compoundWidgetStatesController != null) {
      _compoundWidgetStatesController!.fieldStatesSink.setError(errorText != null && errorText!.isNotEmpty);
      return _compoundWidgetStatesController!.states;
    } else {
      _statesController!.update(WidgetState.error, errorText != null && errorText!.isNotEmpty);
      return _statesController!.value;
    }
  }

  InputBorder? _makeInputDecorationBorder(UiParamsData uiParams, Set<WidgetState>? states) {
    BorderSide borderSide = BorderSide(
      color: uiParams.appColor.getBorderColor(states, uiParams.appColor.borderEnabled),
      width: uiParams.appSize.getBorderWidth(states, uiParams.appSize.borderWidth),
    );

    if (widget.buttonConfig == null) {
      return switch (widget.textFieldBorderType) {
        TextFieldBorderType.outline => OutlineInputBorder(),
        TextFieldBorderType.underline => UnderlineInputBorder(),
        TextFieldBorderType.other => null,
      };
    } else {
      return switch (widget.textFieldBorderType) {
        TextFieldBorderType.outline => switch (widget.buttonConfig!.buttonPosition) {
            ButtonPosition.left => OutlineSidesInputBorder(borderSide: borderSide, sideLeft: false),
            ButtonPosition.right => OutlineSidesInputBorder(borderSide: borderSide, sideRight: false),
          },
        TextFieldBorderType.underline => switch (widget.buttonConfig!.buttonPosition) {
            ButtonPosition.left => UnderlineTopRoundedInputBorder(borderSide: borderSide, radiusTopLeft: 0),
            ButtonPosition.right => UnderlineTopRoundedInputBorder(borderSide: borderSide, radiusTopRight: 0),
          },
        TextFieldBorderType.other => null,
      };
    }
  }

  bool _skipOnChanged = false;

  @mustCallSuper
  @override
  FieldContent<TextEditingValue, V>? onInputChanged([TextEditingValue? input]) {
    // Stop infinite call here at changing the field value to formatted one
    if (_skipOnChanged) return null;

    if (widget.validateMode != ValidateModeBrick.onChange) return null;

    // Here FormManager does the following:
    // - validates the input and shows error message
    // - formats the input and returns formatted input text in TextEditingValue
    // - saves results of format and validation in FormData -> FormFieldData -> FieldContent
    FieldContent<TextEditingValue, V> fieldContent = super.onInputChanged(input)!;

    // draw formatted input in UI
    _updateUi(fieldContent);

    // Run custom onChanged callback if provided
    widget.onChanged?.call(getInput()!);

    return null;
  }

  @mustCallSuper
  void onEditingComplete([TextEditingValue? input]) {
    if (widget.validateMode != ValidateModeBrick.onEditingComplete) return;

    // Here FormManager:
    // - validates the input and shows error message
    // - formats the input and returns formatted input text in TextEditingValue
    // - saves results of format-validation in FormData -> FormFieldData -> FieldContent
    FieldContent<TextEditingValue, V> fieldContent = super.onInputChanged(input)!;

    // draw formatted input in UI
    _updateUi(fieldContent);

    // Run custom onEditingComplete callback if provided
    widget.textFieldConfig.onEditingComplete?.call();
  }

  void _onFocusChange() {
    if (!focusNode.hasFocus) {
      if (textEditingController.value != oldValue) {
        oldValue = textEditingController.value;
        onEditingComplete(textEditingController.value);
      }
    }
  }

  void _updateUi(FieldContent<TextEditingValue, V> fieldContent) {
    _skipOnChanged = true;
    setState(() {
      errorText = fieldContent.error;
      setInput(fieldContent.input);
      bool isError = errorText != null && errorText!.isNotEmpty;
      if (_compoundWidgetStatesController != null) _compoundWidgetStatesController!.fieldStatesSink.setError(isError);
    });
    _skipOnChanged = false;
  }
}
