import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';

abstract class FormatterValidator<Input, Value> {
  FieldContent<Input, Value> run(
    BricksLocalizations localizations,
    String keyString,
    FieldContent<Input, Value> fieldContent,
  );
}
