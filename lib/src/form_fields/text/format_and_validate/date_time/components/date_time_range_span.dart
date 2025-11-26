import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_utils.dart';

class DateTimeRangeSpan {
  final int? minDateTimeSpanMinutes;
  final int? maxDateTimeSpanMinutes;

  DateTimeRangeSpan({
    this.minDateTimeSpanMinutes,
    this.maxDateTimeSpanMinutes,
  }) : assert(
          ((minDateTimeSpanMinutes == null) != (maxDateTimeSpanMinutes == null)) ||
              (minDateTimeSpanMinutes != null &&
                  maxDateTimeSpanMinutes != null &&
                  minDateTimeSpanMinutes > 0 &&
                  maxDateTimeSpanMinutes > 0 &&
                  minDateTimeSpanMinutes <= maxDateTimeSpanMinutes),
          'Minimal date-time-span must less than maximal date-time-span or one of them must be null '
          'and both must be positive',
        );
}
