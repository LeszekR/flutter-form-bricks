import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:intl/intl.dart';

enum DateTimeOrBoth {
  DATE,
  TIME,
  DATE_TIME,
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
    String result = text;
    result = result.trim();
    result = result.replaceAll(RegExp('$stringDelimiterPattern+'), stringDelimiter);
    result = result.replaceAll(RegExp('$stringDelimiter+'), stringDelimiter);
    result = result.replaceAll(RegExp(' '), ''); // in case space was removed from delimiter pattern above
    result = result.replaceFirst(RegExp('^$stringDelimiter'), '');
    result = result.replaceFirst(RegExp('$stringDelimiter\$'), '');

    // too many groups of digits
    var nDelimiters = RegExp(stringDelimiter).allMatches(result).length;
    if (nDelimiters > maxNumberDelimiters)
      return DateTimeFieldContent.err(text, getErMsgTooManyDelimiters(bricksLocalizations, dateTimeOrBoth));

    // too few digits or too many digits
    var nDigits = RegExp('[0-9]').allMatches(text).length;
    if (nDigits + nDelimiters < minNumberOfDigits)
      return DateTimeFieldContent.err(text, errMsgTooFewDigits(bricksLocalizations, dateTimeOrBoth));
    if (nDigits > maxNDigits && nDelimiters == 0)
      return DateTimeFieldContent.err(text, errMsgTooManyDigits(bricksLocalizations, dateTimeOrBoth));

    return DateTimeFieldContent.ok(result, null);
  }

  String removeBadChars(String text, String stringDelimiterPattern) {
    var textClean = '', nextChar = '';
    var regExp = RegExp('[0-9]|$stringDelimiterPattern');
    for (int i = 0; i < text.length; i++) {
      nextChar = text.substring(i, i + 1);
      if (regExp.hasMatch(nextChar)) textClean = textClean + nextChar;
    }
    return textClean;
  }

  String errMsgForbiddenChars(BricksLocalizations localizations, DateTimeOrBoth eDateTime) {
    if (eDateTime == DateTimeOrBoth.DATE) {
      return localizations.dateStringErrorBadChars;
    }
    return localizations.timeStringErrorBadChars;
  }

  String errMsgTooFewDigits(BricksLocalizations localizations, DateTimeOrBoth eDateTime) {
    if (eDateTime == DateTimeOrBoth.DATE) {
      return localizations.dateStringErrorTooFewDigits;
    }
    return localizations.timeStringErrorTooFewDigits;
  }

  String errMsgTooManyDigits(BricksLocalizations localizations, DateTimeOrBoth eDateTime) {
    if (eDateTime == DateTimeOrBoth.DATE) {
      return localizations.dateStringErrorTooManyDigits;
    }
    return localizations.timeStringErrorTooManyDigits;
  }

  String getErMsgTooManyDelimiters(BricksLocalizations localizations, DateTimeOrBoth eDateTime) {
    if (eDateTime == DateTimeOrBoth.DATE) {
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
}
