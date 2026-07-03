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
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_decoration_maker.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_bottom_space_config.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_editing_area_config.dart';

import '../../../ui_params/app_size/text_field_height_resolver/widget_height_probe.dart';

enum TextFieldBorderType { outline, underline, other }

abstract class TextFieldBrick<V extends Object> extends FormFieldBrick<TextEditingValue, V> {
  final double? width;

  // TODO docs for all my params added to flutter API
  /// Contains all params of Flutter's `TextField` which is the inner widget of `TextFieldBrick`.
  /// Some of the params may be turned off - following requirements and features of **FlutterFormBricks**:
  /// See implementation for more details.
  final TextFieldConfig textFieldConfig;

  /// When `textFieldBorderType` is not `TextFieldBorderType.other`, then `inputDecoration.border` must be null, since
  /// the border type will be defined by `textFieldBorderType` (Guarded by assert).
  ///
  /// When `inputDecoration.border` is not null (and `textFieldBorderType` must be `TextFieldBorderType.other` then)
  /// and `buttonConfig` is not null, then `inputDecoration.border` (Fluter's `OutlineInputBorder` or
  /// `UnderlineInputBorder`) will be replaced with its implementation created in `FlutterFormBricks` allowing
  /// for seamless integration with the button (`OutlineSidesInputBorder` or `UnderlineTopRoundedBorder`).
  final InputDecoration? inputDecoration;

  /// If `textFieldBorderType` is `TextFieldBorderType.other`, then
  /// - if `inputDecoration.border` is defined this border will be used
  /// - if `inputDecoration.border` is not defined then `UnderlineInputBorder` will be used as default
  /// (See: `inputDecoration' field docs to understand how it works when the `buttonConfig` is not null.)
  ///
  /// If `textFieldBorderType` is `TextFieldBorderType.outline` or `TextFieldBorderType.underline`,
  /// then `OutlineInputBorder` or `UnderlineInputBorder` (or their `FlutterFormBricks` implementations for use
  /// with `TexFieldButton`: `OutlineSidesInputBorder` or `UnderlineTopRoundedBorder`) will be used.
  final TextFieldBorderType borderType;

  /// See `enum ErrorPosition`. Error can be positioned:
  /// - in Flutter's dynamic space below the field
  /// - in Flutter's fixed space below the field
  /// - in `FlutterFormBricks` error area of `FormBrick` where error of currently focused field is shown; this
  /// solution allows for building dense UIs for professionals, who will use the app on daily basis, where errors do not
  /// take space in the form making it possible to fit more fields on the screen. This functionality works in unison
  /// with marking **red** the border and/or background of every field and tab, that failed validation. The user clicks
  /// such a field or tab and immediately sees the error message in the error area.
  final ErrorPosition errorPosition;

  /// If not `null` it will create button adjoining the `TextFieldBrick` on the left or right. The spacing between the
  /// button and the field can be 0 or more, the style and other properties of the button can be customized in
  /// `TextFieldButtonConfig`.
  final TextFieldButtonConfig? buttonConfig;

  /// Defines the height of the actual `TextField` widget, and the height and width of its `TextFieldButton` if present.
  /// It does not affect the error/helper/counter area of `InputDecoration` - those are added below the defined
  /// `heightOfTextArea`.
  final double? heightOfTextArea;

  /// `Widget` builder to be used when error is to be predefined `Widget` not just text formatted with `errorStyle` in
  /// `inputDecoration`.
  ///
  /// In order to preserve both original Flutter functionality of declaring error `Widget`
  /// and this lib's functionality of automatic filling error text on validation it was necessary to
  /// block native Flutter's `error` declaration in `inputDecoration` and use builder instead.
  /// Other than that the functionality of using `Widget` error is the same.
  final Widget Function(BuildContext context, String errorText)? errorBuilder;

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
    this.borderType = TextFieldBorderType.other,
    this.errorPosition = ErrorPosition.dynamicSpaceBelowField,
    this.buttonConfig,
    this.heightOfTextArea,
    this.errorBuilder,
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
          'Only one can be declared: outerLabel, outerLabelText, inputDecoration.label, or inputDecoration.labelText '
          '(keyString: $keyString)',
        ),
        assert(
          (inputDecoration?.suffix != null ? 1 : 0) +
                  (inputDecoration?.suffixText != null ? 1 : 0) +
                  (inputDecoration?.suffixIcon != null ? 1 : 0) +
                  ((buttonConfig?.buttonPosition == ButtonPosition.right) ? 1 : 0) <=
              1,
          'Only one can be declared: textFieldButtonConfig.buttonPosition.right, '
          'inputDecoration.suffix, inputDecoration.suffixText, or inputDecoration.suffixIcon (keyString: $keyString).',
        ),
        assert(
          (inputDecoration?.prefix != null ? 1 : 0) +
                  (inputDecoration?.prefixText != null ? 1 : 0) +
                  (inputDecoration?.prefixIcon != null ? 1 : 0) +
                  ((buttonConfig?.buttonPosition == ButtonPosition.left) ? 1 : 0) <=
              1,
          'Only one can be declared: textFieldButtonConfig.buttonPosition.left, '
          'inputDecoration.prefix, inputDecoration.prefixText, or inputDecoration.prefixIcon (keyString: $keyString).',
        ),
        assert(
          inputDecoration?.hint == null || inputDecoration?.hintText == null,
          'Only one can be declared: inputDecoration.hint or inputDecoration.hintText (keyString: $keyString).',
        ),
        assert(
          inputDecoration?.helper == null || inputDecoration?.helperText == null,
          'Only one can be declared: inputDecoration.helper or inputDecoration.helperText (keyString: $keyString).',
        ),
        assert(
          inputDecoration?.counter == null || inputDecoration?.counterText == null,
          'Only one can be declared: inputDecoration.counter or inputDecoration.counterText (keyString: $keyString).',
        ),
        assert(
          inputDecoration?.prefix == null || inputDecoration?.prefixText == null,
          'Only one can be declared: inputDecoration.prefix or inputDecoration.prefixText (keyString: $keyString).',
        ),
        assert(
          inputDecoration?.suffix == null || inputDecoration?.suffixText == null,
          'Only one can be declared: inputDecoration.suffix or inputDecoration.suffixText (keyString: $keyString).',
        ),
        assert(inputDecoration?.border == null || borderType == TextFieldBorderType.other,
            'When inputDecoration.border is not null, textFieldBorderType must be TextFieldBorderType.other (keyString: $keyString).'),
        assert(inputDecoration?.disabledBorder == null || borderType == TextFieldBorderType.other,
            'When inputDecoration.disabledBorder is not null, textFieldBorderType must be TextFieldBorderType.other (keyString: $keyString).'),
        assert(inputDecoration?.enabledBorder == null || borderType == TextFieldBorderType.other,
            'When inputDecoration.enabledBorder is not null, textFieldBorderType must be TextFieldBorderType.other (keyString: $keyString).'),
        assert(inputDecoration?.errorBorder == null || borderType == TextFieldBorderType.other,
            'When inputDecoration.errorBorder is not null, textFieldBorderType must be TextFieldBorderType.other (keyString: $keyString).'),
        assert(inputDecoration?.focusedBorder == null || borderType == TextFieldBorderType.other,
            'When inputDecoration.focusedBorder is not null, textFieldBorderType must be TextFieldBorderType.other (keyString: $keyString).'),
        assert(inputDecoration?.focusedErrorBorder == null || borderType == TextFieldBorderType.other,
            'When inputDecoration.focusedErrorBorder is not null, textFieldBorderType must be TextFieldBorderType.other (keyString: $keyString).'),
        assert(buttonConfig?.syncStyleWithTextField == true ? statesController == null : true,
            'When syncStyleWithTextField is true, statesController must not be declared(keyString: $keyString).'),
        assert(buttonConfig == null ? statesController == null : true,
            'When buttonConfig is declared then statesController must not be declared, because it will be ignored (keyString: $keyString).'),
        assert(
          inputDecoration?.error == null && inputDecoration?.errorText == null,
          'Do not declare InputDecoration.error or InputDecoration.errorText. '
          'Validation errors are managed by TextFieldBrick. '
          'Use TextFieldBrick.errorBuilder to customize validation error UI. (keyString: $keyString).',
        ),
        assert(
            (errorPosition == ErrorPosition.never || errorPosition == ErrorPosition.formErrorArea)
                ? errorBuilder == null
                : true,
            'Do not declare errorBuilder when the error is never to be shown below the TextField'),
        assert(errorBuilder != null ? inputDecoration?.errorStyle == null : true,
            'Do not declare errorStyle when errorBuilder is declared'),
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
  late TextStyle _style;
  late final CompoundWidgetStatesController? _compoundWidgetStatesController;
  late final WidgetStatesController? _statesController;
  TextEditingValue? oldValue;
  late final bool _showErrorBelowField;
  late TextFieldEditingAreaConfig editingAreaConfig;
  late TextFieldBottomSpaceConfig bottomSpaceConfig;

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
    _showErrorBelowField = widget.errorPosition == ErrorPosition.dynamicSpaceBelowField ||
        widget.errorPosition == ErrorPosition.fixedSpaceBelowField;

    // must be called before super.initState()
    textEditingController = widget.textFieldConfig.controller ?? TextEditingController();

    // uses textEditingController, sets focusNode
    super.initState();

    // must be called after super.initState()
    focusNode.addListener(_onFocusChange);

    if (widget.buttonConfig?.syncStyleWithTextField == true) {
      _compoundWidgetStatesController = CompoundWidgetStatesController();
      _statesController = null;
      _showError(errorText);
    } else {
      _compoundWidgetStatesController = null;
      _statesController = widget.textFieldConfig.statesController ?? WidgetStatesController();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    UiParamsData uiParams = UiParams.of(context);
    _style = widget.textFieldConfig.style ?? uiParams.appTheme.textStyle();
    _width = widget.width ?? getWidth(uiParams.appSize);
  }

  @override
  void dispose() {
    if (widget.textFieldConfig.controller == null) {
      textEditingController.dispose();
    }
    if (widget.textFieldConfig.statesController == null) {
      _statesController?.dispose();
    }
    _compoundWidgetStatesController?.dispose();
    focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget buildFieldWidget(BuildContext context) {

    // with button
    if (widget.buttonConfig?.syncStyleWithTextField == true) {
      return CompoundWidgetStatesController.wrapWithStateDetectors(
        statesSink: _compoundWidgetStatesController!.fieldStatesSink,
        focusNode: null,
        child: ValueListenableBuilder<Set<WidgetState>>(
          valueListenable: _compoundWidgetStatesController!,
          builder: (context, states, _) {
            return _makeBody(context);
          },
        ),
      );
    }

    // no button
    else {
      return ValueListenableBuilder<Set<WidgetState>>(
        valueListenable: _statesController!,
        builder: (context, states, _) {
          return _makeBody(context);
        },
      );
    }
  }

  LabelledBox _makeBody(BuildContext context) {
    final decoration = TextFieldDecorationMaker.makeInputDecoration(
      context: context,
      uiParams: UiParams.of(context),
      borderType: widget.borderType,
      decoration: widget.textFieldConfig.decoration,
      errorPosition: widget.errorPosition,
      buttonConfig: widget.buttonConfig,
      errorBuilder: widget.errorBuilder,
      states: _updateAndGetStates(),
      errorText: _showErrorBelowField ? errorText : null,
    );

    final TextField textField = _makeTextField(textEditingController, decoration, _style);
    final TextFieldBorderType effectiveBorderType = _getEffectiveBorderType(decoration);
    TextFieldEditingAreaConfig editingAreaConfig = _makeEditingAreaConfig(context, decoration);
    TextFieldBottomSpaceConfig bottomSpaceConfig = _buildBottomSpaceConfig(context, decoration, widget.errorPosition);

    return LabelledBox(
      fieldBody: textField,
      editingAreaConfig: editingAreaConfig,
      bottomSpaceConfig: bottomSpaceConfig,
      outerLabelConfig: widget.outerLabelConfig,
      buttonConfig: widget.buttonConfig,
      numberOfButtons: widget.buttonConfig == null ? 0 : 1,
      borderType: effectiveBorderType,
      width: _width,
      errorPosition: widget.errorPosition,
      targetFocusNode: focusNode,
      compoundWidgetStatesController: _compoundWidgetStatesController,
      onButtonTap: onButtonTap,
    );
  }

  TextFieldEditingAreaConfig _makeEditingAreaConfig(BuildContext context, InputDecoration decoration) {
    final TextFieldEditingAreaConfig editingAreaConfig = TextFieldEditingAreaConfig.create(
      context: context,
      decoration: decoration,
      config: widget.textFieldConfig,
      width: _width,
      text: textEditingController.text,
    );
    return editingAreaConfig;
  }

  TextFieldBottomSpaceConfig _buildBottomSpaceConfig(
    BuildContext context,
    InputDecoration decoration,
    ErrorPosition errorPosition,
  ) {
    if (errorPosition != ErrorPosition.fixedSpaceBelowField) {
      return const TextFieldBottomSpaceConfig.empty();
    }

    final bool withError = errorText != null && errorText!.isNotEmpty || widget.errorBuilder != null;
    final bool withHelper = decoration.helperText != null || decoration.helper != null;
    final bool withCounter = decoration.counterText != null || decoration.counter != null;

    final TextFieldBottomSpaceConfig bottomSpaceConfig = TextFieldBottomSpaceConfig(
      errorConfig: !withError
          ? null
          : ErrorWidgetConfig(
              text: errorText,
              widget: widget.errorBuilder?.call(context, errorText ?? 'Ay'),
              textStyle: decoration.errorStyle,
              errorMaxLines: decoration.errorMaxLines,
            ),
      helperConfig: !withHelper
          ? null
          : HelperWidgetConfig(
              text: decoration.helperText,
              widget: decoration.helper,
              textStyle: decoration.helperStyle,
            ),
      counterConfig: !withCounter
          ? null
          : CounterWidgetConfig(
              text: decoration.counterText,
              widget: decoration.counter,
              textStyle: decoration.counterStyle,
            ),
    );
    return bottomSpaceConfig;
  }

  TextFieldBorderType _getEffectiveBorderType(InputDecoration decoration) {
    final border = decoration.border;

    if (border is OutlineInputBorder || border is OutlineSidesInputBorder) {
      return TextFieldBorderType.outline;
    }
    if (border is UnderlineInputBorder || border is UnderlineTopRoundedInputBorder) {
      return TextFieldBorderType.underline;
    }
    return TextFieldBorderType.other;
  }

  TextField _makeTextField(
    TextEditingController controller,
    InputDecoration decoration,
    TextStyle style,
  ) {
    return TextField(
      groupId: widget.textFieldConfig.groupId,
      controller: controller,
      focusNode: focusNode,
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

  Set<WidgetState>? _updateAndGetStates() {
    var isError = errorText != null && errorText!.isNotEmpty;
    if (_compoundWidgetStatesController != null) {
      _compoundWidgetStatesController!.fieldStatesSink.setError(isError);
      return _compoundWidgetStatesController!.states;
    } else {
      _statesController!.update(WidgetState.error, isError);
      return _statesController!.value;
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
    if (_compoundWidgetStatesController != null) {
      _compoundWidgetStatesController!.fieldStatesSink.setFocused(focusNode.hasFocus);
    } else {
      _statesController!.update(WidgetState.focused, focusNode.hasFocus);
    }
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
      setInput(fieldContent.input);
      errorText = fieldContent.error;
      _showError(fieldContent.error);
    });
    _skipOnChanged = false;
  }

  void _showError(String? error) {
    bool isError = error != null && error.isNotEmpty;
    if (_compoundWidgetStatesController != null) {
      _compoundWidgetStatesController!.fieldStatesSink.setError(isError);
    } else {
      _statesController!.update(WidgetState.error, isError);
    }
  }
}
