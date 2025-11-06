import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

enum DateTimeOrBoth {
  DATE,
  TIME,
  DATE_TIME,
}

class DateTimeUtils {
  static DateTimeUtils? _instance;

  DateTimeUtils._();

  factory DateTimeUtils() {
    _instance ??= DateTimeUtils._();
    return _instance!;
  }

  DateTimeValueAndError cleanDateTimeString({
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
      return DateTimeValueAndError.err(text, null, errMsgForbiddenChars(bricksLocalizations, dateTimeOrBoth));

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
      return DateTimeValueAndError.err(text, null, getErMsgTooManyDelimiters(bricksLocalizations, dateTimeOrBoth));

    // too few digits or too many digits
    var nDigits = RegExp('[0-9]').allMatches(text).length;
    if (nDigits + nDelimiters < minNumberOfDigits)
      return DateTimeValueAndError.err(text, null, errMsgTooFewDigits(bricksLocalizations, dateTimeOrBoth));
    if (nDigits > maxNDigits && nDelimiters == 0)
      return DateTimeValueAndError.err(text, null, errMsgTooManyDigits(bricksLocalizations, dateTimeOrBoth));

    return DateTimeValueAndError.ok(result, null);
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
}
