// import 'package:flutter_test/flutter_test.dart';
// import 'package:shipping_ui/ui/inputs/text/forbidden_whitespaces_formatter.dart';
//
// import '../../../test_data.dart';
//
// void main() {
//   group('Should always remove leading and double spaces (exception with the tail whitespaces but covered in form)', () {
//     final List<TestData> testParameters = [
//       TestData("I'll be back", "I'll be back"),
//       TestData(" I'll  be  back", "I'll be back"),
//     ];
//
//     for (final param in testParameters) {
//       testWidgets('Formatter should turn "${param.input}" into: "${param.expected}"', (WidgetTester tester) async {
//         //given
//         const TextEditingValue initial = TextEditingValue(text: "");
//         final TextEditingValue newInput = TextEditingValue(text: param.input);
//
//         //when
//         final result = ForbiddenWhitespacesFormatter().formatEditUpdate(initial, newInput);
//
//         //then
//         expect(result.text, param.expected);
//       });
//     }
//   });
// }
