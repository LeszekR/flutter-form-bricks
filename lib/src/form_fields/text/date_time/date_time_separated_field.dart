import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/formatter_validator_base/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/labelled_box.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_config.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_range_required_fields.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_separate_fields_formatter_validator.dart';
import 'package:flutter_form_bricks/src/ui_params/theme_data/bricks_theme_data.dart';

class DateTimeSeparateFieldDescriptor extends FormFieldDescriptor<TextEditingValue, DateTime, DateTimeSeparatedField> {
  String _dateKeyString;
  String _timeKeyString;
  DateTimeSeparatedInitialSet? initialInputSet;

  DateTimeSeparateFieldDescriptor({
    required super.keyString,
    DateTimeRequiredFields requiredFields = const DateTimeRequiredFields(true, true),
    super.runValidatorsFullRun,
    super.additionalFormatterValidatorsMaker,
    DateTimeLimits? dateTimeLimits,
    this.initialInputSet,
    DateTimeUtils? dateTimeUtils,
    CurrentDate? currentDate,
  })  : _dateKeyString = DateTimeUtils.makeDateKeyString(keyString),
        _timeKeyString = DateTimeUtils.makeTimeKeyString(keyString),
        super(
          defaultFormatterValidatorsMaker: () => [
            DateTimeSeparateFieldFormatterValidator(
              keyString,
              dateTimeUtils ?? DateTimeUtils(),
              currentDate ?? CurrentDate(),
              requiredFields,
              dateTimeLimits,
            ),
          ],
        );

  @override
  Map<String, FormatterValidatorChain<TextEditingValue, DateTime>> get formatterValidatorChainMap {
    FormatterValidatorChain<TextEditingValue, DateTime>? formatterValidatorChain = buildChain();
    return formatterValidatorChain == null
        ? {}
        : {
            _dateKeyString: formatterValidatorChain,
            _timeKeyString: formatterValidatorChain,
          };
  }

  @override
  Map<String, FormFieldData> get fieldDataMap => {
        _dateKeyString: FormFieldData(
          fieldType: DateField,
          fieldContent: DateTimeFieldContent.transient(initialInputSet?.date.txtEditVal()),
          initialInput: initialInputSet?.date.txtEditVal(),
          isValidating: false,
        ),
        _timeKeyString: FormFieldData(
          fieldType: TimeField,
          fieldContent: DateTimeFieldContent.transient(initialInputSet?.time.txtEditVal()),
          initialInput: initialInputSet?.time.txtEditVal(),
          isValidating: false,
        )
      };
}

class DateTimeSeparatedField extends StatelessWidget {
  final String keyString;
  final FormManager formManager;
  final StatesColorMaker colorMaker;
  final OuterLabelConfig? outerLabelConfig;
  final double? dateWidth;
  final double? timeWidth;
  final InputDecoration? dateInputDecoration;
  final InputDecoration? timeInputDecoration;
  final OuterLabelConfig? dateOuterLabelConfig;
  final OuterLabelConfig? timeOuterLabelConfig;
  final TextFieldButtonConfig? datePickerButtonConfig;
  final TextFieldButtonConfig? timePickerButtonConfig;
  final TextFieldConfig dateTextFieldConfig;
  final TextFieldConfig timeTextFieldConfig;

  DateTimeSeparatedField({
    // FormFieldBrick
    required this.keyString,
    required this.formManager,
    StatesColorMaker? colorMaker,
    this.outerLabelConfig,
    //
    // TextFieldBrick
    this.dateWidth,
    this.timeWidth,
    // TODO implement buttons for date-time-separate fields
    this.dateInputDecoration,
    this.timeInputDecoration,
    bool copyDateDecorationToTime = true,
    this.dateOuterLabelConfig,
    this.timeOuterLabelConfig,
    this.datePickerButtonConfig,
    this.timePickerButtonConfig,
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
    // textCapitalization = TextCapitalization.none,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    TextDirection? textDirection,
    bool readOnly = false,
    // bool autofocus, => FormData takes over initial focus in form
    // MaterialStatesController? statesController, => replaced with statesObserver and statesNotifier
    String obscuringCharacter = '•',
    // bool obscureText = false,
    bool? autocorrect,
    // TODO turn off and lock it for strictly formatting fields like DateField
    // SmartDashesType? smartDashesType,
    // TODO turn off and lock it for strictly formatting fields like DateField
    // SmartQuotesType? smartQuotesType,
    // TODO turn off and lock it for strictly formatting fields like DateField
    bool enableSuggestions = true,
    int? maxLines,
    int? minLines,
    bool expands = false,
    bool? showCursor,
    // int? maxLength,
    // MaxLengthEnforcement? maxLengthEnforcement,
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
  })  : this.colorMaker = colorMaker ?? StatesColorMaker(),
        dateTextFieldConfig = TextFieldConfig(
          // Flutter TextField
          magnifierConfiguration: magnifierConfiguration,
          groupId: groupId,
          controller: controller,
          focusNode: focusNode,
          decoration: dateInputDecoration,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: TextCapitalization.none,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          textDirection: textDirection,
          //  bool autofocus: //  bool autofocus, => FormData takes over initial focus in form
          //  MaterialStatesController statesController: //  MaterialStatesController statesController, => replaced with statesObserver and statesNotifier
          obscuringCharacter: obscuringCharacter,
          obscureText: false,
          autocorrect: autocorrect,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          enableSuggestions: enableSuggestions,
          maxLines: 1,
          minLines: 1,
          expands: expands,
          readOnly: readOnly,
          showCursor: showCursor,
          maxLength: 10,
          maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
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
        ),
        timeTextFieldConfig = TextFieldConfig(
          // Flutter TextField
          magnifierConfiguration: magnifierConfiguration,
          groupId: groupId,
          controller: controller,
          focusNode: focusNode,
          decoration: timeInputDecoration == null
              ? null
              : !copyDateDecorationToTime
                  ? timeInputDecoration
                  : timeInputDecoration.fillGapsFrom(dateInputDecoration),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: TextCapitalization.none,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          textDirection: textDirection,
          //  bool autofocus: //  bool autofocus, => FormData takes over initial focus in form
          //  MaterialStatesController statesController: //  MaterialStatesController statesController, => replaced with statesObserver and statesNotifier
          obscuringCharacter: obscuringCharacter,
          obscureText: false,
          autocorrect: autocorrect,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          enableSuggestions: enableSuggestions,
          maxLines: 1,
          minLines: 1,
          expands: expands,
          readOnly: readOnly,
          showCursor: showCursor,
          maxLength: 10,
          maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
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

  @override
  Widget build(BuildContext context) {
    final uiParams = UiParams.of(context);

    // TODO: use TextField.groupId to create shared tap region for the two fields

    List<Widget> elements = [
      _makeDateField(),
      uiParams.appSize.horizontalSpacer(uiParams.appSize.spacerHorizontalSmall),
      _makeTimeField(),
    ];

    final body = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: elements,
    );

    if (outerLabelConfig == null) {
      return body;
    } else {
      return LabelledBox(
        uiParamsData: UiParams.of(context),
        outerLabelConfig: outerLabelConfig,
        textField: body,
      );
    }
  }

  DateField _makeDateField() {
    return DateField(
      // FormFieldBrick
      keyString: DateTimeUtils.makeDateKeyString(keyString),
      formManager: formManager,
      colorMaker: colorMaker,
      //
      // TextFieldBrick
      width: dateWidth,
      inputDecoration: dateInputDecoration,
      datePickerButtonConfig: datePickerButtonConfig,
      outerLabelConfig: dateOuterLabelConfig,
      //
      // TextField
      groupId: dateTextFieldConfig.groupId,
      controller: dateTextFieldConfig.controller,
      focusNode: dateTextFieldConfig.focusNode,
      undoController: dateTextFieldConfig.undoController,
      keyboardType: dateTextFieldConfig.keyboardType,
      textInputAction: dateTextFieldConfig.textInputAction,
      style: dateTextFieldConfig.style,
      strutStyle: dateTextFieldConfig.strutStyle,
      textAlign: dateTextFieldConfig.textAlign,
      textAlignVertical: dateTextFieldConfig.textAlignVertical,
      textDirection: dateTextFieldConfig.textDirection,
      readOnly: dateTextFieldConfig.readOnly,
      showCursor: dateTextFieldConfig.showCursor,
      enableSuggestions: dateTextFieldConfig.enableSuggestions,
      expands: dateTextFieldConfig.expands,
      onChanged: dateTextFieldConfig.onChanged,
      onEditingComplete: dateTextFieldConfig.onEditingComplete,
      onSubmitted: dateTextFieldConfig.onSubmitted,
      onAppPrivateCommand: dateTextFieldConfig.onAppPrivateCommand,
      enabled: dateTextFieldConfig.enabled,
      ignorePointers: dateTextFieldConfig.ignorePointers,
      cursorWidth: dateTextFieldConfig.cursorWidth,
      cursorHeight: dateTextFieldConfig.cursorHeight,
      cursorRadius: dateTextFieldConfig.cursorRadius,
      cursorOpacityAnimates: dateTextFieldConfig.cursorOpacityAnimates,
      cursorColor: dateTextFieldConfig.cursorColor,
      cursorErrorColor: dateTextFieldConfig.cursorErrorColor,
      selectionHeightStyle: dateTextFieldConfig.selectionHeightStyle,
      selectionWidthStyle: dateTextFieldConfig.selectionWidthStyle,
      keyboardAppearance: dateTextFieldConfig.keyboardAppearance,
      scrollPadding: dateTextFieldConfig.scrollPadding,
      dragStartBehavior: dateTextFieldConfig.dragStartBehavior,
      enableInteractiveSelection: dateTextFieldConfig.enableInteractiveSelection,
      selectAllOnFocus: dateTextFieldConfig.selectAllOnFocus,
      selectionControls: dateTextFieldConfig.selectionControls,
      onTap: dateTextFieldConfig.onTap,
      onTapAlwaysCalled: dateTextFieldConfig.onTapAlwaysCalled,
      onTapOutside: dateTextFieldConfig.onTapOutside,
      onTapUpOutside: dateTextFieldConfig.onTapUpOutside,
      mouseCursor: dateTextFieldConfig.mouseCursor,
      autofillHints: dateTextFieldConfig.autofillHints,
      restorationId: dateTextFieldConfig.restorationId,
      stylusHandwritingEnabled: dateTextFieldConfig.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: dateTextFieldConfig.enableIMEPersonalizedLearning,
      contextMenuBuilder: dateTextFieldConfig.contextMenuBuilder,
      canRequestFocus: dateTextFieldConfig.canRequestFocus,
      spellCheckConfiguration: dateTextFieldConfig.spellCheckConfiguration,
      magnifierConfiguration: dateTextFieldConfig.magnifierConfiguration,
      hintLocales: dateTextFieldConfig.hintLocales,
    );
  }

  TimeField _makeTimeField() {
    return TimeField(
      // FormFieldBrick
      keyString: DateTimeUtils.makeTimeKeyString(keyString),
      formManager: formManager,
      colorMaker: colorMaker,
      //
      // TextFieldBrick
      width: timeWidth,
      inputDecoration: timeInputDecoration,
      outerLabelConfig: timeOuterLabelConfig,
      //
      // TimeField
      timePickerButtonConfig: timePickerButtonConfig,
      //
      // TextField
      groupId: dateTextFieldConfig.groupId,
      controller: dateTextFieldConfig.controller,
      focusNode: dateTextFieldConfig.focusNode,
      undoController: dateTextFieldConfig.undoController,
      keyboardType: dateTextFieldConfig.keyboardType,
      textInputAction: dateTextFieldConfig.textInputAction,
      style: dateTextFieldConfig.style,
      strutStyle: dateTextFieldConfig.strutStyle,
      textAlign: dateTextFieldConfig.textAlign,
      textAlignVertical: dateTextFieldConfig.textAlignVertical,
      textDirection: dateTextFieldConfig.textDirection,
      readOnly: dateTextFieldConfig.readOnly,
      showCursor: dateTextFieldConfig.showCursor,
      enableSuggestions: dateTextFieldConfig.enableSuggestions,
      expands: dateTextFieldConfig.expands,
      onChanged: dateTextFieldConfig.onChanged,
      onEditingComplete: dateTextFieldConfig.onEditingComplete,
      onSubmitted: dateTextFieldConfig.onSubmitted,
      onAppPrivateCommand: dateTextFieldConfig.onAppPrivateCommand,
      enabled: dateTextFieldConfig.enabled,
      ignorePointers: dateTextFieldConfig.ignorePointers,
      cursorWidth: dateTextFieldConfig.cursorWidth,
      cursorHeight: dateTextFieldConfig.cursorHeight,
      cursorRadius: dateTextFieldConfig.cursorRadius,
      cursorOpacityAnimates: dateTextFieldConfig.cursorOpacityAnimates,
      cursorColor: dateTextFieldConfig.cursorColor,
      cursorErrorColor: dateTextFieldConfig.cursorErrorColor,
      selectionHeightStyle: dateTextFieldConfig.selectionHeightStyle,
      selectionWidthStyle: dateTextFieldConfig.selectionWidthStyle,
      keyboardAppearance: dateTextFieldConfig.keyboardAppearance,
      scrollPadding: dateTextFieldConfig.scrollPadding,
      dragStartBehavior: dateTextFieldConfig.dragStartBehavior,
      enableInteractiveSelection: dateTextFieldConfig.enableInteractiveSelection,
      selectAllOnFocus: dateTextFieldConfig.selectAllOnFocus,
      selectionControls: dateTextFieldConfig.selectionControls,
      onTap: dateTextFieldConfig.onTap,
      onTapAlwaysCalled: dateTextFieldConfig.onTapAlwaysCalled,
      onTapOutside: dateTextFieldConfig.onTapOutside,
      onTapUpOutside: dateTextFieldConfig.onTapUpOutside,
      mouseCursor: dateTextFieldConfig.mouseCursor,
      autofillHints: dateTextFieldConfig.autofillHints,
      restorationId: dateTextFieldConfig.restorationId,
      stylusHandwritingEnabled: dateTextFieldConfig.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: dateTextFieldConfig.enableIMEPersonalizedLearning,
      contextMenuBuilder: dateTextFieldConfig.contextMenuBuilder,
      canRequestFocus: dateTextFieldConfig.canRequestFocus,
      spellCheckConfiguration: dateTextFieldConfig.spellCheckConfiguration,
      magnifierConfiguration: dateTextFieldConfig.magnifierConfiguration,
      hintLocales: dateTextFieldConfig.hintLocales,
    );
  }
}
