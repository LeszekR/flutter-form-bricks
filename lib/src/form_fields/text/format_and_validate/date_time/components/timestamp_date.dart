// import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/timestamp_date_time_brick.dart';
//
// /// When backend is operates date or time only it is advised to use the classes below instead of DateTime
// class DateTime extends DateTime /*implements Comparable<DateTime>*/ {
//   // static final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
//   // static final DateFormat timeFormatMinutePrecision = DateFormat("HH:mm");
//   // static final DateFormat timeFormatSecondsPrecision = DateFormat("HH:mm:ss");
//   // static final DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
//   // static final DateFormat dateHourFormat = DateFormat("yyyy-MM-dd HH:mm");
//   //
//   // final DateTime _dateTime;
//   //
//   // DateTime get dateTime => _dateTime;
//
//   DateTime(super._dateTime);
//
//   factory DateTime.fromDateTime(DateTime dateTime) {
//     DateTime dt = dateTime.dateTime;
//     return DateTime(DateTime(dt.year, dt.month, dt.day));
//   }
//
//   static DateTime fromString(String stringVal) {
//     final parsed = DateTime.dateFormat.parseStrict(stringVal);
//     return DateTime(parsed);
//   }
//
//   DateTime modify(Duration duration) {
//     return DateTime(dateTime.add(duration));
//   }
//
//   DateTime subtract(Duration duration) {
//     return DateTime(dateTime.subtract(duration));
//   }
//
//   DateTime add(Duration duration) {
//     return DateTime(dateTime.add(duration));
//   }
//
//   //duplicated method needed by JSON_SERIALIZER
//   factory DateTime.fromJson(String value) => fromString(value);
//
//   String toJson() => DateTime.dateFormat.format(dateTime);
//
//   @override
//   String toString() => DateTime.dateFormat.format(dateTime);
//
// //   @override
// //   int compareTo(DateTime other) {
// //     return _dateTime.compareTo(other._dateTime);
// //   }
// //
// //   @override
// //   bool operator ==(Object other) =>
// //       identical(this, other) || other is DateTime && runtimeType == other.runtimeType && _dateTime == other._dateTime;
// //
// //   @override
// //   int get hashCode => _dateTime.hashCode;
// //
// //   bool operator <(Object other) =>
// //       !identical(this, other) &&
// //       other is Time &&
// //       runtimeType == other.runtimeType &&
// //       _dateTime.compareTo(other.dateTime) < 0;
// //
// //   bool operator >(Object other) =>
// //       !identical(this, other) &&
// //       other is Time &&
// //       runtimeType == other.runtimeType &&
// //       _dateTime.compareTo(other.dateTime) > 0;
// }
