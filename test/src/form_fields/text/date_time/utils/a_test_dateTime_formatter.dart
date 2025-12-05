import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

abstract class ATestDateTimeFormatter {
  DateTimeFieldContent makeDateTime(
    BricksLocalizations localizations,
    String fieldKeyString,
    String inputString,
  );
}

abstract class ATestDateFormatter {
  DateFieldContent makeDate(
    BricksLocalizations localizations,
    String fieldKeyString,
    String inputString,
  );
}

abstract class ATestTimeFormatter {
  TimeFieldContent makeTime(
    BricksLocalizations localizations,
    String fieldKeyString,
    String inputString,
  );
}
