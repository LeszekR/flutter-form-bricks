// import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/timestamp_date_time_brick.dart';
//
// /// When backend is operates date or time only it is advised to use the classes below instead of DateTime
// class Time extends DateTime /*implements Comparable<Time>*/ {
//   // final DateTime _dateTime;
//
//   Time(super._dateTime);
//
//   DateTime get dateTime => dateTime;
//
//   static Time fromString(String stringVal) {
//     final parsed = _isSecondsPrecision(stringVal) //hotfix. Need to discuss the time handling in the project
//         ? DateTime.timeFormatSecondsPrecision.parseStrict(stringVal)
//         : DateTime.timeFormatMinutePrecision.parseStrict(stringVal);
//
//     return Time(parsed);
//   }
//
//   factory DateTime.fromDateTime(DateTime dateTime) {
//     DateTime dt = dateTime.dateTime;
//     return Time(DateTime(dt.hour, dt.minute, dt.second));
//   }
//
//   Time modify(Duration duration) {
//     return Time(dateTime.add(duration));
//   }
//
//   //duplicated method needed by JSON_SERIALIZER
//   factory DateTime.fromJson(String value) => fromString(value);
//
//   String toJson() => DateTime.timeFormatMinutePrecision.format(dateTime);
//
//   static bool _isSecondsPrecision(String input) {
//     return input.length > 5; //hh:mm  vs hh:mm:ss
//   }
//
// // @override
// // int compareTo(Time other) {
// //   return _dateTime.compareTo(other._dateTime);
// // }
// //
// // @override
// // String toString() => DateTime.timeFormatMinutePrecision.format(_dateTime);
// //
// // @override
// // bool operator ==(Object other) =>
// //     identical(this, other) || other is Time && runtimeType == other.runtimeType && _dateTime == other._dateTime;
// //
// // @override
// // int get hashCode => _dateTime.hashCode;
// //
// // bool operator <(Object other) =>
// //     !identical(this, other) && other is Time && runtimeType == other.runtimeType &&
// //         _dateTime.compareTo(other.dateTime) < 0;
// //
// // bool operator >(Object other) =>
// //     !identical(this, other) && other is Time && runtimeType == other.runtimeType &&
// //         _dateTime.compareTo(other.dateTime) > 0;
// }
