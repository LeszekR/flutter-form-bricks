import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/inputs/labelled_box/label_position.dart';
import 'package:flutter_form_bricks/src/inputs/states_controller/double_widget_states_controller.dart';

import '../../../../inputs/text/format_and_validate/input_validator_provider.dart';
import '../../../../ui_params/ui_params.dart';
import '../../../misc/time_stamp.dart';
import '../../buttons/buttons.dart';
import '../../forms/form_manager/form_manager.dart';
import '../../shortcuts/keyboard_shortcuts.dart';
import '../text/text_inputs_base/basic_text_input.dart';
import 'current_date.dart';
import 'dateTime_formatter_validator.dart';
import 'dateTime_range_error_controller.dart';
import 'date_formatter_validator.dart';
import 'date_time_utils.dart';
import 'date_time_validators.dart';

class DateTimeInputs {
  static final DateTimeUtils _dateTimeInputUtils = DateTimeUtils();
  static final CurrentDate _currentDate = CurrentDate();
  static final DateFormatterValidator _dateFormatter = DateFormatterValidator(_dateTimeInputUtils, _currentDate);
  static final TimeFormatterValidator _timeFormatter = TimeFormatterValidator(_dateTimeInputUtils);
  static final DateTimeFormatterValidator _dateTimeFormatter =
      DateTimeFormatterValidator(_dateFormatter, _timeFormatter, _dateTimeInputUtils);

  DateTimeInputs._();

  static Widget date({
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManagerOLD formManager,
    final Date? initialValue,
    final bool readonly = false,
    final bool isRequired = false,
    final DateTime? minDate,
    final DateTime? maxDate,
    final List<String>? linkedFields,
    final ValueChanged<String?>? onChanged,
    final RangeController? rangeController,
    final FormFieldValidator<String>? rangeValidator,
    final List<FormFieldValidator<String>>? additionalValidators,
  }) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;

    DoubleWidgetStatesController statesController = DoubleWidgetStatesController();

    ValueListenableBuilder iconButton = Buttons.iconButtonStateAware(
      context: context,
      iconData: Icons.arrow_drop_down,
      tooltip: Tr.get.openDatePicker,
      onPressed: readonly
          ? null
          : () => _showDatePicker(
                context: context,
                keyString: keyString,
                formManager: formManager,
              ),
      statesController: statesController,
    );

    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      initialValue: initialValue,
      //initialValue?.toString(),
      readonly: readonly,
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: TextInputType.text,
      formManager: formManager,
      onEditingComplete: () =>
          _onEditingComplete(formManager, keyString, _dateFormatter.makeDateString, rangeController),
      validator: ValidatorProvider.compose(
          isRequired: isRequired,
          customValidator: rangeValidator ?? DateTimeValidators.dateInputValidator(),
          // customValidator: /*rangeValidator ?? DateTimeValidators.dateInputValidator()*/ValidatorProvider.compose(minLength: 1),
          validatorsList: additionalValidators),
      withTextEditingController: true,
      linkedFields: linkedFields,
      inputWidth: appSize.textFieldWidth,
      onChanged: onChanged,
      button: iconButton,
      statesController: statesController,
    );
  }

  static Widget time({
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManagerOLD formManager,
    final Time? initialValue,
    final bool readonly = false,
    final bool isRequired = false,
    final List<String>? linkedFields,
    final ValueChanged<String?>? onChanged,
    final RangeController? rangeController,
    final FormFieldValidator<String>? rangeValidator,
    final List<FormFieldValidator<String>>? additionalValidators,
  }) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;

    DoubleWidgetStatesController statesController = DoubleWidgetStatesController();

    ValueListenableBuilder iconButton = Buttons.iconButtonStateAware(
      context: context,
      iconData: Icons.arrow_drop_down,
      tooltip: Tr.get.openTimePicker,
      onPressed: () => _showTimePicker(
        context: context,
        keyString: keyString,
        formManager: formManager,
      ),
      statesController: statesController,
    );

    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      initialValue: initialValue,
      //initialValue?.toString(),
      readonly: readonly,
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: TextInputType.text,
      formManager: formManager,
      onEditingComplete: () =>
          _onEditingComplete(formManager, keyString, _timeFormatter.makeTimeString, rangeController),
      validator: ValidatorProvider.compose(
        isRequired: isRequired,
        customValidator: rangeValidator ?? DateTimeValidators.timeInputValidator(),
        validatorsList: additionalValidators,
      ),
      withTextEditingController: true,
      linkedFields: linkedFields,
      inputWidth: appSize.textFieldWidth,
      button: iconButton,
      statesController: statesController,
    );
  }

  static Widget dateTimeSeparateFields({
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManagerOLD formManager,
    final bool isDateRequired = false,
    final bool isTimeRequired = false,
    final RangeController? rangeController,
    final Date? initialDate,
    final Time? initialTime,
    final bool readonly = false,
    final List<FormFieldValidator<String>>? additionalValidators,
  }) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;
    final appStyle = uiParams.appStyle;
    final appColor = uiParams.appColor;

    var dateKeyString = makeDateKeyString(keyString);
    var timeKeyString = mameTimeKeyString(keyString);

    FormFieldValidator<String>? rangeDateValidator;
    if (rangeController != null) {
      rangeDateValidator = DateTimeValidators.dateTimeRangeValidator(dateKeyString, formManager, rangeController);
      // if (isDateRequired || additionalValidators != null) {
      var validatorsExceptRange = ValidatorProvider.compose(
        isRequired: isDateRequired,
        customValidator: DateTimeValidators.dateInputValidator(),
        validatorsList: additionalValidators,
      );
      rangeController.validatorExceptRange[dateKeyString] = validatorsExceptRange;
      // }
    }
    FormFieldValidator<String>? rangeTimeValidator;
    if (rangeController != null) {
      rangeTimeValidator = DateTimeValidators.dateTimeRangeValidator(timeKeyString, formManager, rangeController);
      // if (isTimeRequired || additionalValidators != null) {
      var validatorExceptRange = ValidatorProvider.compose(
        isRequired: isTimeRequired,
        customValidator: DateTimeValidators.timeInputValidator(),
        validatorsList: additionalValidators,
      );
      rangeController.validatorExceptRange[timeKeyString] = validatorExceptRange;
      // }
    }

    final elements = [
      date(
        context: context,
        keyString: dateKeyString,
        label: Tr.get.date,
        labelPosition: LabelPosition.topLeft,
        initialValue: initialDate,
        readonly: readonly,
        formManager: formManager,
        isRequired: isDateRequired,
        rangeController: rangeController,
        rangeValidator: rangeDateValidator,
        additionalValidators: additionalValidators,
      ),
      appSize.spacerBoxHorizontalSmallest,
      time(
        context: context,
        keyString: timeKeyString,
        label: Tr.get.time,
        labelPosition: LabelPosition.topLeft,
        initialValue: initialTime,
        readonly: readonly,
        formManager: formManager,
        isRequired: isTimeRequired,
        rangeController: rangeController,
        rangeValidator: rangeTimeValidator,
        additionalValidators: additionalValidators,
      )
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(label), Row(children: elements)],
    );
  }

  static Widget dateTimeRange({
    required BuildContext context,
    required String rangeId,
    required String label,
    required LabelPosition labelPosition,
    required FormManagerOLD formManager,
    final bool readonly = false,
    final Date? initialRangeStartDate,
    final Time? initialRangeStartTime,
    final Date? initialRangeEndDate,
    final Time? initialRangeEndTime,
  }) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;

    var rangeController = RangeController(rangeId);

    final rangeStart = dateTimeSeparateFields(
      context: context,
      keyString: makeRangeKeyStringStart(rangeId),
      label: "$label ${Tr.get.start}",
      labelPosition: labelPosition,
      initialDate: initialRangeStartDate,
      initialTime: initialRangeStartTime,
      formManager: formManager,
      rangeController: rangeController,
      isDateRequired: true,
    );
    final rangeEnd = dateTimeSeparateFields(
      context: context,
      keyString: makeRangeKeyStringEnd(rangeId),
      label: "$label ${Tr.get.end}",
      labelPosition: labelPosition,
      initialDate: initialRangeEndDate,
      initialTime: initialRangeEndTime,
      formManager: formManager,
      rangeController: rangeController,
    );
    return Row(children: [rangeStart, appSize.spacerBoxHorizontalMedium, rangeEnd]);
  }

  static Widget dateTimeOneField({
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManagerOLD formManager,
    final DateTime? initialValue,
    final bool readonly = false,
    final bool isRequired = false,
    final List<String>? linkedFields,
    final ValueChanged<String?>? onChanged,
    final VoidCallback? onDateHourChange,
    final List<FormFieldValidator<String>>? additionalValidators,
  }) {
    DoubleWidgetStatesController statesController = DoubleWidgetStatesController();

    ValueListenableBuilder iconButton = Buttons.iconButtonStateAware(
      context: context,
      iconData: Icons.arrow_drop_down,
      tooltip: '${Tr.get.openTimePicker} ${Tr.get.and} ${Tr.get.openTimePicker}',
      onPressed: () => _showDateTimePicker(context: context, keyString: keyString, formManager: formManager),
      statesController: statesController,
    );

    return BasicTextInput.basicTextInput(
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: initialValue,
      //initialValue?.toString(),
      readonly: false,
      formManager: formManager,
      onEditingComplete: () => _onEditingComplete(formManager, keyString, _dateTimeFormatter.makeDateTimeString, null),
      validator: ValidatorProvider.compose(
          customValidator: DateTimeValidators.dateTimeInputValidator(), validatorsList: additionalValidators),
      withTextEditingController: true,
      onChanged: onChanged,
      button: iconButton,
      statesController: statesController,
    );
  }

  static void _showDatePicker({
    required BuildContext context,
    required String keyString,
    required FormManagerOLD formManager,
    Duration? maxDateSpan,
  }) {
    final now = DateTime.now();
    var dateSpan = maxDateSpan ?? Duration(days: 365);
    showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(dateSpan),
      lastDate: now.add(dateSpan),
    ).then((value) {
      if (value != null) {
        // TODO connect to rangeValidator
        final formattedText = Date.dateFormat.format(value);
        formManager.onFieldChanged(keyString, formattedText);
      }
    });
  }

  static void _showTimePicker({
    required BuildContext context,
    required String keyString,
    required FormManagerOLD formManager,
  }) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now().replacing(minute: 0),
    ).then((value) {
      if (value != null) {
        // TODO connect to rangeValidator
        final formattedText =
            Date.timeFormatMinutePrecision.format(DateTime.now().copyWith(minute: value.minute, hour: value.hour));
        formManager.onFieldChanged(keyString, formattedText);
      }
    });
  }

  static void _showDateTimePicker({
    required BuildContext context,
    required FormManagerOLD formManager,
    required String keyString,
  }) async {
    final now = DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime combined = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        final formattedText = Date.dateHourFormat.format(combined);
        formManager.onFieldChanged(keyString, formattedText);
      }
    }
  }

  static String? _onEditingComplete(
    final FormManagerOLD formManager,
    final String keyString,
    final String? Function(String) formatter,
    final RangeController? rangeController,
  ) {
    var field = formManager.formKey.currentState?.fields[keyString];

    final inputText = field?.value;
    String? formattedText;
    if (inputText != null) formattedText = formatter.call(inputText);

    // false: stops rangeValidator from triggering - because we only want rangeValidator to run in onEditingComplete
    // after Enter pressed where it is set to true
    // rangeController keeps it false and switches back to false after rangeValidator finished validating all fields in
    // the range
    rangeController?.isEditCompleted = true;

    KeyboardEvents.onEditTriggered();
    return formattedText;
  }

  static String makeRangeKeyStringStart(String rangeKeyString) => "${rangeKeyString}_start";

  static String makeRangeKeyStringEnd(String rangeKeyString) => "${rangeKeyString}_end";

  static String makeDateKeyString(String rangePartKeyString) => "${rangePartKeyString}_date";

  static String mameTimeKeyString(String rangePartKeyString) => "${rangePartKeyString}_time";

  static String rangeDateStartKeyString(String rangeKeyString) =>
      makeDateKeyString(makeRangeKeyStringStart(rangeKeyString));

  static String rangeTimeStartKeyString(String rangeKeyString) =>
      mameTimeKeyString(makeRangeKeyStringStart(rangeKeyString));

  static String rangeDateEndKeyString(String rangeKeyString) =>
      makeDateKeyString(makeRangeKeyStringEnd(rangeKeyString));

  static String rangeTimeEndKeyString(String rangeKeyString) =>
      mameTimeKeyString(makeRangeKeyStringEnd(rangeKeyString));
}
