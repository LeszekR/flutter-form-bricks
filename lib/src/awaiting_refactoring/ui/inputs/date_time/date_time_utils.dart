
import 'package:flutter_form_bricks/awaiting_refactoring/ui/inputs/date_time/string_parse_result.dart';

enum EDateTime {
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

  StringParseResult cleanDateTimeString({
    required final String text,
    required final EDateTime eDateTime,
    required final String stringDelimiterPattern,
    required final String stringDelimiter,
    required final int minNumberOfDigits,
    required final int maxNDigits,
    required final int maxNumberDelimiters,
  }) {
    // text must contain allowed chars only
    RegExp allowedRegex = RegExp('([0-9]|$stringDelimiterPattern)');
    var allowedCharsLength = allowedRegex.allMatches(text).length;
    if (allowedCharsLength < text.length) return StringParseResult(text, false, errMsgForbiddenChars(eDateTime));

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
    if (nDelimiters > maxNumberDelimiters) return StringParseResult(text, false, getErMsgTooManyDelimiters(eDateTime));

    // too few digits or too many digits
    var nDigits = RegExp('[0-9]').allMatches(text).length;
    if (nDigits + nDelimiters < minNumberOfDigits) return StringParseResult(text, false, errMsgTooFewDigits(eDateTime));
    if (nDigits > maxNDigits && nDelimiters == 0) return StringParseResult(text, false, errMsgTooManyDigits(eDateTime));

    return StringParseResult(result, true, '');
  }

  String removeBadChars(final String text, final String stringDelimiterPattern) {
    var textClean = '', nextChar = '';
    var regExp = RegExp('[0-9]|$stringDelimiterPattern');
    for (int i = 0; i < text.length; i++) {
      nextChar = text.substring(i, i + 1);
      if (regExp.hasMatch(nextChar)) textClean = textClean + nextChar;
    }
    return textClean;
  }

  String errMsgForbiddenChars(EDateTime eDateTime) {
    if (eDateTime == EDateTime.DATE) {
      return Tr.get.dateStringErrorBadChars;
    }
    return Tr.get.timeStringErrorBadChars;
  }

  String errMsgTooFewDigits(EDateTime eDateTime) {
    if (eDateTime == EDateTime.DATE) {
      return Tr.get.dateStringErrorTooFewDigits;
    }
    return Tr.get.timeStringErrorTooFewDigits;
  }

  String errMsgTooManyDigits(EDateTime eDateTime) {
    if (eDateTime == EDateTime.DATE) {
      return Tr.get.dateStringErrorTooManyDigits;
    }
    return Tr.get.timeStringErrorTooManyDigits;
  }

  String getErMsgTooManyDelimiters(EDateTime eDateTime) {
    if (eDateTime == EDateTime.DATE) {
      return Tr.get.dateStringErrorTooManyDelimiters;
    }
    return Tr.get.timeStringErrorTooManyDelimiters;
  }

  String addErrMsg(final String errMsg, final String connector, final String nextErrorMessage) {
    return (errMsg.isEmpty ? '' : (errMsg + connector)) + nextErrorMessage;
  }

// // TODO obsolete - remove everything from here =================================================================
//
// static final dateTimeSplitter = RegExp(r'[:\\ /-]');
//
// static TextEditingValue formatDateHourInput(TextEditingValue oldValue, TextEditingValue inputValue) {
//   final text = inputValue.text;
//   bool isDateFormatted = false;
//
//   final parts = text.split(' ');
//
//   String? formattedText;
//   String? formattedHour;
//
//   if (parts.length > 1 && parts[1].length >= 3) {
//     String formattedDate;
//     if (!isDateFormatted) {
//       try {
//         formattedDate = formatDate(parts[0]);
//         isDateFormatted = true;
//       } catch (e) {
//         formattedDate = parts[0];
//       }
//     }
//
//     if (parts[1].length >= 3) {
//       try {
//         formattedHour = parseTimeQuickInput(parts[1]);
//         formattedText = "$formattedDate $formattedHour";
//       } catch (e) {
//         formattedHour = parts[1];
//       }
//     }
//     formattedText = formattedHour != null ? "$formattedDate $formattedHour" : "$formattedDate ";
//   }
//
//   final selectionIndex = formattedText!.length;
//   return TextEditingValue(
//     text: formattedText,
//     selection: TextSelection.collapsed(offset: selectionIndex),
//   );
// }
//
//
// static String formatDate(String input) {
//   DateTime? parsedDate;
//   List<String> dateFormats = [
//     // Month/Day/Year Formats
//     "M/d",
//     "MM/dd",
//     "MM/dd/yyyy",
//     "MM/dd/yy",
//     "M/d/yyyy",
//     "M/d/yy",
//     "MMM d, yyyy",
//     "MMMM d, yyyy",
//
//     // Day/Month/Year Formats
//     "dd/MM/yyyy",
//     "dd/MM/yy",
//     "d/M/yyyy",
//     "d/M/yy",
//     "d MMM yyyy",
//     "d MMMM yyyy",
//
//     // Year/Month/Day Formats
//     "yyyy-MM-dd",
//     "yy-MM-dd",
//     "yyyy/MM/dd",
//     "yy/MM/dd",
//     "yyyyMMdd",
//
//     // Month-Day-Year Formats
//     "MMMM d, yyyy",
//     "MMM d, yyyy",
//     "MMMM dd, yyyy",
//     "MMM dd, yyyy",
//
//     // Day-Month-Year Formats
//     "dd-MMM-yy",
//     "dd-MMM-yyyy",
//     "d-MMM-yy",
//     "d-MMM-yyyy",
//
//     // Special Date Formats
//     "dd-MM-yyyy",
//     "MM-dd-yyyy",
//     "dd.MM.yyyy",
//     "MM.dd.yyyy"
//   ];
//
//   for (String format in dateFormats) {
//     try {
//       parsedDate = DateFormat(format).parseStrict(input);
//       if (format.contains("yyyy")) {
//         break;
//       } else {
//         parsedDate = DateTime(DateTime.now().year, parsedDate.month, parsedDate.day);
//         break;
//       }
//     } catch (e) {
//       continue;
//     }
//   }
//
//   return DateFormat('yyyy-MM-dd').format(parsedDate!);
// }
//
// static String parseDateQuickInput(final String originalValue) {
//   final List<String> elements = _readElementsFromRawInput(originalValue);
//   if (elements.length < 2 || elements.length > 3) {
//     return originalValue;
//   }
//
//   final String? year = DateTimeUtils.getYearFromInput(elements);
//   if (year == null) {
//     return originalValue;
//   }
//
//   final String? month = DateTimeUtils.parseDatetimeValue(elements[elements.length - 2], 1, 12);
//   if (month == null) {
//     return originalValue;
//   }
//
//   final String? day = DateTimeUtils.parseDatetimeValue(elements[elements.length - 1], 1, 31);
//   if (day == null) {
//     return originalValue;
//   }
//
//   return "$year-$month-$day";
// }
//
// static String? parseTimeQuickInput(final String originalValue) {
//   final List<String> elements = _readElementsFromRawInput(originalValue);
//   if (elements.isEmpty || elements.length > 2) {
//     return originalValue;
//   }
//
//   if (elements.length == 1) {
//     return _parseTimeInputFromUnseparatedStringInputValue(elements[0]);
//   }
//
//   final String? hour = DateTimeUtils.parseDatetimeValue(elements[0], 0, 23);
//   if (hour == null) {
//     return originalValue;
//   }
//
//   final String? minute = DateTimeUtils.parseDatetimeValue(elements[1], 0, 59);
//   if (minute == null) {
//     return originalValue;
//   }
//   return "$hour:$minute";
// }
//
// static String? _parseTimeInputFromUnseparatedStringInputValue(final String rawInput) {
//   switch (rawInput.length) {
//     case 1:
//       return "0$rawInput:00";
//     case 2:
//       return "$rawInput:00";
//     case 3:
//       {
//         final hourPart = rawInput.substring(0, 1);
//         final minutePart = rawInput.substring(1, 3);
//         return "0$hourPart:$minutePart";
//       }
//     case 4:
//       return "${rawInput.substring(0, 2)}:${rawInput.substring(2, 4)}";
//     default:
//       return null;
//   }
// }
//
// static String? getYearFromInput(final List<String> elements) {
//   final bool containsYear = elements.length == 3;
//   if (!containsYear) {
//     return DateTime.now().year.toString();
//   }
//   final yearString = elements[0];
//   switch (yearString.length) {
//     case 2:
//       return "20$yearString";
//     case 4:
//       return yearString;
//     default:
//       return null;
//   }
// }
//
// static String? parseDatetimeValue(final String raw, final int minInclusive, final int maxInclusive) {
//   final intValue = int.tryParse(raw);
//   if (intValue == null || intValue < minInclusive || intValue > maxInclusive) {
//     return null;
//   }
//   return intValue < 10 ? "0$intValue" : intValue.toString();
// }
//
// static List<String> _readElementsFromRawInput(String originalValue) =>
//     originalValue.split(dateTimeSplitter).where((element) => element.isNotEmpty).toList();
}
