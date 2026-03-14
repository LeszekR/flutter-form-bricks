import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/current_date.dart';

/// Configuration object - **date-with-time** limits for `DateTimeFormatterValidator` and `DateTimeRangeFormatterValidator`.
///
/// In case only lower or only upper limit are required `null` must be passed as the other limit.
class DateTimeLimits {
  final int? maxMinutesBack;
  final int? maxMinutesForward;
  final CurrentDate? currentDate;
  final DateTime? fixedReferenceDateTime;

  DateTimeLimits({
    this.currentDate,
    this.fixedReferenceDateTime,
    this.maxMinutesBack,
    this.maxMinutesForward,
  }) {
    _checkDateTimeLimits(this);
  }

  DateTime? get minDateTime =>
      maxMinutesBack == null ? null : _referencePoint().subtract(Duration(minutes: maxMinutesBack!));

  DateTime? get maxDateTime =>
      maxMinutesForward == null ? null : _referencePoint().add(Duration(minutes: maxMinutesForward!));

  DateTime? get maxDateWithoutTime {
    DateTime? maxDT = maxDateTime;
    if (maxDT == null) return null;
    return DateTime(maxDT.year, maxDT.month, maxDT.day);
  }

  DateTime? get minDateWithoutTime {
    DateTime? minDT = minDateTime;
    if (minDT == null) return null;
    return DateTime(minDT.year, minDT.month, minDT.day);
  }

  DateTime _referencePoint() => fixedReferenceDateTime ?? currentDate!.getDateNow();
}

class DateTimeRangeLimits {
  final DateTimeLimits? startDateTimeLimits;
  final DateTimeLimits? endDateTimeLimits;
  final int? minSpanMinutes;
  final int? maxSpanMinutes;

  DateTimeRangeLimits(
    this.startDateTimeLimits,
    this.endDateTimeLimits,
    this.minSpanMinutes,
    this.maxSpanMinutes,
  ) {
    _checkDateTimeRangeLimits(this);
  }
}

void _failDT(DateTimeLimits limits, String msg) => throw ArgumentError.value(limits, 'DateTimeLimits', msg);

void _failDTR(DateTimeRangeLimits limits, String msg) => throw ArgumentError.value(limits, 'DateTimeRangeLimits', msg);

void _checkDateTimeLimits(DateTimeLimits limits) {
  if ((limits.currentDate == null) == (limits.fixedReferenceDateTime == null)) {
    _failDT(limits, 'One of the two - currentDate or referenceDateTime - must be set');
  }
  if ((limits.maxMinutesBack == null) && (limits.maxMinutesForward == null)) {
    _failDT(limits, 'Either maxMinutesBack or maxMinutesForward or both must be set');
  }
  if (limits.maxMinutesBack != null && limits.maxMinutesBack! < 0) {
    _failDT(limits, 'DateTimeLimits.maxMinutesBack must be >= 0 (got ${limits.maxMinutesBack}).');
  }
  if (limits.maxMinutesForward != null && limits.maxMinutesForward! < 0) {
    _failDT(limits, 'DateTimeLimits.maxMinutesForward must be >= 0 (got ${limits.maxMinutesForward}).');
  }
  final DateTime? minDT = limits.minDateTime;
  final DateTime? maxDT = limits.maxDateTime;
  if (minDT != null && maxDT != null && minDT.isAfter(maxDT)) {
    _failDT(limits, 'DateTimeLimits has inverted bounds: minDateTime ($minDT) is after maxDateTime ($maxDT).');
  }
}

void _checkDateTimeRangeLimits(DateTimeRangeLimits limits) {
  final DateTimeLimits? startDateTimeLimits = limits.startDateTimeLimits;
  final DateTimeLimits? endDateTimeLimits = limits.endDateTimeLimits;
  final int? minSpanMinutes = limits.minSpanMinutes;
  final int? maxSpanMinutes = limits.maxSpanMinutes;

  // ---- span sanity ----
  if (minSpanMinutes != null && minSpanMinutes < 0) {
    _failDTR(limits, 'minSpanMinutes must be >= 0 (got $minSpanMinutes).');
  }
  if (maxSpanMinutes != null && maxSpanMinutes < 0) {
    _failDTR(limits, 'maxSpanMinutes must be >= 0 (got $maxSpanMinutes).');
  }
  if (minSpanMinutes != null && maxSpanMinutes != null && minSpanMinutes > maxSpanMinutes) {
    _failDTR(limits, 'minSpanMinutes ($minSpanMinutes) must be <= maxSpanMinutes ($maxSpanMinutes).');
  }

  // ---- cross-limits sanity (only if both exist and are fully/bounded enough) ----
  if (startDateTimeLimits != null && endDateTimeLimits != null) {
    final DateTime? startMin = startDateTimeLimits.minDateTime;
    final DateTime? startMax = startDateTimeLimits.maxDateTime;
    final DateTime? endMin = endDateTimeLimits.minDateTime;
    final DateTime? endMax = endDateTimeLimits.maxDateTime;

    // "Start limits start after start of end limits"
    if (startMin != null && endMin != null && startMin.isAfter(endMin)) {
      _failDTR(limits, 'Start range minimum ($startMin) cannot be after end range minimum ($endMin).');
    }

    // "Start limits end after end of end limits"
    if (startMax != null && endMax != null && startMax.isAfter(endMax)) {
      _failDTR(limits, 'Start range maximum ($startMax) cannot be after end range maximum ($endMax).');
    }

    // Additional illogical overlaps:
    // Start window entirely after end window (stronger than min/min + max/max checks)
    if (startMin != null && endMax != null && startMin.isAfter(endMax)) {
      _failDTR(limits, 'Start minimum ($startMin) cannot be after end maximum ($endMax).');
    }

    // Start max after end min is not always illegal (ranges can overlap),
    // but it becomes illegal if you require start <= end always AND both are single points.
    // We only enforce what is unambiguously inconsistent with declared bounds.

    // ---- span feasibility checks (if we have enough bounds) ----
    if (minSpanMinutes != null && startMin != null && endMax != null) {
      final int maxPossible = endMax.difference(startMin).inMinutes;
      if (maxPossible < minSpanMinutes) {
        _failDTR(
          limits,
          'minSpanMinutes ($minSpanMinutes) is impossible with the provided limits: '
          'endMax ($endMax) - startMin ($startMin) = $maxPossible minutes.',
        );
      }
    }

    if (maxSpanMinutes != null && startMax != null && endMin != null) {
      final int minPossible = endMin.difference(startMax).inMinutes;
      if (minPossible > maxSpanMinutes) {
        _failDTR(
          limits,
          'maxSpanMinutes ($maxSpanMinutes) is impossible with the provided limits: '
          'endMin ($endMin) - startMax ($startMax) = $minPossible minutes.',
        );
      }
    }
  }
}
