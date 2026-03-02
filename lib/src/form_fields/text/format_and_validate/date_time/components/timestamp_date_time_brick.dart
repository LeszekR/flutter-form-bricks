// import 'package:intl/intl.dart';
//
// abstract class DateTime implements Comparable<DateTime> {
//   // TODO tidy up formatting of dates and times - now two sources: here and DateTimeUtils - integrate into one
//   static final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
//   static final DateFormat timeFormatMinutePrecision = DateFormat("HH:mm");
//   static final DateFormat timeFormatSecondsPrecision = DateFormat("HH:mm:ss");
//   static final DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
//
//   final DateTime _dateTime;
//
//   DateTime(this._dateTime);
//
//   DateTime get dateTime => _dateTime;
//
//   @override
//   int compareTo(DateTime other) {
//     return dateTime.compareTo(other.dateTime);
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//           other is DateTime && runtimeType == other.runtimeType && dateTime == other.dateTime;
//
//   @override
//   int get hashCode => dateTime.hashCode;
//
//   bool operator <(Object other) =>
//       !identical(this, other) &&
//           other is DateTime &&
//           runtimeType == other.runtimeType &&
//           dateTime.compareTo(other.dateTime) < 0;
//
//   bool operator >(Object other) =>
//       !identical(this, other) &&
//           other is DateTime &&
//           runtimeType == other.runtimeType &&
//           dateTime.compareTo(other.dateTime) > 0;
// }
