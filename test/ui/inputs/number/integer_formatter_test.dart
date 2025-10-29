import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/number/integer_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';

void main() {
  const TextEditingValue initial = TextEditingValue(text: "");

  group('should format integers', () {
    final List<TestData> testParameters = [
      TestData("123", "123"),
      TestData("123,", "1 23,"),
      TestData("123123", "123 123"),
      TestData("abcdefg", "a bcd efg"),
      TestData("100ABCD", "1 00A BCD"),
      TestData("100ABCD,123", "10 0AB CD, 123"),
      TestData("10ABCD,123 ", "1 0AB CD, 123"),
      TestData("100ABCD,123123", "10 0AB CD, 123 123"),
      TestData("100ABCD,123 123", "10 0AB CD, 123 123"),
    ];

    for (param in testParameters) {
      testWidgets('"${param.input}" -> "${param.expected}"', (WidgetTester tester) async {
        //given
        final TextEditingValue newInput = TextEditingValue(text: param.input);

        //when
        final result = IntegerInputFormatter().formatEditUpdate(initial, newInput);

        //then
        expect(result.text, param.expected);
      });
    }
  });
}
