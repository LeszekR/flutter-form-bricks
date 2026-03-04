class DateTimeRangeInitialSet {
  final DateTimeInitialSet? start;
  final DateTimeInitialSet? end;

  const DateTimeRangeInitialSet({
    this.start,
    this.end,
  });
}

class DateTimeInitialSet {
  final DateTime? date;
  final DateTime? time;

  const DateTimeInitialSet({
    this.date,
    this.time,
  });
}
