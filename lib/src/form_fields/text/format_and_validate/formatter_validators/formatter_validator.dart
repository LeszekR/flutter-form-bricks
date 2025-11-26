import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';

abstract class FormatterValidator<I extends Object, V extends Object> {
  FieldContent<I, V> run(
    BricksLocalizations localizations,
    String keyString,
    FieldContent<I, V> fieldContent,
  );
}
