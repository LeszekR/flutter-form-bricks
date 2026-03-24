import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/form_field_descriptor.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/components/formatter_validator_base/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/string_extension.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_base_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_multi_initial_set.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_range_required_fields.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/date_field.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_separate_fields_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_utils.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/time_field.dart';
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
  Map<String, TextEditingValue?> get initialInputMap => {
        _dateKeyString: initialInputSet == null ? null : initialInputSet!.date.txtEditVal(),
        _timeKeyString: initialInputSet == null ? null : initialInputSet!.time.txtEditVal(),
      };
}

class DateTimeSeparatedField extends StatelessWidget {
  final double? widthDate;
  final double? widthTime;

  DateTimeSeparatedField({
    // FormFieldBrick
    required super.keyString,
    required super.formManager,
    super.label,
    super.labelPosition,
    super.colorMaker,
    super.statesObserver,
    super.statesNotifier,
    //
    // TextFieldBrick
    this.widthDate,
    this.widthTime,
    // TODO implement buttons for date-time-separate fields
    super.buttonParams,
    //
    // TextField
    super.groupId = EditableText,
    // super.controller,
    // super.focusNode,
    super.undoController,
    super.decoration,
    super.keyboardType,
    super.textInputAction,
    super.style,
    super.strutStyle,
    super.textAlign = TextAlign.center,
    super.textAlignVertical = TextAlignVertical.center,
    super.textDirection = TextDirection.ltr,
    super.readOnly = false,
    super.showCursor,
    super.enableSuggestions = true,
    super.expands = false,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onAppPrivateCommand,
    super.enabled,
    super.ignorePointers,
    super.cursorWidth = 2.0,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.cursorErrorColor,
    super.selectionHeightStyle = BoxHeightStyle.tight,
    super.selectionWidthStyle = BoxWidthStyle.tight,
    super.keyboardAppearance,
    super.scrollPadding = const EdgeInsets.all(20.0),
    super.dragStartBehavior = DragStartBehavior.start,
    super.enableInteractiveSelection,
    super.selectAllOnFocus,
    super.selectionControls,
    super.onTap,
    super.onTapAlwaysCalled = false,
    super.onTapOutside,
    super.onTapUpOutside,
    super.mouseCursor,
    super.autofillHints = const <String>[],
    super.restorationId,
    super.stylusHandwritingEnabled = EditableText.defaultStylusHandwritingEnabled,
    super.enableIMEPersonalizedLearning = true,
    super.contextMenuBuilder,
    super.canRequestFocus = true,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
    super.hintLocales,
  }) : super(
          validateMode: ValidateModeBrick.onEditingComplete,
          textCapitalization: TextCapitalization.none,
          obscureText: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          maxLines: 1,
          minLines: 1,
          maxLength: 10,
          maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
        );

  @override
  DateTimeSeparatedFieldState createState() => DateTimeSeparatedFieldState();
}

class DateTimeSeparatedFieldState extends TextFieldBaseStateBrick<TextEditingValue, DateTime, DateTimeSeparatedField> {
  //
  @override
  DateTime? get defaultValue => null;

  @override
  TextEditingValue? getInput() {
    // redundant in this class since DateField and TimeField validate themselves
    return null;
  }

  @override
  void setInput(TextEditingValue? formattedValue) {
    // redundant in this class since DateField and TimeField fill their inputs themselves
  }

  @override
  Widget build(BuildContext context) {
    final appSize = UiParams.of(context).appSize;

    // TODO: use TextField.groupId to create shared tap region for the two fields

    List<Widget> elements = [
      _makeDateField(),
      appSize.spacerBoxHorizontalSmallest,
      _makeTimeField(),
    ];
    if (widget.label != null) {
      elements = [
        Text(widget.label!),
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

  DateField _makeDateField() {
    return DateField(
      // FormFieldBrick
      keyString: DateTimeUtils.makeDateKeyString(widget.keyString),
      formManager: widget.formManager,
      // required String label,
      // required LabelPosition labelPosition,
      colorMaker: widget.colorMaker,
      statesObserver: widget.statesObserver,
      statesNotifier: widget.statesNotifier,
      //
      // TextFieldBrick
      width: widget.widthDate,
      buttonParams: widget.buttonParams,
      //
      // TextField
      groupId: widget.groupId,
      controller: widget.controller,
      focusNode: widget.focusNode,
      undoController: widget.undoController,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      enableSuggestions: widget.enableSuggestions,
      expands: widget.expands,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      onAppPrivateCommand: widget.onAppPrivateCommand,
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
      selectAllOnFocus: widget.selectAllOnFocus,
      selectionControls: widget.selectionControls,
      onTap: widget.onTap,
      onTapAlwaysCalled: widget.onTapAlwaysCalled,
      onTapOutside: widget.onTapOutside,
      onTapUpOutside: widget.onTapUpOutside,
      mouseCursor: widget.mouseCursor,
      autofillHints: widget.autofillHints,
      restorationId: widget.restorationId,
      stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      contextMenuBuilder: widget.contextMenuBuilder,
      canRequestFocus: widget.canRequestFocus,
      spellCheckConfiguration: widget.spellCheckConfiguration,
      magnifierConfiguration: widget.magnifierConfiguration,
      hintLocales: widget.hintLocales,
    );
  }

  TimeField _makeTimeField() {
    return TimeField(
      // FormFieldBrick
      keyString: DateTimeUtils.makeTimeKeyString(widget.keyString),
      formManager: widget.formManager,
      // required String label,
      // required LabelPosition labelPosition,
      colorMaker: widget.colorMaker,
      statesObserver: widget.statesObserver,
      statesNotifier: widget.statesNotifier,
      //
      // TextFieldBrick
      width: widget.widthTime,
      buttonParams: widget.buttonParams,
      //
      // TextField
      groupId: widget.groupId,
      controller: widget.controller,
      focusNode: widget.focusNode,
      undoController: widget.undoController,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      enableSuggestions: widget.enableSuggestions,
      expands: widget.expands,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      onAppPrivateCommand: widget.onAppPrivateCommand,
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
      selectAllOnFocus: widget.selectAllOnFocus,
      selectionControls: widget.selectionControls,
      onTap: widget.onTap,
      onTapAlwaysCalled: widget.onTapAlwaysCalled,
      onTapOutside: widget.onTapOutside,
      onTapUpOutside: widget.onTapUpOutside,
      mouseCursor: widget.mouseCursor,
      autofillHints: widget.autofillHints,
      restorationId: widget.restorationId,
      stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      contextMenuBuilder: widget.contextMenuBuilder,
      canRequestFocus: widget.canRequestFocus,
      spellCheckConfiguration: widget.spellCheckConfiguration,
      magnifierConfiguration: widget.magnifierConfiguration,
      hintLocales: widget.hintLocales,
    );
  }
}
