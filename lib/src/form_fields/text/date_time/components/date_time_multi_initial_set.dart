

class DateTimeRangeInitialSet {
  final DateTimeSeparatedInitialSet? start;
  final DateTimeSeparatedInitialSet? end;

  const DateTimeRangeInitialSet({
    this.start,
    this.end,
  });
}

class DateTimeSeparatedInitialSet {
  final String date;
  final String time;

  const DateTimeSeparatedInitialSet({
    required this.date,
    required this.time,
  });
}
