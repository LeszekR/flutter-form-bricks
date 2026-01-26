import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/base/form_field_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/base/form_field_descriptor.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/timestamp_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_time_utils.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_field_base/states_color_maker.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_field_base/text_field_brick.dart';

class DateFieldDescriptor extends FormFieldDescriptor<TextEditingValue, Date, DateField> {
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

class DateField extends TextFieldBrick<Date> {
  DateField({
    super.key,
    //
    // FormFieldBrick
    required super.keyString,
    required super.formManager,
    StatesColorMaker? colorMaker,
    super.statesObserver,
    super.statesNotifier,
    //
    // TextFieldBrick
    super.width,
    //
    // TextField
    super.groupId = EditableText,
    super.controller,
    super.focusNode,
    super.undoController,
    super.decoration,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization = TextCapitalization.none,
    super.style,
    super.strutStyle,
    super.textAlign = TextAlign.start,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly = false,
    super.showCursor,
    super.autofocus = false,
    // super.statesController,  => replaced with statesObserver and statesNotifier
    super.obscuringCharacter = '•',
    super.obscureText = false,
    super.autocorrect = true,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions = true,
    super.maxLines = 1,
    super.minLines,
    super.expands = false,
    super.maxLength,
    super.maxLengthEnforcement,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onAppPrivateCommand,
    super.inputFormatters,
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
    super.buildCounter,
    super.scrollController,
    super.scrollPhysics,
    super.autofillHints = const <String>[],
    super.contentInsertionConfiguration,
    super.clipBehavior = Clip.hardEdge,
    super.restorationId,
    super.stylusHandwritingEnabled = EditableText.defaultStylusHandwritingEnabled,
    super.enableIMEPersonalizedLearning = true,
    super.contextMenuBuilder,
    super.canRequestFocus = true,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
    super.buttonParams,
    super.hintLocales,
  }) : super(validateMode: ValidateModeBrick.onEditingComplete);

  @override
  State<StatefulWidget> createState() => DateFieldState();
}

class DateFieldState extends TextFieldStateBrick<Date, DateField> {}
