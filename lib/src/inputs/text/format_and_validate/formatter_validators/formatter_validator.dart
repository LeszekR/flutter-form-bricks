import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_payload.dart';

abstract class FormatterValidator<I, V, P extends FormatValidatePayload> {
  FieldContent<I, V> run(
      BricksLocalizations localizations,
      FieldContent<I, V> fieldContent, [
        P? payload,
      ]);
}
