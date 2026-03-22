import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_range_required_fields.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/extension_date_time.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/dateTime_multifield_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_utils.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:flutter_form_bricks/src/utils/utils.dart';

class DateTimeRangeFormatterValidator extends DateTimeMultiFieldFormatterValidator {
  final DateTimeRangeRequiredFields requiredFields;
  final DateTimeRangeLimits? rangeLimits;

  late final String _dateStartKeyString;
  late final String _timeStartKeyString;
  late final String _dateEndKeyString;
  late final String _timeEndKeyString;

  String? _dateStart;
  String? _timeStart;
  String? _dateEnd;
  String? _timeEnd;

  DateTimeRangeFormatterValidator(
    super.keyString,
    super.dateTimeUtils,
    super.currentDate,
    this.requiredFields, [
    this.rangeLimits,
  ]);

  @override
  void validateFieldsGroup(BricksLocalizations localizations) {
    _getFieldValues();
    String errorText;

    // start-date absent
    // -----------------------------------------------------------------
    if (empty(_dateStart)) {
      errorText = localizations.rangeDateStartRequired;
      cacheError(_dateStartKeyString, errorText);
      return;
    }

    // start-time absent & end-date absent & end-time present
    // -----------------------------------------------------------------
    if (empty(_timeStart) && empty(_dateEnd) && notEmpty(_timeEnd)) {
      errorText = localizations.rangeDateEndRequiredOrRemoveTimeEnd;
      cacheError(_timeStartKeyString, errorText);
      cacheError(_dateEndKeyString, errorText);
      cacheError(_timeEndKeyString, errorText);
      return;
    }

    if (notEmpty(_dateStart) && notEmpty(_dateEnd)) {
      DateTime dateStart = _makeDateTimeOptional(_dateStart!, _timeStart);
      DateTime dateEnd = _makeDateTimeOptional(_dateEnd!, _timeEnd);
      int dateDiffMinutes = dateEnd.difference(dateStart).inMinutes;

      // start-date present & end-date present & start-date after end-date
      // -----------------------------------------------------------------
      if (dateDiffMinutes < 0) {
        errorText = localizations.rangeDateStartAfterEnd;
        cacheError(_dateStartKeyString, errorText);
        cacheError(_dateEndKeyString, errorText);
        return;
      }

      // start-date present & end-date present & end-date too far from start-date
      // -----------------------------------------------------------------
      int? maxSpanMinutes = rangeLimits?.maxSpanMinutes;
      if (maxSpanMinutes != null) {
        if (dateDiffMinutes > maxSpanMinutes) {
          String maxSpanCondition = dateTimeUtils.minutesToSpanCondition(maxSpanMinutes);
          errorText = localizations.rangeDatesTooFarApart(maxSpanCondition);
          cacheError(_dateStartKeyString, errorText);
          cacheError(_dateEndKeyString, errorText);
          return;
        }
      }
    }

    if (notEmpty(_timeStart) && notEmpty(_timeEnd)) {
      // identical start and end
      if (_dateStart == _dateEnd && _timeStart == _timeEnd) {
        errorText = localizations.rangeStartSameAsEnd;
        cacheError(_dateStartKeyString, errorText);
        cacheError(_timeStartKeyString, errorText);
        cacheError(_dateEndKeyString, errorText);
        cacheError(_timeEndKeyString, errorText);
        return;
      }

      String dummyDate = '2000-01-01';
      DateTime timeStart = _makeDateTime(dummyDate, _timeStart!);
      DateTime timeEnd = _makeDateTime(dummyDate, _timeEnd!);
      int timeDiffMinutes = timeEnd.difference(timeStart).inMinutes;

      // end-date absent
      if (notEmpty(_dateStart) && empty(_dateEnd)) {
        // start-time after end-time
        // -----------------------------------------------------------------
        if (timeDiffMinutes < 0) {
          errorText = localizations.rangeTimeStartAfterEndOrAddDateEnd;
          cacheError(_timeStartKeyString, errorText);
          cacheError(_dateEndKeyString, errorText);
          cacheError(_timeEndKeyString, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        int? minSpanMinutes = rangeLimits?.minSpanMinutes;
        if (minSpanMinutes != null) {
          if (timeDiffMinutes < minSpanMinutes) {
            String minSpanCondition = dateTimeUtils.minutesToSpanCondition(minSpanMinutes);
            errorText = localizations.rangeTimeStartEndTooCloseOrAddDateEnd(minSpanCondition);
            cacheError(_timeStartKeyString, errorText);
            cacheError(_dateEndKeyString, errorText);
            cacheError(_timeEndKeyString, errorText);
            return;
          }
        }
      }

      // start-date = end-date
      if (notEmpty(_dateEnd) && notEmpty(_dateStart)) {
        DateTime dateTimeStart = _makeDateTime(_dateStart!, _timeStart!);
        DateTime dateTimeEnd = _makeDateTime(_dateEnd!, _timeEnd!);
        int dateTimeDiffMinutes = dateTimeEnd.difference(dateTimeStart).inMinutes;

        // start-time after end-time
        // -----------------------------------------------------------------
        if (dateTimeDiffMinutes < 0) {
          errorText = localizations.rangeTimeStartAfterEnd;
          cacheError(_timeStartKeyString, errorText);
          cacheError(_timeEndKeyString, errorText);
          return;
        }
        // start-time less than minimum before end-time
        // -----------------------------------------------------------------
        int? minSpanMinutes = rangeLimits?.minSpanMinutes;
        if (minSpanMinutes != null) {
          if (dateTimeDiffMinutes < minSpanMinutes) {
            String minSpan = dateTimeUtils.minutesToSpanCondition(minSpanMinutes);
            errorText = localizations.rangeTimeStartEndTooCloseSameDate(minSpan);
            cacheError(_timeStartKeyString, errorText);
            cacheError(_timeEndKeyString, errorText);
            return;
          }
        }
      }
    }

    // TU PRZERWAŁEM - TODO TEST dateTimeLimits validation
    // RANGE LIMITS
    // =======================================================================
    if (rangeLimits != null) {
      //
      if (rangeLimits!.startDateTimeLimits != null) {
        //
        if (notEmpty(_dateStart)) {
          DateTime startDateTime = _makeDateTimeOptional(_dateStart!, _timeStart);

          DateTime minDateTime = rangeLimits!.startDateTimeLimits!.minDateTime!;
          DateTime minDate = rangeLimits!.startDateTimeLimits!.minDateWithoutTime!;

          // start-date-time too early
          // -----------------------------------------------------------------
          if (notEmpty(_timeStart)) {
            if (startDateTime.isBefore(minDateTime)) {
              errorText = localizations.dateTimeErrorTooFarBack(minDateTime.toDateTimeString());
              cacheError(_dateStartKeyString, errorText);
              cacheError(_timeStartKeyString, errorText);
            }
          }
          // start-date too early
          // -----------------------------------------------------------------
          else {
            if (startDateTime.isBefore(minDate)) {
              errorText = localizations.dateErrorTooFarBack(minDate.toDateString());
              cacheError(_dateStartKeyString, errorText);
            }
          }

          DateTime maxDateTime = rangeLimits!.startDateTimeLimits!.maxDateTime!;
          DateTime maxDate = rangeLimits!.startDateTimeLimits!.maxDateWithoutTime!;

          // start-date-time too late
          // -----------------------------------------------------------------
          if (notEmpty(_timeStart)) {
            if (startDateTime.isAfter(maxDateTime)) {
              errorText = localizations.dateTimeErrorTooFarForward(maxDateTime.toDateTimeString());
              cacheError(_dateStartKeyString, errorText);
              cacheError(_timeStartKeyString, errorText);
            }
          }
          // start-date too late
          // -----------------------------------------------------------------
          else {
            if (startDateTime.isAfter(maxDate)) {
              errorText = localizations.dateErrorTooFarForward(maxDate.toDateString());
              cacheError(_dateStartKeyString, errorText);
            }
          }
        }
      }

      if (rangeLimits!.endDateTimeLimits != null) {
        //
        if (notEmpty(_dateEnd)) {
          DateTime endDateTime = _makeDateTimeOptional(_dateEnd!, _timeEnd);

          DateTime minDateTime = rangeLimits!.endDateTimeLimits!.minDateTime!;
          DateTime minDate = rangeLimits!.endDateTimeLimits!.minDateWithoutTime!;

          // end-date-time too early
          // -----------------------------------------------------------------
          if (notEmpty(_timeEnd)) {
            if (endDateTime.isBefore(minDateTime)) {
              errorText = localizations.dateTimeErrorTooFarBack(minDateTime.toDateTimeString());
              cacheError(_dateEndKeyString, errorText);
              cacheError(_timeEndKeyString, errorText);
            }
          }
          // end-date too early
          // -----------------------------------------------------------------
          else {
            if (endDateTime.isBefore(minDate)) {
              errorText = localizations.dateErrorTooFarBack(minDate.toDateString());
              cacheError(_dateEndKeyString, errorText);
            }
          }

          DateTime maxDateTime = rangeLimits!.endDateTimeLimits!.maxDateTime!;
          DateTime maxDate = rangeLimits!.endDateTimeLimits!.maxDateWithoutTime!;

          // end-date-time too late
          // -----------------------------------------------------------------
          if (notEmpty(_timeEnd)) {
            if (endDateTime.isAfter(maxDateTime)) {
              errorText = localizations.dateTimeErrorTooFarForward(maxDateTime.toDateTimeString());
              cacheError(_dateEndKeyString, errorText);
              cacheError(_timeEndKeyString, errorText);
            }
          }
          // end-date too late
          // -----------------------------------------------------------------
          else {
            if (endDateTime.isAfter(maxDate)) {
              errorText = localizations.dateErrorTooFarForward(maxDate.toDateString());
              cacheError(_dateEndKeyString, errorText);
            }
          }
        }
      }
    }
    return;
  }

  DateTime _makeDateTimeOptional(String dateStartText, String? timeStartText) {
    final String time = (timeStartText == null || timeStartText.isEmpty) ? '00:00' : '$timeStartText';
    return DateTime.parse('$dateStartText $time');
  }

  DateTime _makeDateTime(String dateText, final String timeText) {
    var dateStart = DateTime.parse(dateText);
    var timeArr = timeText.split(':');
    var hour = int.parse(timeArr[0]);
    var minute = int.parse(timeArr[1]);
    return dateStart.add(Duration(hours: hour, minutes: minute));
  }

  void _getFieldValues() {
    _dateStart = _getRangeFieldValue(_dateStartKeyString);
    _timeStart = _getRangeFieldValue(_timeStartKeyString);
    _dateEnd = _getRangeFieldValue(_dateEndKeyString);
    _timeEnd = _getRangeFieldValue(_timeEndKeyString);
  }

  String? _getRangeFieldValue(String keyString) {
    return formManager.getFieldValue(keyString);
  }

  void setKeyStrings(String keyString) {
    _dateStartKeyString = DateTimeUtils.rangeDateStartKeyString(keyString);
    _timeStartKeyString = DateTimeUtils.rangeTimeStartKeyString(keyString);
    _dateEndKeyString = DateTimeUtils.rangeDateEndKeyString(keyString);
    _timeEndKeyString = DateTimeUtils.rangeTimeEndKeyString(keyString);

    keyStrings = [
      _dateStartKeyString,
      _timeStartKeyString,
      _dateEndKeyString,
      _timeEndKeyString,
    ];
  }

  void fillDateTimeFormatterValidators() {
    formatterValidators[_dateStartKeyString] = DateFormatterValidator(
      dateTimeUtils,
      currentDate,
      rangeLimits?.startDateTimeLimits,
    );
    formatterValidators[_timeStartKeyString] = TimeFormatterValidator(
      dateTimeUtils,
      // TU PRZERWAŁEM - TODO remove time limit validation here - move it to multiFieldValidation after concatenation of date and time
      // rangeLimits?.startDateTimeLimits,
    );
    formatterValidators[_dateEndKeyString] = DateFormatterValidator(
      dateTimeUtils,
      currentDate,
      rangeLimits?.endDateTimeLimits,
    );
    formatterValidators[_timeEndKeyString] = TimeFormatterValidator(
      dateTimeUtils,
      // TU PRZERWAŁEM - TODO remove time limit validation here - move it to multiFieldValidation after concatenation of date and time
      // rangeLimits?.endDateTimeLimits,
    );
  }
}
