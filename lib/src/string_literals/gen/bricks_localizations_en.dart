// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'bricks_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class BricksLocalizationsEn extends BricksLocalizations {
  BricksLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get buttonYes => 'Yes';

  @override
  String get buttonNo => 'No';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonDelete => 'Delete';

  @override
  String get buttonChange => 'Change';

  @override
  String get buttonReset => 'Reset';

  @override
  String get dialogsWarning => 'Warning';

  @override
  String get dialogsSuccess => 'Success';

  @override
  String get dialogsError => 'Error';

  @override
  String get dialogsDecision => 'Reset form';

  @override
  String get progressPleaseWait => 'Please wait';

  @override
  String get dialogsSaveSuccess => 'Your data has been saved';

  @override
  String get dialogsDeleteSuccess => 'Your data has been deleted';

  @override
  String get dialogsNoChanges => 'There is nothing to save';

  @override
  String get dialogsFinishOrCorrect => 'Correct or finish filling the data';

  @override
  String get dialogsConfirmCancel =>
      'If you confirm all changes will be deleted.\nContinue?';

  @override
  String validationMessageRequired(Object field, String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': ' required',
        'female': ' required',
        'other': ' required',
      },
    );
    return '$field is $_temp0';
  }

  @override
  String validationDecimal(num field) {
    String _temp0 = intl.Intl.pluralLogic(
      field,
      locale: localeName,
      other: '# decimal places',
      one: '1 decimal place',
    );
    return 'Only positive decimal numbers with $_temp0';
  }

  @override
  String get validationInteger => 'Only positive integers';

  @override
  String get validationPasswordOldNew =>
      'The new password must be different from the old one';

  @override
  String get validationPasswordPassRepeatPass =>
      'Password and confirm password must match';

  @override
  String get openDatePicker => 'Open calendar';

  @override
  String get openTimePicker => 'Open clock';

  @override
  String get and => 'and';

  @override
  String get date => 'date';

  @override
  String get time => 'time';

  @override
  String get start => 'start';

  @override
  String get end => 'end';

  @override
  String get delete => 'Delete';

  @override
  String get reset => 'Reset';

  @override
  String get save => 'Save';

  @override
  String get formReset => 'Form reset';

  @override
  String get formResetConfirm =>
      'If you click OK all changes will be discarded\nContinue?';

  @override
  String get deleteConfirm => 'Are you sure you want to delete it?';

  @override
  String get requiredField => 'Required field';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get invalidVAT => 'Invalid VAT number';

  @override
  String minNChars(Object charsMinimumN) {
    return 'Required min. $charsMinimumN characters';
  }

  @override
  String maxNChars(Object charsMinimumN) {
    return 'Required max. $charsMinimumN characters';
  }

  @override
  String minIntValue(Object IntValueMinimum) {
    return 'Minimum value must not be lower than $IntValueMinimum';
  }

  @override
  String maxIntValue(Object IntValueMaximum) {
    return 'Maximum value must not exceed $IntValueMaximum';
  }

  @override
  String get rangeDateStartRequired => 'Missing start-date';

  @override
  String get rangeDateEndRequiredOrRemoveTimeEnd =>
      'Add end-date or remove end-time';

  @override
  String get rangeDateStartAfterEnd => 'End-date precedes start-date';

  @override
  String get rangeTimeStartAfterEndOrAddDateEnd =>
      'Add end-date or make end-time later than start-time';

  @override
  String get rangeTimeStartAfterEnd => 'Start-time is after end-time';

  @override
  String rangeTimeStartEndTooCloseOrAddDateEnd(Object timesMinDifference) {
    return 'Add end-date or make end-time at least $timesMinDifference min after start-time';
  }

  @override
  String rangeTimeStartEndTooCloseSameDate(Object timesMinDifference) {
    return 'End-time must be at least $timesMinDifference min after start-time';
  }

  @override
  String rangeDatesTooFarApart(int maxDatesDifference) {
    return 'Dates must not be more than $maxDatesDifference min after start-time';
  }

  @override
  String get rangeStartSameAsEnd =>
      'Start is identical to End - change or remove End date / time';

  @override
  String get dateStringErrorBadChars => 'Characters not allowed for date';

  @override
  String get dateStringErrorTooFewDigits => 'Too few digits for date';

  @override
  String get dateStringErrorTooManyDigits => 'Too many digits for date';

  @override
  String get dateStringErrorTooManyDelimiters => 'Too many delimiters for date';

  @override
  String get dateStringErrorTooManyDigitsDay => 'Too many digits for day';

  @override
  String get dateStringErrorTooManyDigitsMonth => 'Too many digits for month';

  @override
  String get dateStringErrorTooManyDigitsYear => 'Too many digits for year';

  @override
  String get dateErrorDay0 => 'There is no day 0';

  @override
  String get dateErrorMonth0 => 'There is no month 0';

  @override
  String get dateErrorTooManyDaysInMonth => 'Too many days in month';

  @override
  String get dateErrorMonthOver12 => 'There are only 12 months, not more';

  @override
  String dateErrorYearTooFarBack(int dateMaxYearsBack) {
    return 'You can not input year before $dateMaxYearsBack';
  }

  @override
  String dateErrorYearTooFarForward(int dateMaxYearsForward) {
    return 'You can not input year after $dateMaxYearsForward';
  }

  @override
  String get mustNotPrecede => 'must not precede';

  @override
  String get timeStringErrorBadChars => 'Characters not allowed for time';

  @override
  String get timeStringErrorTooFewDigits => 'Too few digits for time';

  @override
  String get timeStringErrorTooManyDigits => 'Too many digits for time';

  @override
  String get timeStringErrorTooManyDelimiters => 'Too many delimiters for time';

  @override
  String get timeStringErrorTooManyDigitsMinutes =>
      'Too many digits for minutes';

  @override
  String get timeStringErrorTooManyDigitsHours => 'Too many digits for hours';

  @override
  String get timeErrorTooBigMinute =>
      'Too high minutes number - no such time exists';

  @override
  String get timeErrorTooBigHour =>
      'Too high hours number - no such time exists (midnight is 00:00)';

  @override
  String get datetimeStringErrorNoSpace =>
      'Date must be separated from time with space';

  @override
  String get datetimeStringErrorTooManySpaces => 'Too many spaces';
}
