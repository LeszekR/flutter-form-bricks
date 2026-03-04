import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/form_field_descriptor.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/components/formatter_validator_base/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_base_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/data_time_text_editing_value.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_range_initial_set.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_range_required_fields.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/date_field.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/dateTimeRange_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_separate_fields_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_utils.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/time_field.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';

class DateTimeSeparateFieldsDescriptor
    extends FormFieldDescriptor<DateTimeTextEditingValue, DateTime, DateTimeSeparateFields> {
  DateTimeSeparateFieldsDescriptor({
    required super.keyString,
    required DateTimeRequiredFields requiredFields,
    super.initialInput,
    super.runValidatorsFullRun,
    super.additionalFormatterValidatorsMaker,
    DateTimeLimits? dateTimeLimits,
    DateTimeInitialSet? initialSet,
    DateTimeUtils? dateTimeUtils,
    CurrentDate? currentDate,
  }) : super(
          defaultFormatterValidatorsMaker: () => [
            DateTimeSeparateFieldsFormatterValidator(
              requiredFields,
              dateTimeUtils ?? DateTimeUtils(),
              currentDate ?? CurrentDate(),
              dateTimeLimits,
            ),
          ],
        );

  @override
  Map<String, FormatterValidatorChain<DateTimeTextEditingValue, DateTime>> get formatterValidatorChainMap {
    FormatterValidatorChain<DateTimeTextEditingValue, DateTime>? formatterValidatorChain = buildChain();
    return formatterValidatorChain == null
        ? {}
        : {
            DateTimeRangeFormatterValidator.makeDateKeyString(keyString): formatterValidatorChain,
            DateTimeRangeFormatterValidator.makeTimeKeyString(keyString): formatterValidatorChain,
          };
  }
}

class DateTimeSeparateFields extends TextFieldBaseBrick<DateTimeTextEditingValue, DateTime> {
  final double? widthDate;
  final double? widthTime;

  DateTimeSeparateFields({
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
    super.controller,
    super.focusNode,
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
  DateTimeSeparateFieldsState createState() => DateTimeSeparateFieldsState();
}

class DateTimeSeparateFieldsState
    extends TextFieldBaseStateBrick<DateTimeTextEditingValue, DateTime, DateTimeSeparateFields> {
  @override
  DateTime? get defaultValue => null;

  @override
  Widget build(BuildContext context) {
    final appSize = UiParams.of(context).appSize;

    FormFieldValidator<String>? rangeDateValidator;
//     if (rangeController != null) {
//       // TODO remove dateTimeLimits from here - this is validated in DateField
//       rangeDateValidator = DateTimeValidators.dateTimeRangeValidator(
//           localizations, dateKeyString, formManager, rangeController, dateTimeLimits, rangeSpan);
// // if (isDateRequired || additionalValidators != null) {
//       var validatorsExceptRange = ValidatorProvider.compose(
//         context: context,
//         isRequired: requiredFields == null ? null : requiredFields.date,
//         customValidator: DateTimeValidators.dateInputValidator(localizations, dateTimeLimits),
//         validatorsList: additionalValidators,
//       );
//       rangeController._dateTimeFormatterValidators[dateKeyString] = validatorsExceptRange;
// // }
//     }

    FormFieldValidator<String>? rangeTimeValidator;
//     if (rangeController != null) {
//       // TODO remove dateTimeLimits from here - this is validated in DateField
//       rangeTimeValidator = DateTimeValidators.dateTimeRangeValidator(
//           localizations, timeKeyString, formManager, rangeController, dateTimeLimits, rangeSpan);
//       var validatorsExceptRange = ValidatorProvider.compose(
//         context: context,
//         isRequired: requiredFields == null ? null : requiredFields.time,
//         customValidator: DateTimeValidators.timeInputValidator(localizations),
//         validatorsList: additionalValidators,
//       );
// // if (isTimeRequired || additionalValidators != null) {
//       rangeController._dateTimeFormatterValidators[timeKeyString] = validatorsExceptRange;
// // }
//     }

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
      keyString: DateTimeRangeFormatterValidator.makeDateKeyString(widget.keyString),
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
      // TU PRZERWAŁEM - finish abstracting TextFieldBaseBrick
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
      keyString: DateTimeRangeFormatterValidator.makeTimeKeyString(widget.keyString),
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
