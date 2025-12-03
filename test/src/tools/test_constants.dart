import 'package:flutter/cupertino.dart';

import '../../test_implementations/test_single_form.dart';

GlobalKey<TestSingleFormState> testFormGlobalKey = GlobalKey();

String formKeyString1 = 'formKeyString1';
String formKeyString2 = 'formKeyString2';

String fieldKeyString1 = 'fieldKeyString1';
String fieldKeyString2 = 'fieldKeyString2';
String fieldKString3 = 'fieldKeyString3';
String fieldKString4 = 'fieldKeyString4';

String stringInput1 = 'initialStringValue1';
String stringInput2 = 'initialStringValue2';
String stringInput3 = 'initialStringValue3';
String stringInput4 = 'initialStringValue4';

String newStringInput1 = 'newStringValue1';

String mockError1 = 'mockError1';

const String TEXT_SIMPLE_FIELD_KEY = "regular_input_single";
const String TEXT_MULTILINE_FIELD_KEY = "4 bulkText";
const String TEXT_UPPERCASE_FIELD_KEY = "5 uppercase text_formatter_validators";
const String TEXT_LOWERCASE_FIELD_KEY = "2 lowercase text_formatter_validators";
const String TEXT_UPPER_LOWER_FIELD_KEY = "first_uppercase_text_single 2";
