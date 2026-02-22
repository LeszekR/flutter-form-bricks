import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/text/lowercase_formatter.dart';

class LowerCaseFieldDescriptor extends FormFieldDescriptor<TextEditingValue, String, LowerCaseField> {
  LowerCaseFieldDescriptor({
    required super.keyString,
    super.initialInput,
    super.isRequired = false,
    super.runValidatorsFullRun,
    super.additionalFormatterValidatorsMaker,
  }) : super(
          defaultFormatterValidatorsMaker: () => [
            LowercaseFormatter(),
          ],
        );
}

class LowerCaseField extends TextFieldBrick<String> {
  LowerCaseField({
    super.key,
    //
    // FormFieldBrick
    required super.keyString,
    required super.formManager,
    super.colorMaker,
    super.statesObserver,
    super.statesNotifier,
    //
    // BrickTextField
    super.width,
    //
    // TextField
    super.groupId = EditableText,
    super.controller,
    super.focusNode,
    super.undoController,
    super.decoration,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization = TextCapitalization.none,
    super.style,
    super.strutStyle,
    super.textAlign = TextAlign.start,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly = false,
    super.showCursor,
    super.autofocus = false,
    // super.statesController,  => replaced with statesObserver and statesNotifier
    super.obscuringCharacter = '•',
    super.obscureText = false,
    super.autocorrect = true,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions = true,
    super.maxLines = 1,
    super.minLines,
    super.expands = false,
    super.maxLength,
    super.maxLengthEnforcement,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onAppPrivateCommand,
    super.inputFormatters,
    super.enabled,
    super.ignorePointers,
    super.cursorWidth = 2.0,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.cursorErrorColor,
    super.selectionHeightStyle = BoxHeightStyle.tight,
    super.selectionWidthStyle = BoxWidthStyle.tight,
    super.keyboardAppearance,
    super.scrollPadding = const EdgeInsets.all(20.0),
    super.dragStartBehavior = DragStartBehavior.start,
    super.enableInteractiveSelection,
    super.selectAllOnFocus,
    super.selectionControls,
    super.onTap,
    super.onTapAlwaysCalled = false,
    super.onTapOutside,
    super.onTapUpOutside,
    super.mouseCursor,
    super.buildCounter,
    super.scrollController,
    super.scrollPhysics,
    super.autofillHints = const <String>[],
    super.contentInsertionConfiguration,
    super.clipBehavior = Clip.hardEdge,
    super.restorationId,
    super.stylusHandwritingEnabled = EditableText.defaultStylusHandwritingEnabled,
    super.enableIMEPersonalizedLearning = true,
    super.contextMenuBuilder,
    super.canRequestFocus = true,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
    super.buttonParams,
    super.hintLocales,
  }) : super(validateMode: ValidateModeBrick.onChange);

  @override
  LowerCaseFieldState createState() => LowerCaseFieldState();
}

class LowerCaseFieldState extends TextFieldStateBrick<String, LowerCaseField> {

  @override
  String? get defaultValue => controller.text;
}
