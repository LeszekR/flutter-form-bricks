import 'package:flutter/cupertino.dart';

extension StringToTextEditingValue on String {
  TextEditingValue toTextEditingValue() {
    return TextEditingValue(
      text: this,
      selection: TextSelection.collapsed(offset: length),
      composing: TextRange.empty,
    );
  }
}
