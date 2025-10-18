import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';

import 'current_date.dart';
import 'date_time_utils.dart';

class DateFormatterValidator {
  static DateFormatterValidator? _instance;

  DateFormatterValidator._(DateTimeUtils dateTimeInputUtils, CurrentDate currentDate) {
    _dateTimeUtils = dateTimeInputUtils;
    _currentDate = currentDate;
  }

  factory DateFormatterValidator(DateTimeUtils dateTimeUtils, CurrentDate currentDate) {
    _instance ??= DateFormatterValidator._(dateTimeUtils, currentDate);
    return _instance!;
  }

  DateTimeUtils? _dateTimeUtils;
  CurrentDate? _currentDate;

  static const dateDelimiterPattern = '( |/|-|,|;|\\.)';
  static const dateDelimiter = '-';

  StringParseResult makeDateFromString(
    BuildContext context,
    String text,
    int maxYearsBackInDate,
    int maxYearsForwardInDate,
  ) {
    final txt = BricksLocalizations.of(context);
    StringParseResult parseResult;

    parseResult = _dateTimeUtils!.cleanDateTimeString(
      bricksLocalizations: txt,
      text: text,
      dateTimeOrBoth: DateTimeOrBoth.DATE,
      stringDelimiterPattern: dateDelimiterPattern,
      stringDelimiter: dateDelimiter,
      minNumberOfDigits: 3,
      maxNDigits: 8,
      maxNumberDelimiters: 2,
    );
    if (!parseResult.isStringValid) return StringParseResult(text, false, parseResult.errorMessage);

    parseResult = parseDateFromString(txt, parseResult);
    if (!parseResult.isStringValid) return StringParseResult(text, false, parseResult.errorMessage);

    parseResult = validateDate(txt, parseResult, maxYearsBackInDate, maxYearsForwardInDate);
    if (!parseResult.isStringValid) return parseResult;

    // debugPrint("Formatter: raw text: $text");

    return parseResult;
  }

  StringParseResult parseDateFromString(BricksLocalizations txt, StringParseResult stringParseResult) {
    var text = stringParseResult.parsedString;
    var nDelimiters = RegExp(dateDelimiter).allMatches(text).length;

    StringParseResult parseResult;

    if (nDelimiters == 0) {
      parseResult = makeDateStringNoDelimiters(text);
    } else {
      parseResult = makeDateStringWithDelimiters(txt, text, nDelimiters);
    }

    if (!parseResult.isStringValid) return parseResult;

    return addYear(parseResult, nDelimiters);
  }

  StringParseResult makeDateStringNoDelimiters(String text) {
    String dateString = '';
    String element = '';
    var nElements = 0;

    for (int i = text.length - 2; i >= -1 && nElements < 3; i -= 2) {
      nElements++;

      if (i == -1) {
        element = text.substring(0, 1);
        element = '0$element';
      } else {
        element = text.substring(i, i + 2);
      }

      if (nElements < 3) {
        element = dateDelimiter + element;
      } else {
        element = text.substring(0, text.length - 4);
      }
      dateString = element + dateString;
    }
    return StringParseResult(dateString, true, '');
  }

  StringParseResult makeDateStringWithDelimiters(BricksLocalizations txt, String text, int nDelimiters) {
    var dateString = '';
    var element = '';
    var resultList = text.split(dateDelimiter);
    var dayIndex = nDelimiters;
    var monthIndex = nDelimiters - 1;
    var connector = '\n';
    var errMsg = '';
    int elementLength;

    // day and month
    for (int i = nDelimiters; i >= 0; i--) {
      element = resultList[i];
      elementLength = element.length;

      // day
      if (i == dayIndex) {
        if (elementLength > 2) {
          errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, txt.dateStringErrorTooManyDigitsDay);
        }
        if (elementLength == 1) element = '0$element';
      }

      // month
      else if (i == monthIndex) {
        if (elementLength > 2) {
          errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, txt.dateStringErrorTooManyDigitsMonth);
        }
        if (elementLength == 1) element = '0$element';
      }

      // year
      if (i == 0 && nDelimiters == 2) {
        if (elementLength > 4) {
          errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, txt.dateStringErrorTooManyDigitsYear);
        }
        dateString = element + dateString;
      } else {
        dateString = dateDelimiter + element + dateString;
      }
    }

    if (errMsg.isNotEmpty) return StringParseResult(dateString, false, errMsg);
    return StringParseResult(dateString, true, '');
  }

  StringParseResult addYear(StringParseResult dateString, int nDelimiters) {
    String dateWithoutYear = dateString.parsedString;
    nDelimiters = RegExp(dateDelimiter).allMatches(dateWithoutYear).length;

    if (nDelimiters < 2) return StringParseResult(dateWithoutYear, false, '');

    var year = _currentDate!.getDateNow().year.toString();
    var yearElement = dateWithoutYear.split(dateDelimiter)[0];
    var yearElementLength = yearElement.length;

    if (yearElementLength == 0) {
      dateWithoutYear = '$year$dateWithoutYear';
    } else {
      yearElement = year.substring(0, 4 - yearElementLength);
      dateWithoutYear = '$yearElement$dateWithoutYear';
    }
    return StringParseResult(dateWithoutYear, true, '');
  }

  StringParseResult validateDate(
    BricksLocalizations txt,
    StringParseResult stringParseResult,
    int maxYearsBackInDate,
    int maxYearsForwardInDate,
  ) {
    var dateString = stringParseResult.parsedString;
    var dateElementsList = dateString.split(dateDelimiter);
    var elementsListLength = dateElementsList.length;
    var connector = '\n';
    var errMsg = '';
    var errYear = '', errMonth = '', errDays = '';

    // non-existing month
    var monthIndex = elementsListLength - 2;
    var month = int.parse(dateElementsList[monthIndex]);
    if (month < 1) errMonth = txt.dateErrorMonth0;
    if (month > 12) errMonth = txt.dateErrorMonthOver12;

    // non-existing day
    var dayIndex = elementsListLength - 1;
    var day = int.parse(dateElementsList[dayIndex]);
    if (day < 1) errDays = txt.dateErrorDay0;

    bool isTooManyDays = false;
    if (day > 31) {
      errDays = txt.dateErrorTooManyDaysInMonth;
    } else if (month > 0) {
      isTooManyDays |= [4, 6, 9, 11].contains(month) && day > 30;
      isTooManyDays |= [1, 3, 5, 7, 8, 10, 12].contains(month) && day > 31;
      if (isTooManyDays) errDays = txt.dateErrorTooManyDaysInMonth;
    }

    // only max years back and max years forward
    if (elementsListLength == 3) {
      var currentYear = _currentDate!.getDateNow().year;
      var acceptedYearBack = currentYear - maxYearsBackInDate;
      var acceptedYearForward = currentYear + maxYearsForwardInDate;
      var year = int.parse(dateElementsList[0]);

      isTooManyDays = false;
      isTooManyDays |= month == 2 && year % 4 != 0 && day > 28;
      isTooManyDays |= month == 2 && year % 4 == 0 && day > 29;
      if (isTooManyDays) errDays = txt.dateErrorTooManyDaysInMonth;
      if (year < acceptedYearBack) errYear = txt.dateErrorYearTooFarBack(acceptedYearBack);
      if (year > acceptedYearForward) errYear = txt.dateErrorYearTooFarForward(acceptedYearForward);
    }

    if (errYear.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errYear);
    if (errMonth.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errMonth);
    if (errDays.isNotEmpty) errMsg = _dateTimeUtils!.addErrMsg(errMsg, connector, errDays);

    if (errMsg.isNotEmpty) return StringParseResult(dateString, false, errMsg);

    return StringParseResult(dateString, true, '');
  }

  // TODO refactor to exact minimum and maximum DATE not only years
  String makeDateString(
    BuildContext context,
    String text,
    int maxYearsBackInDate,
    int maxYearsForwardInDate,
  ) {
    return makeDateFromString(
      context,
      text,
      maxYearsBackInDate,
      maxYearsForwardInDate,
    ).parsedString;
  }
}
