import 'package:intl/intl.dart';

/*
* When backend is service date or time only it is advised to use the classes below instead of DateTime
*
* */
class Date implements Comparable<Date> {

  static final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  static final DateFormat timeFormatMinutePrecision = DateFormat("HH:mm");
  static final DateFormat timeFormatSecondsPrecision = DateFormat("HH:mm:ss");
  static final DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
  static final DateFormat dateHourFormat = DateFormat("yyyy-MM-dd HH:mm");


  final DateTime _dateTime;

  Date(this._dateTime);

  static Date now() {
    return Date(DateTime.now());
  }

  static Date fromString(String stringVal) {
    final parsed = dateFormat.parseStrict(stringVal);
    return Date(parsed);
  }

  // Date modify(Duration duration) {
  //   return Date(_dateTime.add(duration));
  // }

  Date subtract(Duration duration) {
    return Date(_dateTime.subtract(duration));
  }

  Date add(Duration duration) {
    return Date(_dateTime.add(duration));
  }

  //duplicated method needed by JSON_SERIALIZER
  factory Date.fromJson(String value) => fromString(value);
  String toJson() => dateFormat.format(_dateTime);

  DateTime get dateTime => _dateTime;

  @override
  String toString() => dateFormat.format(_dateTime);

  @override
  int compareTo(Date other) {
    return _dateTime.compareTo(other._dateTime);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Date && runtimeType == other.runtimeType && _dateTime == other._dateTime;

  @override
  int get hashCode => _dateTime.hashCode;
}

class Time  implements Comparable<Date> {
  final DateTime _dateTime;

  Time(this._dateTime);

  static Time now() {
    return Time(DateTime.now());
  }

  static Time fromString(String stringVal) {
    final parsed = _isSecondsPrecision(stringVal) //hotfix. Need to discuss the time handling in the project
        ? Date.timeFormatSecondsPrecision.parseStrict(stringVal)
        : Date.timeFormatMinutePrecision.parseStrict(stringVal);

    return Time(parsed);
  }

  Time modify(Duration duration) {
    return Time(_dateTime.add(duration));
  }

  //duplicated method needed by JSON_SERIALIZER
  factory Time.fromJson(String value) => fromString(value);
  String toJson() => Date.timeFormatMinutePrecision.format(_dateTime);

  static bool _isSecondsPrecision(String input) {
    return input.length > 5; //hh:mm  vs hh:mm:ss
  }

  @override
  int compareTo(Date other) {
    return _dateTime.compareTo(other._dateTime);
  }

  DateTime get dateTime => _dateTime;

  @override
  String toString() => Date.dateFormat.format(_dateTime);

  @override
  bool operator ==(Object other) => identical(this, other) || other is Date && runtimeType == other.runtimeType && _dateTime == other._dateTime;

  @override
  int get hashCode => _dateTime.hashCode;
}