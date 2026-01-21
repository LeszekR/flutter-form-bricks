import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/timestamp_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/timestamp_time.dart';

class DateTimeRangeInitialSet {
  final DateTimeInitialSet? start;
  final DateTimeInitialSet? end;

  const DateTimeRangeInitialSet({
    this.start,
    this.end,
  });
}

class DateTimeInitialSet {
  final Date? date;
  final Time? time;

  const DateTimeInitialSet({
    this.date,
    this.time,
  });
}
