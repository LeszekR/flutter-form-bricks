import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/timestamp_time.dart';
import 'package:intl/intl.dart';

/// When backend is operates date or time only it is advised to use the classes below instead of DateTime
class Date implements Comparable<Date> {
  static final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  static final DateFormat timeFormatMinutePrecision = DateFormat("HH:mm");
  static final DateFormat timeFormatSecondsPrecision = DateFormat("HH:mm:ss");
  static final DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
  static final DateFormat dateHourFormat = DateFormat("yyyy-MM-dd HH:mm");

  final DateTime _dateTime;

  DateTime get dateTime => _dateTime;

  Date(this._dateTime);

  factory Date.fromDateTime(DateTime dateTime) {
    return Date(DateTime(dateTime.year, dateTime.month, dateTime.day));
  }

  static Date fromString(String stringVal) {
    final parsed = dateFormat.parseStrict(stringVal);
    return Date(parsed);
  }

  Date modify(Duration duration) {
    return Date(_dateTime.add(duration));
  }

  Date subtract(Duration duration) {
    return Date(_dateTime.subtract(duration));
  }

  Date add(Duration duration) {
    return Date(_dateTime.add(duration));
  }

  //duplicated method needed by JSON_SERIALIZER
  factory Date.fromJson(String value) => fromString(value);

  String toJson() => dateFormat.format(_dateTime);

  @override
  String toString() => dateFormat.format(_dateTime);

  @override
  int compareTo(Date other) {
    return _dateTime.compareTo(other._dateTime);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Date && runtimeType == other.runtimeType && _dateTime == other._dateTime;

  @override
  int get hashCode => _dateTime.hashCode;

  bool operator <(Object other) =>
      !identical(this, other) &&
      other is Time &&
      runtimeType == other.runtimeType &&
      _dateTime.compareTo(other.dateTime) < 0;

  bool operator >(Object other) =>
      !identical(this, other) &&
      other is Time &&
      runtimeType == other.runtimeType &&
      _dateTime.compareTo(other.dateTime) > 0;
}
