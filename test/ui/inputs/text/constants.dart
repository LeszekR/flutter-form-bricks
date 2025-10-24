//This class needs a place, should be placed where it's suitable.
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class ConstantsText {
  static const String TEXT_SIMPLE_FIELD_KEY = "regular_input_single";
  static const String TEXT_MULTILINE_FIELD_KEY = "4 bulkText";
  static const String TEXT_UPPERCASE_FIELD_KEY = "5 uppercase text";
  static const String TEXT_LOWERCASE_FIELD_KEY = "2 lowercase text";
  static const String TEXT_UPPER_LOWER_FIELD_KEY = "first_uppercase_text_single 2";

  static Map<String, Future<void> Function()> getInputs(WidgetTester tester) {
    return {
      'Enter': () async {
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      },
      'Tab': () async {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      },
      'Mouse': () async {
        TestPointer testPointer = TestPointer(1, PointerDeviceKind.mouse);
        await tester.sendEventToBinding(testPointer.down(const Offset(0, 100)));
        await tester.sendEventToBinding(testPointer.up());
        await tester.pump();
      }
    };
  }
}
