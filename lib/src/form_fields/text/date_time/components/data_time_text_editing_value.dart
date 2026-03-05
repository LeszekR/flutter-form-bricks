import 'package:flutter/material.dart';

class DateTimeRangeTextEditingValue extends TextEditingValue {
  final DateTimeTextEditingValue start;
  final DateTimeTextEditingValue end;

  const DateTimeRangeTextEditingValue(this.start, this.end);
}

class DateTimeTextEditingValue extends TextEditingValue {
  final TextEditingValue? dateEditingValue;
  final TextEditingValue? timeEditingValue;

  const DateTimeTextEditingValue(this.dateEditingValue, this.timeEditingValue);
}
