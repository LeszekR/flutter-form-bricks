class DateTimeLimits {
  final DateTime? minDateTimeRequired;
  final DateTime? maxDateTimeRequired;

  DateTimeLimits({
    this.minDateTimeRequired,
    this.maxDateTimeRequired,
  }) : assert(
          minDateTimeRequired == null || maxDateTimeRequired == null || minDateTimeRequired.isBefore(maxDateTimeRequired),
          'Minimal date must be before maximal date or one of them must be null',
        );

  DateTimeLimitsNow calculateDateLimits(DateTime dateNow) {
    if (minDateTimeRequired != null && maxDateTimeRequired != null) {
      return _DateTimeLimitsNow(minDate: minDateTimeRequired!, maxDate: maxDateTimeRequired!);
    }

    const defaultExtension = Duration(days: 365);
    final defaultMinDate = dateNow.subtract(defaultExtension);
    final defaultMaxDate = dateNow.add(defaultExtension);

    if (maxDateTimeRequired != null) {
      return _DateTimeLimitsNow(minDate: defaultMinDate, maxDate: maxDateTimeRequired!);
    }
    if (minDateTimeRequired != null) {
      return _DateTimeLimitsNow(minDate: minDateTimeRequired!, maxDate: defaultMaxDate);
    }
    return _DateTimeLimitsNow(minDate: defaultMinDate, maxDate: defaultMaxDate);
  }
}

class _DateTimeLimitsNow implements DateTimeLimitsNow {
  @override
  final DateTime minDate;
  @override
  final DateTime maxDate;

  const _DateTimeLimitsNow({required this.minDate, required this.maxDate});
}

abstract class DateTimeLimitsNow {
  DateTime get minDate;
  DateTime get maxDate;
}
