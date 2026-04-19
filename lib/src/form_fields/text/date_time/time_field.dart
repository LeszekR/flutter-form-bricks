import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/time_picker.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/time_formatter_validator.dart';

class TimeFieldDescriptor extends FormFieldDescriptor<TextEditingValue, DateTime, TimeField> {
  TimeFieldDescriptor({
    required super.keyString,
    super.initialInput,
    super.isRequired,
    super.runValidatorsFullRun,
    super.additionalFormatterValidatorsMaker,
    DateTimeLimits? dateTimeLimits,
    DateTimeUtils? dateTimeUtils,
  }) : super(
          defaultFormatterValidatorsMaker: () => [
            TimeFormatterValidator(
              dateTimeUtils ?? DateTimeUtils(),
              dateTimeLimits,
            ),
          ],
        );
}

class TimeField extends TextFieldBrick<DateTime> {
  final TimePickerConfig? timePickerConfig;

  TimeField({
    super.key,
    //
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
    // TimeField
    bool withTimePicker = true,
    TextFieldButtonConfig? timePickerButtonConfig,
    this.timePickerConfig,
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
    // super.statesController,  => replaced with statesObserver and statesNotifier
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
    super.selectAllOnFocus = false,
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
  })  : assert(withTimePicker == false ? (timePickerButtonConfig == null && timePickerConfig == null) : true,
            'When withTimePicker == false then timePickerButtonConfig and timePickerConfig must be null or not declared'),
        super(
          textFieldButtonConfig: !withTimePicker
              ? null
              : timePickerButtonConfig != null
                  ? timePickerButtonConfig
                  : const TextFieldButtonConfig(
                      iconData: Icons.arrow_drop_down,
                      buttonPosition: ButtonPosition.right,
                      tooltipMaker: TimePicker.timePickerTooltipMaker,
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
  TimeFieldState createState() => TimeFieldState();
}

class TimeFieldState extends TextFieldStateBrick<DateTime, TimeField> {
  @override
  DateTime? get defaultValue => null;

  @override
  double getWidth(AppSize appSize) => appSize.timeFieldWidth;

  @override
  void onButtonTap(BuildContext context) async {
    final TextSelection selectionBefore = controller.selection;

    TimeOfDay? time = await TimePicker(timePickerConfig: widget.timePickerConfig).open(context);

    if (!mounted) return;

    if (time == null) {
      restoreSelection(selectionBefore);
      return;
    }

    final String formattedTime = DateTimeUtils.formatTimeOfDay(time);
    onEditingComplete(formattedTime.toTextEditingValue());
    restoreSelection(selectionBefore);
    // controller.selection = selectionBefore;
    //
    //
  }

  void restoreSelection(TextSelection selectionBefore) {
    controller.value = controller.value.copyWith(
      selection: TextSelection.collapsed(offset: controller.text.length),
      composing: TextRange.empty,
    );
    focusNode.requestFocus();
  }
}
