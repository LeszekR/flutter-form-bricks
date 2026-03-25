import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/form_field_descriptor.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/components/formatter_validator_base/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/form_fields/components/labelled_box/label_position.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/form_field_data.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/icon_button_params.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/states_color_maker.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/string_extension.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_config.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_multi_initial_set.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_range_required_fields.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/date_field.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_separate_fields_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_utils.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/time_field.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/ui_params/theme_data/bricks_theme_data.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';

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
  final TextFieldConfig config;
  final FormManager formManager;
  final StatesColorMaker colorMaker;
  final String? label;
  final LabelPosition labelPosition;
  final double? widthDate;
  final double? widthTime;

  DateTimeSeparatedField({
    // FormFieldBrick
    required this.keyString,
    required this.formManager,
    StatesColorMaker? colorMaker,
    this.label,
    this.labelPosition = LabelPosition.topLeft,
    //
    // TextFieldBrick
    this.widthDate,
    this.widthTime,
    // TODO implement buttons for date-time-separate fields
    // TextFieldConfig
    IconButtonParams? buttonParams,
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
        config = TextFieldConfig(
          // // TextFieldConfig
          buttonParams: buttonParams,
          validateMode: ValidateModeBrick.onEditingComplete,
          //
          // Flutter TextField
          magnifierConfiguration: magnifierConfiguration,
          groupId: groupId,
          controller: controller,
          focusNode: focusNode,
          decoration: decoration,
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
    final appSize = UiParams.of(context).appSize;
    final appTheme = UiParams.of(context).appTheme;

    // TODO: use TextField.groupId to create shared tap region for the two fields

    List<Widget> elements = [
      _makeDateField(appTheme),
      appSize.spacerBoxHorizontalSmallest,
      _makeTimeField(appTheme),
    ];
    if (label != null) {
      elements = [
        Text(label!),
        appSize.spacerBoxHorizontalSmallest,
        ...elements,
      ];
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: elements,
    );
  }

  DateField _makeDateField(BricksThemeData appTheme) {
    return DateField(
      // FormFieldBrick
      keyString: DateTimeUtils.makeDateKeyString(keyString),
      formManager: formManager,
      // required String label,
      // required LabelPosition labelPosition,
      colorMaker: colorMaker,
      // statesObserver: statesObserver,
      // statesNotifier: statesNotifier,
      //
      // TextFieldBrick
      width: widthDate ?? appTheme.getFontDimension(TextDimension.widthOfChar0) * 12,
      buttonParams: config.buttonParams,
      //
      // TextField
      groupId: config.groupId,
      controller: config.controller,
      focusNode: config.focusNode,
      undoController: config.undoController,
      decoration: config.decoration,
      keyboardType: config.keyboardType,
      textInputAction: config.textInputAction,
      style: config.style,
      strutStyle: config.strutStyle,
      textAlign: config.textAlign,
      textAlignVertical: config.textAlignVertical,
      textDirection: config.textDirection,
      readOnly: config.readOnly,
      showCursor: config.showCursor,
      enableSuggestions: config.enableSuggestions,
      expands: config.expands,
      onChanged: config.onChanged,
      onEditingComplete: config.onEditingComplete,
      onSubmitted: config.onSubmitted,
      onAppPrivateCommand: config.onAppPrivateCommand,
      enabled: config.enabled,
      ignorePointers: config.ignorePointers,
      cursorWidth: config.cursorWidth,
      cursorHeight: config.cursorHeight,
      cursorRadius: config.cursorRadius,
      cursorOpacityAnimates: config.cursorOpacityAnimates,
      cursorColor: config.cursorColor,
      cursorErrorColor: config.cursorErrorColor,
      selectionHeightStyle: config.selectionHeightStyle,
      selectionWidthStyle: config.selectionWidthStyle,
      keyboardAppearance: config.keyboardAppearance,
      scrollPadding: config.scrollPadding,
      dragStartBehavior: config.dragStartBehavior,
      enableInteractiveSelection: config.enableInteractiveSelection,
      selectAllOnFocus: config.selectAllOnFocus,
      selectionControls: config.selectionControls,
      onTap: config.onTap,
      onTapAlwaysCalled: config.onTapAlwaysCalled,
      onTapOutside: config.onTapOutside,
      onTapUpOutside: config.onTapUpOutside,
      mouseCursor: config.mouseCursor,
      autofillHints: config.autofillHints,
      restorationId: config.restorationId,
      stylusHandwritingEnabled: config.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: config.enableIMEPersonalizedLearning,
      contextMenuBuilder: config.contextMenuBuilder,
      canRequestFocus: config.canRequestFocus,
      spellCheckConfiguration: config.spellCheckConfiguration,
      magnifierConfiguration: config.magnifierConfiguration,
      hintLocales: config.hintLocales,
    );
  }

  TimeField _makeTimeField(BricksThemeData appTheme) {
    return TimeField(
      // FormFieldBrick
      keyString: DateTimeUtils.makeTimeKeyString(keyString),
      formManager: formManager,
      // required String label,
      // required LabelPosition labelPosition,
      colorMaker: colorMaker,
      // statesObserver: statesObserver,
      // statesNotifier: statesNotifier,
      //
      // TextFieldBrick
      width: widthTime ?? appTheme.getFontDimension(TextDimension.widthOfChar0) * 8,
      buttonParams: config.buttonParams,
      //
      // TextField
      groupId: config.groupId,
      controller: config.controller,
      focusNode: config.focusNode,
      undoController: config.undoController,
      decoration: config.decoration,
      keyboardType: config.keyboardType,
      textInputAction: config.textInputAction,
      style: config.style,
      strutStyle: config.strutStyle,
      textAlign: config.textAlign,
      textAlignVertical: config.textAlignVertical,
      textDirection: config.textDirection,
      readOnly: config.readOnly,
      showCursor: config.showCursor,
      enableSuggestions: config.enableSuggestions,
      expands: config.expands,
      onChanged: config.onChanged,
      onEditingComplete: config.onEditingComplete,
      onSubmitted: config.onSubmitted,
      onAppPrivateCommand: config.onAppPrivateCommand,
      enabled: config.enabled,
      ignorePointers: config.ignorePointers,
      cursorWidth: config.cursorWidth,
      cursorHeight: config.cursorHeight,
      cursorRadius: config.cursorRadius,
      cursorOpacityAnimates: config.cursorOpacityAnimates,
      cursorColor: config.cursorColor,
      cursorErrorColor: config.cursorErrorColor,
      selectionHeightStyle: config.selectionHeightStyle,
      selectionWidthStyle: config.selectionWidthStyle,
      keyboardAppearance: config.keyboardAppearance,
      scrollPadding: config.scrollPadding,
      dragStartBehavior: config.dragStartBehavior,
      enableInteractiveSelection: config.enableInteractiveSelection,
      selectAllOnFocus: config.selectAllOnFocus,
      selectionControls: config.selectionControls,
      onTap: config.onTap,
      onTapAlwaysCalled: config.onTapAlwaysCalled,
      onTapOutside: config.onTapOutside,
      onTapUpOutside: config.onTapUpOutside,
      mouseCursor: config.mouseCursor,
      autofillHints: config.autofillHints,
      restorationId: config.restorationId,
      stylusHandwritingEnabled: config.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: config.enableIMEPersonalizedLearning,
      contextMenuBuilder: config.contextMenuBuilder,
      canRequestFocus: config.canRequestFocus,
      spellCheckConfiguration: config.spellCheckConfiguration,
      magnifierConfiguration: config.magnifierConfiguration,
      hintLocales: config.hintLocales,
    );
  }
}
