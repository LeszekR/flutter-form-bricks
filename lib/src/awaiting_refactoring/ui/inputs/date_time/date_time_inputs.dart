import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/dateTime_formatter_validator.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/inputs/states_controller/double_widget_states_controller.dart';

import '../../buttons/buttons.dart';
import '../../forms/form_manager/form_manager.dart';
import '../../shortcuts/keyboard_shortcuts.dart';
import 'date_time_validators.dart';
import 'formatter_validators/dateTime_range_error_controller.dart';
import 'formatter_validators/date_formatter_validator.dart';

class DateTimeInputs {
  static final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  static final CurrentDate _currentDate = CurrentDate();
  static final DateFormatterValidator _dateFormatter = DateFormatterValidator(_dateTimeUtils, _currentDate);
  static final TimeFormatterValidator _timeFormatter = TimeFormatterValidator(_dateTimeUtils);
  static final DateTimeFormatterValidator _dateTimeFormatter =
      DateTimeFormatterValidator(_dateFormatter, _timeFormatter, _dateTimeUtils);

  DateTimeInputs._();

  static Widget date({
    required BuildContext context,
    required String keyString,
    required String label,
    required LabelPosition labelPosition,
    required FormManagerOLD formManager,
    required CurrentDate currentDate,
    required DateTimeLimits dateLimits,
    Date? initialValue,
    bool readonly = false,
    bool isRequired = false,
    List<String>? linkedFields,
    ValueChanged<String?>? onChanged,
    RangeController? rangeController,
    FormFieldValidator<String>? rangeValidator,
    List<FormFieldValidator<String>>? additionalValidators,
  }) {
    final localizations = BricksLocalizations.of(context);
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;

    DoubleWidgetStatesController statesController = DoubleWidgetStatesController();

    ValueListenableBuilder iconButton = Buttons.iconButtonStateAware(
      context: context,
      iconData: Icons.arrow_drop_down,
      tooltip: localizations.openDatePicker,
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
      context: context,
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      initialValue: initialValue,
      readonly: readonly,
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: TextInputType.text,
      formManager: formManager,
      onEditingComplete: () => _onEditingComplete(
        formManager,
        keyString,
        (inputString) => _dateFormatter.makeDateString(localizations, currentDate, inputString, dateLimits),
        rangeController,
      ),
      validator: ValidatorProvider.compose(
        context: context,
        isRequired: isRequired,
        customValidator: rangeValidator ?? DateTimeValidators.dateInputValidator(localizations, dateLimits),
        // customValidator: /*rangeValidator ?? DateTimeValidators.dateInputValidator()*/ValidatorProvider.compose(minLength: 1),
        validatorsList: additionalValidators,
      ),
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
    Time? initialValue,
    bool readonly = false,
    bool isRequired = false,
    List<String>? linkedFields,
    ValueChanged<String?>? onChanged,
    RangeController? rangeController,
    FormFieldValidator<String>? rangeValidator,
    List<FormFieldValidator<String>>? additionalValidators,
  }) {
    final localizations = BricksLocalizations.of(context);
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;

    DoubleWidgetStatesController statesController = DoubleWidgetStatesController();

    ValueListenableBuilder iconButton = Buttons.iconButtonStateAware(
      context: context,
      iconData: Icons.arrow_drop_down,
      tooltip: localizations.openTimePicker,
      onPressed: () => _showTimePicker(
        context: context,
        keyString: keyString,
        formManager: formManager,
      ),
      statesController: statesController,
    );

    return BasicTextInput.basicTextInput(
      context: context,
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      initialValue: initialValue,
      readonly: readonly,
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: TextInputType.text,
      formManager: formManager,
      onEditingComplete: () => _onEditingComplete(
        formManager,
        keyString,
        (inputString) => _timeFormatter.makeTimeString(localizations, inputString),
        rangeController,
      ),
      validator: ValidatorProvider.compose(
        context: context,
        isRequired: isRequired,
        customValidator: rangeValidator ?? DateTimeValidators.timeInputValidator(localizations),
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
    required CurrentDate currentDate,
    required FormManagerOLD formManager,
    required DateTimeLimits dateTimeLimits,
    required int maxRangeSpanDays,
    required int minRangeSpanMinutes,
    bool isDateRequired = false,
    bool isTimeRequired = false,
    RangeController? rangeController,
    Date? initialDate,
    Time? initialTime,
    bool readonly = false,
    List<FormFieldValidator<String>>? additionalValidators,
  }) {
    final localizations = BricksLocalizations.of(context);
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;
    final appStyle = uiParams.appStyle;
    final appColor = uiParams.appColor;

    var dateKeyString = makeDateKeyString(keyString);
    var timeKeyString = mameTimeKeyString(keyString);

    FormFieldValidator<String>? rangeDateValidator;
    if (rangeController != null) {
      rangeDateValidator = DateTimeValidators.dateTimeRangeValidator(
        localizations,
        dateKeyString,
        formManager,
        rangeController,
        maxRangeSpanDays,
        minRangeSpanMinutes,
      );
// if (isDateRequired || additionalValidators != null) {
      var validatorsExceptRange = ValidatorProvider.compose(
        context: context,
        isRequired: isDateRequired,
        customValidator: DateTimeValidators.dateInputValidator(localizations, dateTimeLimits),
        validatorsList: additionalValidators,
      );
      rangeController.validatorExceptRange[dateKeyString] = validatorsExceptRange;
// }
    }
    FormFieldValidator<String>? rangeTimeValidator;
    if (rangeController != null) {
      rangeTimeValidator = DateTimeValidators.dateTimeRangeValidator(
        localizations,
        timeKeyString,
        formManager,
        rangeController,
        maxRangeSpanDays,
        minRangeSpanMinutes,
      );
      var validatorExceptRange = ValidatorProvider.compose(
        context: context,
        isRequired: isTimeRequired,
        customValidator: DateTimeValidators.timeInputValidator(localizations),
        validatorsList: additionalValidators,
      );
// if (isTimeRequired || additionalValidators != null) {
      rangeController.validatorExceptRange[timeKeyString] = validatorExceptRange;
// }
    }

    final elements = [
      date(
        context: context,
        keyString: dateKeyString,
        label: localizations.date,
        labelPosition: LabelPosition.topLeft,
        initialValue: initialDate,
        readonly: readonly,
        currentDate: currentDate,
        dateLimits: dateTimeLimits,
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
        label: localizations.time,
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
    required CurrentDate currentDate,
    required DateTimeLimits dateTimeLimits,
    required FormManagerOLD formManager,
    required int maxRangeSpanDays,
    required int minRangeSpanMinutes,
    final bool readonly = false,
    final Date? initialRangeStartDate,
    final Time? initialRangeStartTime,
    final Date? initialRangeEndDate,
    final Time? initialRangeEndTime,
  }) {
    final localizations = BricksLocalizations.of(context);
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;

    var rangeController = RangeController(rangeId);

    final rangeStart = dateTimeSeparateFields(
      context: context,
      keyString: makeRangeKeyStringStart(rangeId),
      label: "$label ${localizations.start}",
      labelPosition: labelPosition,
      initialDate: initialRangeStartDate,
      initialTime: initialRangeStartTime,
      formManager: formManager,
      dateTimeLimits: dateTimeLimits,
      maxRangeSpanDays: maxRangeSpanDays,
      minRangeSpanMinutes: minRangeSpanMinutes,
      currentDate: currentDate,
      rangeController: rangeController,
      isDateRequired: true,
    );
    final rangeEnd = dateTimeSeparateFields(
      context: context,
      keyString: makeRangeKeyStringEnd(rangeId),
      label: "$label ${localizations.end}",
      labelPosition: labelPosition,
      initialDate: initialRangeEndDate,
      initialTime: initialRangeEndTime,
      formManager: formManager,
      dateTimeLimits: dateTimeLimits,
      maxRangeSpanDays: maxRangeSpanDays,
      minRangeSpanMinutes: minRangeSpanMinutes,
      currentDate: currentDate,
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
    required CurrentDate currentDate,
    required DateTimeLimits dateTimeLimits,
    DateTime? initialValue,
    bool readonly = false,
    bool isRequired = false,
    List<String>? linkedFields,
    ValueChanged<String?>? onChanged,
    VoidCallback? onDateHourChange,
    List<FormFieldValidator<String>>? additionalValidators,
  }) {
    final localizations = BricksLocalizations.of(context);
    DoubleWidgetStatesController statesController = DoubleWidgetStatesController();

    ValueListenableBuilder iconButton = Buttons.iconButtonStateAware(
      context: context,
      iconData: Icons.arrow_drop_down,
      tooltip: '${localizations.openTimePicker} ${localizations.and} ${localizations.openTimePicker}',
      onPressed: () => _showDateTimePicker(context: context, keyString: keyString, formManager: formManager),
      statesController: statesController,
    );

    return BasicTextInput.basicTextInput(
      context: context,
      keyString: keyString,
      label: label,
      labelPosition: labelPosition,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: initialValue,
      readonly: false,
      formManager: formManager,
      onEditingComplete: () => _onEditingComplete(
        formManager,
        keyString,
        (String inputString) =>
            _dateTimeFormatter.makeDateTimeString(localizations, currentDate, inputString, dateTimeLimits),
        null,
      ),
      validator: ValidatorProvider.compose(
        context: context,
        customValidator: DateTimeValidators.dateTimeInputValidator(localizations, dateTimeLimits),
        validatorsList: additionalValidators,
      ),
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
        final formattedText = Date.timeFormatMinutePrecision.format(
          DateTime.now().copyWith(
            minute: value.minute,
            hour: value.hour,
          ),
        );
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
