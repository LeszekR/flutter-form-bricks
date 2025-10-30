import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/forms/state/text_input_value.dart';

class PlainTextInput extends TextFieldBrick<String> {
  @override
  TextInputValue<String> getValue() {
    String value = controller.value;
    return TextInputValue<String>(value, value);
  }

}