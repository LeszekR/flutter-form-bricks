import 'package:flutter/cupertino.dart';

extension StringToTextEditingValue on String {
  TextEditingValue txtEditVal() {
    return TextEditingValue(text: this);
  }
}