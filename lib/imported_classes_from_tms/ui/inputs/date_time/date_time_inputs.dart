import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/imported_classes_from_tms/ui/inputs/date_time/time_formatter_validator.dart';

import '../../../misc/time_stamp.dart';
import '../../buttons/buttons.dart';
import '../../forms/form_manager/form_manager.dart';
import '../../shortcuts/keyboard_shortcuts.dart';
import '../base/double_widget_states_controller.dart';
import '../base/e_input_name_position.dart';
import '../base/input_validator_provider.dart';
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
    required final String keyString,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
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
    final BuildContext? context,
  }) {
    DoubleWidgetStatesController statesController = DoubleWidgetStatesController();

    ValueListenableBuilder iconButton = Buttons.iconButtonStateAware(
      iconData: Icons.arrow_drop_down,
      tooltip: Tr.get.openDatePicker,
      onPressed: readonly ? null : () => _showDatePicker(context!, formManager, keyString),
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
      inputWidth: AppSize.inputDateWidth,
      onChanged: onChanged,
      button: iconButton,
      statesController: statesController,
    );
  }

  static Widget time({
    required final String keyString,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
    final Time? initialValue,
    final bool readonly = false,
    final bool isRequired = false,
    final List<String>? linkedFields,
    final ValueChanged<String?>? onChanged,
    final RangeController? rangeController,
    final FormFieldValidator<String>? rangeValidator,
    final List<FormFieldValidator<String>>? additionalValidators,
    final BuildContext? context,
  }) {
    DoubleWidgetStatesController statesController = DoubleWidgetStatesController();

    ValueListenableBuilder iconButton = Buttons.iconButtonStateAware(
      iconData: Icons.arrow_drop_down,
      tooltip: Tr.get.openTimePicker,
      onPressed: () => _showTimePicker(context!, formManager, keyString),
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
      inputWidth: AppSize.inputTimeWidth,
      button: iconButton,
      statesController: statesController,
    );
  }

  static Widget dateTimeSeparateFields({
    required final String keyString,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
    final bool isDateRequired = false,
    final bool isTimeRequired = false,
    final RangeController? rangeController,
    final Date? initialDate,
    final Time? initialTime,
    final bool readonly = false,
    final BuildContext? context,
    final List<FormFieldValidator<String>>? additionalValidators,
  }) {
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
        keyString: dateKeyString,
        label: Tr.get.date,
        labelPosition: EInputLabelPosition.topLeft,
        initialValue: initialDate,
        readonly: readonly,
        formManager: formManager,
        isRequired: isDateRequired,
        context: context,
        rangeController: rangeController,
        rangeValidator: rangeDateValidator,
        additionalValidators: additionalValidators,
      ),
      AppSize.spacerBoxHorizontalSmallest,
      time(
        keyString: timeKeyString,
        label: Tr.get.time,
        labelPosition: EInputLabelPosition.topLeft,
        initialValue: initialTime,
        readonly: readonly,
        formManager: formManager,
        isRequired: isTimeRequired,
        context: context,
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
    required final String rangeId,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
    final bool readonly = false,
    final Date? initialRangeStartDate,
    final Time? initialRangeStartTime,
    final Date? initialRangeEndDate,
    final Time? initialRangeEndTime,
    final BuildContext? context,
  }) {
    var rangeController = RangeController(rangeId);

    final rangeStart = dateTimeSeparateFields(
      keyString: makeRangeKeyStringStart(rangeId),
      label: "$label ${Tr.get.start}",
      labelPosition: labelPosition,
      initialDate: initialRangeStartDate,
      initialTime: initialRangeStartTime,
      formManager: formManager,
      context: context,
      rangeController: rangeController,
      isDateRequired: true,
    );
    final rangeEnd = dateTimeSeparateFields(
      keyString: makeRangeKeyStringEnd(rangeId),
      label: "$label ${Tr.get.end}",
      labelPosition: labelPosition,
      initialDate: initialRangeEndDate,
      initialTime: initialRangeEndTime,
      formManager: formManager,
      context: context,
      rangeController: rangeController,
    );
    return Row(children: [rangeStart, AppSize.spacerBoxHorizontalMedium, rangeEnd]);
  }

  static Widget dateTimeOneField({
    required final String keyString,
    required final String label,
    required final EInputLabelPosition labelPosition,
    required final FormManager formManager,
    final DateTime? initialValue,
    final bool readonly = false,
    final bool isRequired = false,
    final List<String>? linkedFields,
    final ValueChanged<String?>? onChanged,
    final VoidCallback? onDateHourChange,
    final List<FormFieldValidator<String>>? additionalValidators,
    final BuildContext? context,
  }) {
    DoubleWidgetStatesController statesController = DoubleWidgetStatesController();

    ValueListenableBuilder iconButton = Buttons.iconButtonStateAware(
      iconData: Icons.arrow_drop_down,
      tooltip: '${Tr.get.openTimePicker} ${Tr.get.and} ${Tr.get.openTimePicker}',
      onPressed: () => _showDateTimePicker(context!, formManager, keyString),
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

  static void _showDatePicker(final BuildContext context, final FormManager formManager, final String keyString) {
    final now = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(AppParams.maxDateSpan),
      lastDate: now.add(AppParams.maxDateSpan),
    ).then((value) {
      if (value != null) {
        // TODO connect to rangeValidator
        final formattedText = Date.dateFormat.format(value);
        formManager.onFieldChanged(keyString, formattedText);
      }
    });
  }

  static void _showTimePicker(final BuildContext context, final FormManager formManager, final String timeKey) {
    showTimePicker(context: context, initialTime: TimeOfDay.now().replacing(minute: 0)).then((value) {
      if (value != null) {
        // TODO connect to rangeValidator
        final formattedText =
            Date.timeFormatMinutePrecision.format(DateTime.now().copyWith(minute: value.minute, hour: value.hour));
        formManager.onFieldChanged(timeKey, formattedText);
      }
    });
  }

  static void _showDateTimePicker(
      final BuildContext context, final FormManager formManager, final String keyString) async {
    final DateTime now = DateTime.now();
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
    final FormManager formManager,
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
