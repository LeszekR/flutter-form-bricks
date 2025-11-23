/// Configuration object - **time** limits for `TimeFormatterValidator`.
///
/// Accept `int` number of minutes - the limiting hours must be recalculated to minutes before being passed to the
/// constructor.
///
/// In case only lower or only upper limit are required `null` must be passed as the other limit.
///
/// Example:
/// - limit of **15:30 - 22:15** should be passed as `TimeLimits(930, 1335)`
/// - not later than **15:30** should be passed as `TimeLimits(null, 930)`.
class TimeLimits {
  final int? minTimeMinutes;
  final int? maxTimeMinutes;

  TimeLimits({
    this.minTimeMinutes,
    this.maxTimeMinutes,
  }) : assert(
          minTimeMinutes == null || maxTimeMinutes == null || minTimeMinutes < maxTimeMinutes,
          'Minimal Time must be before maximal Time-time or one of them must be null',
        );
}

/// Configuration object - **date** limits for `DateFormatterValidator`.
///
/// Regardless of what `DateTime`s were passed to the constructor the times are stripped to zeroes leaving
/// only the dates as limits for the validator.
class DateLimits {
  late final DateTime? minDate;
  late final DateTime? maxDate;

  DateLimits({
    DateTime? minDate,
    DateTime? maxDate,
  }) : assert(
          minDate == null || maxDate == null || minDate.isBefore(maxDate),
          'Minimal date- must be before maximal date- or one of them must be null',
        ) {
    if (minDate != null) {
      this.minDate = DateTime(minDate.year, minDate.month, minDate.day);
    }
    if (maxDate != null) {
      this.maxDate = DateTime(maxDate.year, maxDate.month, maxDate.day);
    }
  }
}

/// Configuration object - **date-with-time** limits for `DateTimeFormatterValidator` and `DateTimeRangeFormatterValidator`.
///
/// In case only lower or only upper limit are required `null` must be passed as the other limit.
class DateTimeLimits {
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  DateTimeLimits({
    this.minDateTime,
    this.maxDateTime,
  }) : assert(
          minDateTime == null || maxDateTime == null || minDateTime.isBefore(maxDateTime),
          'Minimal date-time must be before maximal date-time or one of them must be null',
        );
}

class DateTimeRangeLimits {
  final DateTimeLimits? startDateTimeLimits;
  final DateTimeLimits? endDateTimeLimits;
  final int? minSpanMinutes;
  final int? maxSpanMinutes;

  const DateTimeRangeLimits(
    this.startDateTimeLimits,
    this.endDateTimeLimits,
    this.minSpanMinutes,
    this.maxSpanMinutes,
  );
}

// DateTimeLimitsNow calculateDateLimits(DateTime dateNow) {
//   if (minDateTime != null && maxDateTime != null) {
//     return _DateTimeLimitsNow(minDate: minDateTime!, maxDate: maxDateTime!);
//   }
//
//   const defaultExtension = Duration(days: 365);
//   final defaultMinDate = dateNow.subtract(defaultExtension);
//   final defaultMaxDate = dateNow.add(defaultExtension);
//
//   if (maxDateTime != null) {
//     return _DateTimeLimitsNow(minDate: defaultMinDate, maxDate: maxDateTime!);
//   }
//   if (minDateTime != null) {
//     return _DateTimeLimitsNow(minDate: minDateTime!, maxDate: defaultMaxDate);
//   }
//   return _DateTimeLimitsNow(minDate: defaultMinDate, maxDate: defaultMaxDate);
// }
// }
//
// class _DateTimeLimitsNow implements DateTimeLimitsNow {
//   @override
//   final DateTime minDate;
//   @override
//   final DateTime maxDate;
//
//   const _DateTimeLimitsNow({required this.minDate, required this.maxDate});
// }
//
// abstract class DateTimeLimitsNow {
//   DateTime get minDate;
//
//   DateTime get maxDate;
// }
