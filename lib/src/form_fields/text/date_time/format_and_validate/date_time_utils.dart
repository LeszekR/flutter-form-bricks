import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:flutter_form_bricks/src/utils/string_extension.dart';
import 'package:intl/intl.dart';

enum DateTimeOrBoth {
  date,
  time,
  dateTime,
}

const int minutesInMonth = 43920; // 60*24*30.5
const int minutesInYear = 525600; // 60*24*365
const int minutesInDay = 1440;
const int minutesInHour = 60;

class DateTimeUtils {
  static final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  static final DateFormat timeFormatMinutePrecision = DateFormat("HH:mm");
  static final DateFormat timeFormatSecondPrecision = DateFormat("HH:mm:ss");
  static final DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");

  static DateTimeUtils? _instance;

  DateTimeUtils._();

  factory DateTimeUtils() {
    _instance ??= DateTimeUtils._();
    return _instance!;
  }

  DateTimeFieldContent cleanDateTimeString({
    required BricksLocalizations bricksLocalizations,
    required TextEditingValue textEditingValue,
    required DateTimeOrBoth dateTimeOrBoth,
    required String stringDelimiterPattern,
    required String stringDelimiter,
    required int minNumberOfDigits,
    required int maxNDigits,
    required int maxNumberDelimiters,
  }) {
    // text must contain allowed chars only
    RegExp allowedRegex = RegExp('([0-9]|$stringDelimiterPattern)');
    var allowedCharsLength = allowedRegex.allMatches(textEditingValue.text).length;
    if (allowedCharsLength < textEditingValue.text.length)
      return DateTimeFieldContent.err(textEditingValue, errMsgForbiddenChars(bricksLocalizations, dateTimeOrBoth));

    // remove forbidden chars
    // replace all delimiter-type elements and groups with single '-'
    String textClean = textEditingValue.text;
    textClean = textClean.trim();
    textClean = textClean.replaceAll(RegExp('$stringDelimiterPattern+'), stringDelimiter);
    textClean = textClean.replaceAll(RegExp('$stringDelimiter+'), stringDelimiter);
    textClean = textClean.replaceAll(RegExp(' '), ''); // in case space was removed from delimiter pattern above
    textClean = textClean.replaceFirst(RegExp('^$stringDelimiter'), '');
    textClean = textClean.replaceFirst(RegExp('$stringDelimiter\$'), '');

    // too many groups of digits
    var nDelimiters = RegExp(stringDelimiter).allMatches(textClean).length;
    if (nDelimiters > maxNumberDelimiters)
      return DateTimeFieldContent.err(textEditingValue, erMsgTooManyDelimiters(bricksLocalizations, dateTimeOrBoth));

    // too few digits or too many digits
    var nDigits = RegExp('[0-9]').allMatches(textEditingValue.text).length;
    if (nDigits + nDelimiters < minNumberOfDigits)
      return DateTimeFieldContent.err(textEditingValue, errMsgTooFewDigits(bricksLocalizations, dateTimeOrBoth));
    if (nDigits > maxNDigits && nDelimiters == 0)
      return DateTimeFieldContent.err(textEditingValue, errMsgTooManyDigits(bricksLocalizations, dateTimeOrBoth));

    return DateTimeFieldContent.transient(textClean.txtEditVal());
  }

  // String removeBadChars(String text, String stringDelimiterPattern) {
  //   var textClean = '', nextChar = '';
  //   var regExp = RegExp('[0-9]|$stringDelimiterPattern');
  //   for (int i = 0; i < text.length; i++) {
  //     nextChar = text.substring(i, i + 1);
  //     if (regExp.hasMatch(nextChar)) textClean = textClean + nextChar;
  //   }
  //   return textClean;
  // }

  @visibleForTesting
  String errMsgForbiddenChars(BricksLocalizations localizations, DateTimeOrBoth eDateTime) {
    if (eDateTime == DateTimeOrBoth.date) {
      return localizations.dateStringErrorBadChars;
    }
    return localizations.timeStringErrorBadChars;
  }

  @visibleForTesting
  String errMsgTooFewDigits(BricksLocalizations localizations, DateTimeOrBoth eDateTime) {
    if (eDateTime == DateTimeOrBoth.date) {
      return localizations.dateStringErrorTooFewDigits;
    }
    return localizations.timeStringErrorTooFewDigits;
  }

  @visibleForTesting
  String errMsgTooManyDigits(BricksLocalizations localizations, DateTimeOrBoth eDateTime) {
    if (eDateTime == DateTimeOrBoth.date) {
      return localizations.dateStringErrorTooManyDigits;
    }
    return localizations.timeStringErrorTooManyDigits;
  }

  @visibleForTesting
  String erMsgTooManyDelimiters(BricksLocalizations localizations, DateTimeOrBoth eDateTime) {
    if (eDateTime == DateTimeOrBoth.date) {
      return localizations.dateStringErrorTooManyDelimiters;
    }
    return localizations.timeStringErrorTooManyDelimiters;
  }

  String addErrMsg(String errMsg, String connector, String nextErrorMessage) {
    return (errMsg.isEmpty ? '' : (errMsg + connector)) + nextErrorMessage;
  }

  // TODO make all helper methods static, possibly abstract methods being part of formattervalidator to another class?
  DateTime fromDateTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  DateTime dateFromString(String stringVal) {
    return dateFormat.parseStrict(stringVal);
  }

  DateTime timeMinutePrecisionFromString(String stringVal) {
    return timeFormatMinutePrecision.parseStrict(stringVal);
  }

  DateTime timeSecondPrecisionFromString(String stringVal) {
    return timeFormatSecondPrecision.parseStrict(stringVal);
  }

  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String minutesToSpanCondition(int nMinutes) {
    String years = '${nMinutes ~/ minutesInYear} years';
    if (nMinutes % minutesInYear == 0) return years;

    String months = '${(nMinutes % minutesInYear) ~/ minutesInMonth} months';
    if (nMinutes % minutesInMonth == 0) return '$years, $months';

    String days = '${(nMinutes % minutesInMonth) ~/ minutesInDay} days';
    if (nMinutes % minutesInDay == 0) return '$years, $months, $days';

    String hours = '${(nMinutes % minutesInDay) ~/ minutesInHour} hours';
    if (nMinutes % minutesInHour == 0) return '$years, $months, $days, $hours';

    String minutes = '${nMinutes % minutesInHour} minutes';
    return '$years, $months, $days, $hours, $minutes';
  }

  DateTime replaceTime(DateTime dateSource, String timeString) {
    final parts = timeString.split(':');

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(
      dateSource.year,
      dateSource.month,
      dateSource.day,
      hour,
      minute,
    );
  }

  int timeInMinutes(DateTime timeSource) {
    int hourMinutes = timeSource.hour * 60;
    int minutes = timeSource.minute;
    return hourMinutes + minutes;
  }

  /// [FieldContent.transient] has `isValid=null` but should be accepted as valid to be processed further
  bool isValid(FieldContent dateContent) {
    return dateContent.isValid ?? true;
  }

  DateTime mergeDateAndTime(DateTime date, DateTime time) => DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
        time.second,
      );

  static bool isDateField(String keyString) => keyString.contains(datePostfix);

  static bool isTimeField(String keyString) => keyString.contains(timePostfix);

  static bool isStartDateField(String keyString) => keyString.contains(startPostfix) && isDateField(keyString);

  static bool isStartTimeField(String keyString) => keyString.contains(startPostfix) && isTimeField(keyString);

  static bool isEndDateField(String keyString) => keyString.contains(endPostfix) && isDateField(keyString);

  static bool isEndTimeField(String keyString) => keyString.contains(endPostfix) && isTimeField(keyString);

// leave tilda as prefix for those to guarantee the postfixes to be app-unique.
// (the constructor here makes sure tilda will never be used in keyString itself)
  static const String startPostfix = '~start';
  static const String endPostfix = '~end';
  static const String datePostfix = '~date';
  static const String timePostfix = '~time';

  static String makeRangeKeyStringStart(String rangeKeyString) => "${rangeKeyString}$startPostfix";

  static String makeRangeKeyStringEnd(String rangeKeyString) => "${rangeKeyString}$endPostfix";

  static String makeDateKeyString(String rangePartKeyString) => "${rangePartKeyString}$datePostfix";

  static String makeTimeKeyString(String rangePartKeyString) => "${rangePartKeyString}$timePostfix";

  static String rangeDateStartKeyString(String rangeKeyString) =>
      makeDateKeyString(makeRangeKeyStringStart(rangeKeyString));

  static String rangeTimeStartKeyString(String rangeKeyString) =>
      makeTimeKeyString(makeRangeKeyStringStart(rangeKeyString));

  static String rangeDateEndKeyString(String rangeKeyString) =>
      makeDateKeyString(makeRangeKeyStringEnd(rangeKeyString));

  static String rangeTimeEndKeyString(String rangeKeyString) =>
      makeTimeKeyString(makeRangeKeyStringEnd(rangeKeyString));
}
