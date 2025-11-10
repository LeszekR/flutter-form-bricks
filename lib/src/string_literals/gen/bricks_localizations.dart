import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'bricks_localizations_en.dart';
import 'bricks_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of BricksLocalizations
/// returned by `BricksLocalizations.of(context)`.
///
/// Applications need to include `BricksLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/bricks_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: BricksLocalizations.localizationsDelegates,
///   supportedLocales: BricksLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the BricksLocalizations.supportedLocales
/// property.
abstract class BricksLocalizations {
  BricksLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static BricksLocalizations of(BuildContext context) {
    return Localizations.of<BricksLocalizations>(context, BricksLocalizations)!;
  }

  static const LocalizationsDelegate<BricksLocalizations> delegate =
      _BricksLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// No description provided for @buttonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get buttonYes;

  /// No description provided for @buttonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get buttonNo;

  /// No description provided for @buttonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get buttonOk;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// No description provided for @buttonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get buttonDelete;

  /// No description provided for @buttonChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get buttonChange;

  /// No description provided for @buttonReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get buttonReset;

  /// No description provided for @dialogsWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get dialogsWarning;

  /// No description provided for @dialogsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get dialogsSuccess;

  /// No description provided for @dialogsError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get dialogsError;

  /// No description provided for @dialogsDecision.
  ///
  /// In en, this message translates to:
  /// **'Reset form'**
  String get dialogsDecision;

  /// No description provided for @progressPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get progressPleaseWait;

  /// No description provided for @dialogsSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your data has been saved'**
  String get dialogsSaveSuccess;

  /// No description provided for @dialogsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your data has been deleted'**
  String get dialogsDeleteSuccess;

  /// No description provided for @dialogsNoChanges.
  ///
  /// In en, this message translates to:
  /// **'There is nothing to save'**
  String get dialogsNoChanges;

  /// No description provided for @dialogsFinishOrCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct or finish filling the data'**
  String get dialogsFinishOrCorrect;

  /// No description provided for @dialogsConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'If you confirm all changes will be deleted.\nContinue?'**
  String get dialogsConfirmCancel;

  /// No description provided for @validationMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is {gender, select, male { required} female { required} other { required}}'**
  String validationMessageRequired(Object field, String gender);

  /// No description provided for @validationDecimal.
  ///
  /// In en, this message translates to:
  /// **'Only positive decimal numbers with {field, plural, one {1 decimal place} other {# decimal places}}'**
  String validationDecimal(num field);

  /// No description provided for @validationInteger.
  ///
  /// In en, this message translates to:
  /// **'Only positive integers'**
  String get validationInteger;

  /// No description provided for @validationPasswordOldNew.
  ///
  /// In en, this message translates to:
  /// **'The new password must be different from the old one'**
  String get validationPasswordOldNew;

  /// No description provided for @validationPasswordPassRepeatPass.
  ///
  /// In en, this message translates to:
  /// **'Password and confirm password must match'**
  String get validationPasswordPassRepeatPass;

  /// No description provided for @openDatePicker.
  ///
  /// In en, this message translates to:
  /// **'Open calendar'**
  String get openDatePicker;

  /// No description provided for @openTimePicker.
  ///
  /// In en, this message translates to:
  /// **'Open clock'**
  String get openTimePicker;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'time'**
  String get time;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'end'**
  String get end;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @formReset.
  ///
  /// In en, this message translates to:
  /// **'Form reset'**
  String get formReset;

  /// No description provided for @formResetConfirm.
  ///
  /// In en, this message translates to:
  /// **'If you click OK all changes will be discarded\nContinue?'**
  String get formResetConfirm;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete it?'**
  String get deleteConfirm;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @invalidVAT.
  ///
  /// In en, this message translates to:
  /// **'Invalid VAT number'**
  String get invalidVAT;

  /// No description provided for @minNChars.
  ///
  /// In en, this message translates to:
  /// **'Required min. {charsMinimumN} characters'**
  String minNChars(Object charsMinimumN);

  /// No description provided for @maxNChars.
  ///
  /// In en, this message translates to:
  /// **'Required max. {charsMinimumN} characters'**
  String maxNChars(Object charsMinimumN);

  /// No description provided for @minIntValue.
  ///
  /// In en, this message translates to:
  /// **'Minimum value must not be lower than {IntValueMinimum}'**
  String minIntValue(Object IntValueMinimum);

  /// No description provided for @maxIntValue.
  ///
  /// In en, this message translates to:
  /// **'Maximum value must not exceed {IntValueMaximum}'**
  String maxIntValue(Object IntValueMaximum);

  /// No description provided for @rangeDateStartRequired.
  ///
  /// In en, this message translates to:
  /// **'Missing start-date'**
  String get rangeDateStartRequired;

  /// No description provided for @rangeDateEndRequiredOrRemoveTimeEnd.
  ///
  /// In en, this message translates to:
  /// **'Add end-date or remove end-time'**
  String get rangeDateEndRequiredOrRemoveTimeEnd;

  /// No description provided for @rangeDateStartAfterEnd.
  ///
  /// In en, this message translates to:
  /// **'End-date precedes start-date'**
  String get rangeDateStartAfterEnd;

  /// No description provided for @rangeTimeStartAfterEndOrAddDateEnd.
  ///
  /// In en, this message translates to:
  /// **'Add end-date or make end-time later than start-time'**
  String get rangeTimeStartAfterEndOrAddDateEnd;

  /// No description provided for @rangeTimeStartAfterEnd.
  ///
  /// In en, this message translates to:
  /// **'Start-time is after end-time'**
  String get rangeTimeStartAfterEnd;

  /// No description provided for @rangeTimeStartEndTooCloseOrAddDateEnd.
  ///
  /// In en, this message translates to:
  /// **'Add end-date or make end-time at least {timesMinDifference} min after start-time'**
  String rangeTimeStartEndTooCloseOrAddDateEnd(Object timesMinDifference);

  /// No description provided for @rangeTimeStartEndTooCloseSameDate.
  ///
  /// In en, this message translates to:
  /// **'End-time must be at least {timesMinDifference} min after start-time'**
  String rangeTimeStartEndTooCloseSameDate(Object timesMinDifference);

  /// No description provided for @rangeDatesTooFarApart.
  ///
  /// In en, this message translates to:
  /// **'Dates must not be more than {maxDatesDifference} min after start-time'**
  String rangeDatesTooFarApart(int maxDatesDifference);

  /// No description provided for @rangeStartSameAsEnd.
  ///
  /// In en, this message translates to:
  /// **'Start is identical to End - change or remove End date / time'**
  String get rangeStartSameAsEnd;

  /// No description provided for @dateStringErrorBadChars.
  ///
  /// In en, this message translates to:
  /// **'Characters not allowed for date'**
  String get dateStringErrorBadChars;

  /// No description provided for @dateStringErrorTooFewDigits.
  ///
  /// In en, this message translates to:
  /// **'Too few digits for date'**
  String get dateStringErrorTooFewDigits;

  /// No description provided for @dateStringErrorTooManyDigits.
  ///
  /// In en, this message translates to:
  /// **'Too many digits for date'**
  String get dateStringErrorTooManyDigits;

  /// No description provided for @dateStringErrorTooManyDelimiters.
  ///
  /// In en, this message translates to:
  /// **'Too many delimiters for date'**
  String get dateStringErrorTooManyDelimiters;

  /// No description provided for @dateStringErrorTooManyDigitsDay.
  ///
  /// In en, this message translates to:
  /// **'Too many digits for day'**
  String get dateStringErrorTooManyDigitsDay;

  /// No description provided for @dateStringErrorTooManyDigitsMonth.
  ///
  /// In en, this message translates to:
  /// **'Too many digits for month'**
  String get dateStringErrorTooManyDigitsMonth;

  /// No description provided for @dateStringErrorTooManyDigitsYear.
  ///
  /// In en, this message translates to:
  /// **'Too many digits for year'**
  String get dateStringErrorTooManyDigitsYear;

  /// No description provided for @dateErrorDay0.
  ///
  /// In en, this message translates to:
  /// **'There is no day 0'**
  String get dateErrorDay0;

  /// No description provided for @dateErrorMonth0.
  ///
  /// In en, this message translates to:
  /// **'There is no month 0'**
  String get dateErrorMonth0;

  /// No description provided for @dateErrorTooManyDaysInMonth.
  ///
  /// In en, this message translates to:
  /// **'Too many days in month'**
  String get dateErrorTooManyDaysInMonth;

  /// No description provided for @dateErrorMonthOver12.
  ///
  /// In en, this message translates to:
  /// **'There are only 12 months, not more'**
  String get dateErrorMonthOver12;

  /// No description provided for @dateErrorTooFarBack.
  ///
  /// In en, this message translates to:
  /// **'Date and time must not be earlier than {minDateParam}'**
  String dateErrorTooFarBack(String minDateParam);

  /// No description provided for @dateErrorTooFarForward.
  ///
  /// In en, this message translates to:
  /// **'Date and time must not be later than {maxDateParam}'**
  String dateErrorTooFarForward(String maxDateParam);

  /// No description provided for @mustNotPrecede.
  ///
  /// In en, this message translates to:
  /// **'must not precede'**
  String get mustNotPrecede;

  /// No description provided for @timeStringErrorBadChars.
  ///
  /// In en, this message translates to:
  /// **'Characters not allowed for time'**
  String get timeStringErrorBadChars;

  /// No description provided for @timeStringErrorTooFewDigits.
  ///
  /// In en, this message translates to:
  /// **'Too few digits for time'**
  String get timeStringErrorTooFewDigits;

  /// No description provided for @timeStringErrorTooManyDigits.
  ///
  /// In en, this message translates to:
  /// **'Too many digits for time'**
  String get timeStringErrorTooManyDigits;

  /// No description provided for @timeStringErrorTooManyDelimiters.
  ///
  /// In en, this message translates to:
  /// **'Too many delimiters for time'**
  String get timeStringErrorTooManyDelimiters;

  /// No description provided for @timeStringErrorTooManyDigitsMinutes.
  ///
  /// In en, this message translates to:
  /// **'Too many digits for minutes'**
  String get timeStringErrorTooManyDigitsMinutes;

  /// No description provided for @timeStringErrorTooManyDigitsHours.
  ///
  /// In en, this message translates to:
  /// **'Too many digits for hours'**
  String get timeStringErrorTooManyDigitsHours;

  /// No description provided for @timeErrorTooBigMinute.
  ///
  /// In en, this message translates to:
  /// **'Too high minutes number - no such time exists'**
  String get timeErrorTooBigMinute;

  /// No description provided for @timeErrorTooBigHour.
  ///
  /// In en, this message translates to:
  /// **'Too high hours number - no such time exists (midnight is 00:00)'**
  String get timeErrorTooBigHour;

  /// No description provided for @datetimeStringErrorNoSpace.
  ///
  /// In en, this message translates to:
  /// **'Date must be separated from time with space'**
  String get datetimeStringErrorNoSpace;

  /// No description provided for @datetimeStringErrorTooManySpaces.
  ///
  /// In en, this message translates to:
  /// **'Too many spaces'**
  String get datetimeStringErrorTooManySpaces;
}

class _BricksLocalizationsDelegate
    extends LocalizationsDelegate<BricksLocalizations> {
  const _BricksLocalizationsDelegate();

  @override
  Future<BricksLocalizations> load(Locale locale) {
    return SynchronousFuture<BricksLocalizations>(
        lookupBricksLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_BricksLocalizationsDelegate old) => false;
}

BricksLocalizations lookupBricksLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return BricksLocalizationsEn();
    case 'pl':
      return BricksLocalizationsPl();
  }

  throw FlutterError(
      'BricksLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
