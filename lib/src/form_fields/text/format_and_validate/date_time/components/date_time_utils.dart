import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/time_stamp.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
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
  static DateTimeUtils? _instance;

  DateTimeUtils._();

  factory DateTimeUtils() {
    _instance ??= DateTimeUtils._();
    return _instance!;
  }

  DateTimeFieldContent cleanDateTimeString({
    required BricksLocalizations bricksLocalizations,
    required String text,
    required DateTimeOrBoth dateTimeOrBoth,
    required String stringDelimiterPattern,
    required String stringDelimiter,
    required int minNumberOfDigits,
    required int maxNDigits,
    required int maxNumberDelimiters,
  }) {
    // text must contain allowed chars only
    RegExp allowedRegex = RegExp('([0-9]|$stringDelimiterPattern)');
    var allowedCharsLength = allowedRegex.allMatches(text).length;
    if (allowedCharsLength < text.length)
      return DateTimeFieldContent.err(text, errMsgForbiddenChars(bricksLocalizations, dateTimeOrBoth));

    // remove forbidden chars
    // replace all delimiter-type elements and groups with single '-'
    String textClean = text;
    textClean = textClean.trim();
    textClean = textClean.replaceAll(RegExp('$stringDelimiterPattern+'), stringDelimiter);
    textClean = textClean.replaceAll(RegExp('$stringDelimiter+'), stringDelimiter);
    textClean = textClean.replaceAll(RegExp(' '), ''); // in case space was removed from delimiter pattern above
    textClean = textClean.replaceFirst(RegExp('^$stringDelimiter'), '');
    textClean = textClean.replaceFirst(RegExp('$stringDelimiter\$'), '');

    // too many groups of digits
    var nDelimiters = RegExp(stringDelimiter).allMatches(textClean).length;
    if (nDelimiters > maxNumberDelimiters)
      return DateTimeFieldContent.err(text, erMsgTooManyDelimiters(bricksLocalizations, dateTimeOrBoth));

    // too few digits or too many digits
    var nDigits = RegExp('[0-9]').allMatches(text).length;
    if (nDigits + nDelimiters < minNumberOfDigits)
      return DateTimeFieldContent.err(text, errMsgTooFewDigits(bricksLocalizations, dateTimeOrBoth));
    if (nDigits > maxNDigits && nDelimiters == 0)
      return DateTimeFieldContent.err(text, errMsgTooManyDigits(bricksLocalizations, dateTimeOrBoth));

    return DateTimeFieldContent.ok(textClean, null);
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
    // TODO what about date-time field?
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

  String formatDate(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
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
}
