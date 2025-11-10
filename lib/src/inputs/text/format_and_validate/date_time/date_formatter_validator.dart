import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

class DateFormatterValidator {
  static const dateDelimiterPattern = '( |/|-|,|;|\\.)';
  static const dateDelimiter = '-';

  static DateFormatterValidator? _instance;

  DateTimeUtils _dateTimeUtils;
  CurrentDate _currentDate;

  DateFormatterValidator._(this._dateTimeUtils, this._currentDate) {}

  factory DateFormatterValidator(DateTimeUtils dateTimeUtils, CurrentDate currentDate) {
    return _instance ??= DateFormatterValidator._(dateTimeUtils, currentDate);
  }

  // TODO refactor to exact minimum and maximum DATE not only years
  String makeDateString(
    BricksLocalizations localizations,
    String inputString,
    DateTimeLimits? dateLimits,
  ) {
    return makeDateFromString(localizations, inputString, dateLimits).input!;
  }

  DateTimeFieldContent makeDateFromString(BricksLocalizations localizations, String text, DateTimeLimits? dateLimits) {
    DateTimeFieldContent parseResult;

    parseResult = _dateTimeUtils.cleanDateTimeString(
      bricksLocalizations: localizations,
      text: text,
      dateTimeOrBoth: DateTimeOrBoth.DATE,
      stringDelimiterPattern: dateDelimiterPattern,
      stringDelimiter: dateDelimiter,
      minNumberOfDigits: 3,
      maxNDigits: 8,
      maxNumberDelimiters: 2,
    );
    if (!parseResult.isValid!) return DateTimeFieldContent.err(text, parseResult.error);

    parseResult = parseDateFromString(localizations, parseResult);
    if (!parseResult.isValid!) return DateTimeFieldContent.err(text, parseResult.error);

    parseResult = validateDate(localizations, parseResult, dateLimits);

    return parseResult;
  }

  DateTimeFieldContent parseDateFromString(
      BricksLocalizations localizations, DateTimeFieldContent dateTimeFieldContent) {
    String text = dateTimeFieldContent.input!;
    int nDelimiters = RegExp(dateDelimiter).allMatches(text).length;

    DateTimeFieldContent parseResult;

    if (nDelimiters == 0) {
      parseResult = makeDateStringNoDelimiters(text);
    } else {
      parseResult = makeDateStringWithDelimiters(localizations, text, nDelimiters);
    }

    if (!parseResult.isValid!) return parseResult;

    return addYear(parseResult, nDelimiters);
  }

  DateTimeFieldContent makeDateStringNoDelimiters(String text) {
    String dateString = '';
    String element = '';
    int nElements = 0;

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
    return DateTimeFieldContent.transient(dateString);
  }

  DateTimeFieldContent makeDateStringWithDelimiters(BricksLocalizations localizations, String text, int nDelimiters) {
    String dateString = '';
    String element = '';
    List<String> resultList = text.split(dateDelimiter);
    int dayIndex = nDelimiters;
    int monthIndex = nDelimiters - 1;
    String connector = '\n';
    String errMsg = '';
    int elementLength;

    // day and month
    for (int i = nDelimiters; i >= 0; i--) {
      element = resultList[i];
      elementLength = element.length;

      // day
      if (i == dayIndex) {
        if (elementLength > 2) {
          errMsg = _dateTimeUtils.addErrMsg(errMsg, connector, localizations.dateStringErrorTooManyDigitsDay);
        }
        if (elementLength == 1) element = '0$element';
      }

      // month
      else if (i == monthIndex) {
        if (elementLength > 2) {
          errMsg = _dateTimeUtils.addErrMsg(errMsg, connector, localizations.dateStringErrorTooManyDigitsMonth);
        }
        if (elementLength == 1) element = '0$element';
      }

      // year
      if (i == 0 && nDelimiters == 2) {
        if (elementLength > 4) {
          errMsg = _dateTimeUtils.addErrMsg(errMsg, connector, localizations.dateStringErrorTooManyDigitsYear);
        }
        dateString = element + dateString;
      } else {
        dateString = dateDelimiter + element + dateString;
      }
    }

    if (errMsg.isNotEmpty) return DateTimeFieldContent.err(dateString, errMsg);
    return DateTimeFieldContent.transient(dateString);
  }

  DateTimeFieldContent addYear(DateTimeFieldContent dateString, int nDelimiters) {
    String dateWithoutYear = dateString.input!;
    nDelimiters = RegExp(dateDelimiter).allMatches(dateWithoutYear).length;

    if (nDelimiters < 2) return DateTimeFieldContent.transient(dateWithoutYear);

    String year = _currentDate.getDateNow().year.toString();
    String yearElement = dateWithoutYear.split(dateDelimiter)[0];
    int yearElementLength = yearElement.length;

    if (yearElementLength == 0) {
      dateWithoutYear = '$year$dateWithoutYear';
    } else {
      yearElement = year.substring(0, 4 - yearElementLength);
      dateWithoutYear = '$yearElement$dateWithoutYear';
    }
    return DateTimeFieldContent.transient(dateWithoutYear);
  }

  DateTimeFieldContent validateDate(
    BricksLocalizations localizations,
    DateTimeFieldContent fieldContent,
    DateTimeLimits? dateLimits,
  ) {
    String dateString = fieldContent.input!;
    List<String> dateElementsList = dateString.split(dateDelimiter);
    int elementsListLength = dateElementsList.length;
    String connector = '\n';
    String errMsg = '';
    String errLimit = '', errMonth = '', errDays = '';
    DateTime? parsedDate;

    // non-existing month
    int monthIndex = elementsListLength - 2;
    int month = int.parse(dateElementsList[monthIndex]);
    if (month < 1) errMonth = localizations.dateErrorMonth0;
    if (month > 12) errMonth = localizations.dateErrorMonthOver12;

    // non-existing day
    int dayIndex = elementsListLength - 1;
    int day = int.parse(dateElementsList[dayIndex]);
    if (day < 1) errDays = localizations.dateErrorDay0;

    bool isTooManyDays = false;
    if (day > 31) {
      errDays = localizations.dateErrorTooManyDaysInMonth;
    } else if (month > 0) {
      isTooManyDays |= [4, 6, 9, 11].contains(month) && day > 30;
      isTooManyDays |= [1, 3, 5, 7, 8, 10, 12].contains(month) && day > 31;
      if (isTooManyDays) errDays = localizations.dateErrorTooManyDaysInMonth;
    }

    // February's max days
    int inputYear = int.parse(dateElementsList[0]);
    isTooManyDays = false;
    isTooManyDays |= month == 2 && (inputYear % 4 != 0) && day > 28;
    isTooManyDays |= month == 2 && (inputYear % 4 == 0) && day > 29;
    if (isTooManyDays) errDays = localizations.dateErrorTooManyDaysInMonth;

    if (errMonth.isNotEmpty) errMsg = _dateTimeUtils.addErrMsg(errMsg, connector, errMonth);
    if (errDays.isNotEmpty) errMsg = _dateTimeUtils.addErrMsg(errMsg, connector, errDays);

    // date-time limits
    if (errDays.isEmpty && errMonth.isEmpty) {
      parsedDate = DateTime.parse(dateString);

      if (dateLimits != null) {
        DateTime? minDate = dateLimits.minDateTime;
        if (minDate != null) {
          if (parsedDate.compareTo(minDate) < 0) {
            errLimit = localizations.dateErrorTooFarBack(_dateTimeUtils.formatDate(minDate, "yMd"));
          }
        }
        DateTime? maxDate = dateLimits.maxDateTime;
        if (maxDate != null) {
          if (parsedDate.compareTo(maxDate) > 0) {
            errLimit = localizations.dateErrorTooFarForward(_dateTimeUtils.formatDate(maxDate, "yMd"));
          }
        }
      }
    }

    if (errLimit.isNotEmpty) errMsg = _dateTimeUtils.addErrMsg(errMsg, connector, errLimit);

    if (errMsg.isNotEmpty) return DateTimeFieldContent.err(dateString, errMsg);

    return DateTimeFieldContent.ok(dateString, parsedDate);
  }
}
