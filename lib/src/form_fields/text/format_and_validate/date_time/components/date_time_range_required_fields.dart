class DateTimeRangeRequiredFields {
  final DateTimeRequiredFields? start;
  final DateTimeRequiredFields? end;

  const DateTimeRangeRequiredFields({
    this.start,
    this.end,
  });
}

class DateTimeRequiredFields {
  final bool? _date;
  final bool? _time;

  const DateTimeRequiredFields(this._date, this._time);

  bool get date => _date ?? false;
  bool get time => _time ?? false;
}
