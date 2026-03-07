import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';

abstract class FormatterValidator<I extends Object, V extends Object> {
  final Type inputType = I;
  final Type valueType = V;

  FieldContent<I, V> run(
    BricksLocalizations localizations,
    String keyString,
    I input,
  );
}
