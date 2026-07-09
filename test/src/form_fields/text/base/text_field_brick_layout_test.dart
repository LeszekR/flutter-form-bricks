import 'package:flutter_test/flutter_test.dart';

import 'text_field_brick_layout_test_case.dart';

void main() {
  group('TextFieldBrick layout', () {
    for (final c in textFieldBrickLayoutCases) {
      runTextFieldBrickLayoutCase(c);
    }
  });
}

/// Add your concrete cases here.
///
/// Intentionally empty: this file is the parameterized test machine only.
final List<TextFieldBrickLayoutTestCase> textFieldBrickLayoutCases = <TextFieldBrickLayoutTestCase>[
  const TextFieldBrickLayoutTestCase(),
];
