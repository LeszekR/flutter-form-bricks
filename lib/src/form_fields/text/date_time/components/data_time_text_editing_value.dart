import 'package:flutter/material.dart';

class DateTimeRangeTextEditingValue {
  final DateTimeTextEditingValue start;
  final DateTimeTextEditingValue end;

  const DateTimeRangeTextEditingValue(this.start, this.end);
}

class DateTimeTextEditingValue {
  final TextEditingValue? dateEditingValue;
  final TextEditingValue? timeEditingValue;

  const DateTimeTextEditingValue(this.dateEditingValue, this.timeEditingValue);
}
