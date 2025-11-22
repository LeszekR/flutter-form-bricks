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
  final DateTimeLimits startDateTimeLimits;
  final DateTimeLimits endDateTimeLimits;
  final int maxSpanMinutes;
  const DateTimeRangeLimits(this.startDateTimeLimits, this.endDateTimeLimits, this.maxSpanMinutes);
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
