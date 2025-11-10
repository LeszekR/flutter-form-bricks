class DateTimeRangeSpan {
  final int? minDateTimeSpanMinutes;
  final int? maxDateTimeSpanMinutes;

  DateTimeRangeSpan({
    this.minDateTimeSpanMinutes,
    this.maxDateTimeSpanMinutes,
  }) : assert(
          minDateTimeSpanMinutes == null ||
              maxDateTimeSpanMinutes == null ||
              minDateTimeSpanMinutes <= maxDateTimeSpanMinutes,
          'Minimal date-time-span must be before maximal date-time-span or one of them must be null',
        );
}
