import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_time_utils.dart';

extension DateTimeExtension on DateTime {
  String toDateString() {
    return DateTimeUtils.dateFormat.format(this);
  }

  String toDateTimeString() {
    return DateTimeUtils.dateTimeFormat.format(this);
  }

  String toTimeStringMinutePrecision() {
    return DateTimeUtils.timeFormatMinutePrecision.format(this);
  }

  String toTimeStringSecondPrecision() {
    return DateTimeUtils.timeFormatSecondPrecision.format(this);
  }
}
