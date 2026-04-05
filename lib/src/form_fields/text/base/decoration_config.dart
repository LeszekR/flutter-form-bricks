// import 'package:flutter/material.dart' show InputDecoration, Widget;
// import 'package:flutter_form_bricks/src/form_fields/text/base/icon_button_config.dart';
// import 'package:flutter_form_bricks/src/form_fields/text/base/outer_label_config.dart';
//
// class DecorationConfig {
//   final InputDecoration? inputDecoration;
//   final OuterLabelConfig? outerLabelConfig;
//   final TextFieldButtonConfig? textFieldButtonConfig;
//
//   DecorationConfig({
//     this.inputDecoration,
//     this.outerLabelConfig,
//     this.textFieldButtonConfig,
//   })  : assert(
//           (outerLabelConfig != null ? 1 : 0) +
//                   (inputDecoration?.label != null ? 1 : 0) +
//                   (inputDecoration?.labelText != null ? 1 : 0) <= 1,
//           'Only one can be declared: outerLabel, outerLabelText, inputDecoration.label, or inputDecoration.labelText ',
//         ),
//         assert(
//           (inputDecoration?.suffix != null ? 1 : 0) +
//                   (inputDecoration?.suffixText != null ? 1 : 0) +
//                   (inputDecoration?.suffixIcon != null ? 1 : 0) +
//                   ((textFieldButtonConfig?.buttonSide == ButtonSide.right) ? 1 : 0) <= 1,
//           'Only one can be declared: textFieldButtonConfig.buttonSide.right, '
//               'inputDecoration.suffix, inputDecoration.suffixText, or inputDecoration.suffixIcon.',
//         ),
//         assert(
//           (inputDecoration?.prefix != null ? 1 : 0) +
//                   (inputDecoration?.prefixText != null ? 1 : 0) +
//                   (inputDecoration?.prefixIcon != null ? 1 : 0) +
//                   ((textFieldButtonConfig?.buttonSide == ButtonSide.left) ? 1 : 0) <= 1,
//           'Only one can be declared: textFieldButtonConfig.buttonSide.left, '
//               'inputDecoration.prefix, inputDecoration.prefixText, or inputDecoration.prefixIcon.',
//         ),
//         assert(
//           inputDecoration?.error == null || inputDecoration?.errorText == null,
//           'Only one can be declared: inputDecoration.error or inputDecoration.errorText.',
//         ),
//         assert(
//           inputDecoration?.hint == null || inputDecoration?.hintText == null,
//           'Only one can be declared: inputDecoration.hint or inputDecoration.hintText.',
//         ),
//         assert(
//           inputDecoration?.helper == null || inputDecoration?.helperText == null,
//           'Only one can be declared: inputDecoration.helper or inputDecoration.helperText.',
//         ),
//         assert(
//           inputDecoration?.counter == null || inputDecoration?.counterText == null,
//           'Only one can be declared: inputDecoration.counter or inputDecoration.counterText.',
//         ),
//         assert(
//           inputDecoration?.prefix == null || inputDecoration?.prefixText == null,
//           'Only one can be declared: inputDecoration.prefix or inputDecoration.prefixText.',
//         ),
//         assert(
//           inputDecoration?.suffix == null || inputDecoration?.suffixText == null,
//           'Only one can be declared: inputDecoration.suffix or inputDecoration.suffixText.',
//         );
// }
