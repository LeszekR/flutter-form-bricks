class DateTimeRangeSpan {
  final int? minDateTimeSpanMinutes;
  final int? maxDateTimeSpanMinutes;

  DateTimeRangeSpan({
    this.minDateTimeSpanMinutes,
    this.maxDateTimeSpanMinutes,
  })  : assert(minDateTimeSpanMinutes == null || minDateTimeSpanMinutes > 0,
            'Minimal date-time-span must be either null or positive'),
        assert(maxDateTimeSpanMinutes == null || maxDateTimeSpanMinutes > 0,
            'Maximal date-time-span must be either null or positive'),
        assert(
          ((minDateTimeSpanMinutes == null) != (maxDateTimeSpanMinutes == null)) ||
              (minDateTimeSpanMinutes != null &&
                  maxDateTimeSpanMinutes != null &&
                  minDateTimeSpanMinutes > 0 &&
                  maxDateTimeSpanMinutes > 0 &&
                  minDateTimeSpanMinutes <= maxDateTimeSpanMinutes),
          'Minimal date-time-span must be less than maximal date-time-span or one of them must be null',
        );
}
