import 'package:flutter/material.dart';

import '../../test_implementations/test_single_form.dart';

GlobalKey<TestSingleFormState> testFormGlobalKey = GlobalKey();

String formKeyString1 = 'formKeyString_1';
String formKeyString2 = 'formKeyString_2';

String fieldKeyString1 = 'fieldKeyString_1';
String fieldKeyString2 = 'fieldKeyString_2';
String fieldKString3 = 'fieldKeyString_3';
String fieldKString4 = 'fieldKeyString_4';

String stringInput1 = 'initialStringInput_1';
String stringInput2 = 'initialStringInput_2';
String stringInput3 = 'initialStringInput_3';
String stringInput4 = 'initialStringInput_4';

String newStringInput1 = 'newStringInput_1';

String mockError1 = 'mockError_1';

const String TEXT_SIMPLE_FIELD_KEY = "regular_input_single";
const String TEXT_MULTILINE_FIELD_KEY = "4 bulkText";
const String TEXT_UPPERCASE_FIELD_KEY = "5 uppercase text_formatter_validators";
const String TEXT_LOWERCASE_FIELD_KEY = "2 lowercase text_formatter_validators";
const String TEXT_UPPER_LOWER_FIELD_KEY = "first_uppercase_text_single 2";
