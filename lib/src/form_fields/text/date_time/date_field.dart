import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/form_field_descriptor.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_button_config.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_picker.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_utils.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/app_size.dart';

class DateFieldDescriptor extends FormFieldDescriptor<TextEditingValue, DateTime, DateField> {
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

class DateField extends TextFieldBrick<DateTime> {
  DatePickerConfig? datePickerConfig;
  final CurrentDate? currentDate;

  DateField({
    // FormFieldBrick
    required super.keyString,
    required super.formManager,
    super.colorMaker,
    super.statesController,
    //
    // TextFieldBrick
    super.width,
    super.inputDecoration,
    super.outerLabelConfig,
    //
    // DateField
    TextFieldButtonConfig? datePickerButtonConfig,
    this.datePickerConfig,
    this.currentDate,
    //
    // TextField
    super.groupId = EditableText,
    super.controller,
    super.focusNode,
    super.undoController,
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
          textFieldButtonConfig: datePickerButtonConfig != null
              ? datePickerButtonConfig
              : TextFieldButtonConfig(
                  iconDataMaker: Icons.arrow_drop_down,
                  buttonSide: ButtonSide.right,
                  tooltipMaker: DatePicker.datePickerTooltip,
                ),
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

class DateFieldState extends TextFieldStateBrick<DateTime, DateField> {
  @override
  DateTime? get defaultValue => null;

  @override
  double getWidth(AppSize appSize) => appSize.dateFieldWidth;

  @override
  void onButtonTap(BuildContext context) async {
    DateTime? date = await DatePicker(widget.currentDate, datePickerConfig: widget.datePickerConfig).open(context);
    if (date == null) return;

    final formattedDate = DateTimeUtils.dateFormat.format(date);
    controller.value = TextEditingValue(
      text: formattedDate,
      selection: TextSelection.collapsed(offset: formattedDate.length),
    );
  }
}
