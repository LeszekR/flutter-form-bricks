import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/form_field_descriptor.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/timestamp_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/timestamp_date_time_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_time_utils.dart';

class DateFieldDescriptor extends FormFieldDescriptor<TextEditingValue, DateTimeBrick, DateField> {
  DateFieldDescriptor({
    required super.keyString,
    super.initialInput,
    super.isRequired,
    super.runValidatorsFullRun,
    super.additionalFormatterValidatorsMaker,
    DateTimeLimits? dateTimeLimits,
    DateTimeUtils? dateTimeUtils,
    CurrentDate? currentDate,
  }) : super(
          defaultFormatterValidatorsMaker: () => [
            DateFormatterValidator(
              dateTimeUtils ?? DateTimeUtils(),
              currentDate ?? CurrentDate(),
              dateTimeLimits,
            ),
          ],
        );
}

class DateField extends TextFieldBrick<TextEditingValue, Date> {
  DateField({
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
    super.width,
    // TODO implement button for date field
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
    super.textAlignVertical,
    super.textDirection = TextDirection.ltr,
    super.readOnly = false,
    super.showCursor,
    // super.autofocus = false, => FormData takes over initial focus in form
    // super.statesController, => replaced with statesObserver and statesNotifier
    // super.obscuringCharacter = '•', => this is non-password field
    // super.obscureText = false, => fixed in constructor
    // super.autocorrect = true, => not relevant in this field
    // super.smartDashesType = SmartDashesType.disabled, => fixed in constructor
    // super.smartQuotesType = SmartQuotesType.disabled, => fixed in constructor
    super.enableSuggestions = true,
    // super.maxLines = 1, => fixed in constructor
    // super.minLines = 1, => fixed in constructor
    super.expands = false,
    // super.maxLength, => not relevant in this field
    // super.maxLengthEnforcement, => not relevant in this field
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onAppPrivateCommand,
    // super.inputFormatters, => FormManager takes over formatting
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
    // super.buildCounter, => not relevant in this field
    // super.scrollController, => not relevant in this field
    // super.scrollPhysics, => not relevant in this field
    super.autofillHints = const <String>[],
    // super.contentInsertionConfiguration = null, => not relevant in this field
    // super.clipBehavior = Clip.hardEdge, => not relevant in this field
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
        );

  @override
  DateFieldState createState() => DateFieldState();
}

class DateFieldState extends TextFieldStateBrick<TextEditingValue, Date, DateField> {
  @override
  Date? get defaultValue => null;
}
