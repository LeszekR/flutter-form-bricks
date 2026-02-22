import 'package:flutter_form_bricks/shelf.dart';

abstract class FormData {
  String initiallyFocusedKeyString;
  final Map<String, FormFieldData> fieldDataMap = {};

  FormData({this.initiallyFocusedKeyString = ''});
}
