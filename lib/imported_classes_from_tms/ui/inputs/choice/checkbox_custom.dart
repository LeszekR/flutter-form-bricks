import 'package:flutter/material.dart';

import 'choice_inputs.dart';

class CheckboxCustom extends StatelessWidget {
  final String keyString;
  final String label;
  final bool labelLeftOfCheckbox;
  final ECheckboxShape shapeType;
  bool? initialValue;
  final ValueChanged<bool?>? onChanged;
  final bool readOnly;
  final double? width;


  CheckboxCustom({
    super.key,
    required this.keyString,
    required this.label,
    required this.labelLeftOfCheckbox,
    required this.onChanged,
    this.initialValue = false,
    this.readOnly = false,
    this.shapeType = ECheckboxShape.square,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    double checkboxScale, checkboxSize, borderRadius;

    var spacer = Expanded(child: SizedBox(height: AppSize.inputTextHeight));

    switch (shapeType) {
      case (ECheckboxShape.square):
        {
          checkboxScale = AppSize.checkboxScaleSquare;
          checkboxSize = checkboxScale * AppSize.inputTextHeight;
          borderRadius = 0;
          break;
        }
      case (ECheckboxShape.round):
        {
          checkboxScale = AppSize.checkboxScaleRound;
          checkboxSize = checkboxScale * AppSize.inputTextHeight;
          borderRadius = checkboxSize / 2;
          break;
        }
    }
    var inputWidth = width ?? AppSize.inputTextWidth;
    var textWidth = inputWidth - checkboxSize;

    final checkbox = Checkbox(
      key: Key(keyString),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      value: initialValue,
      onChanged: onChanged,
      side: AppStyle.borderFieldSideEnabled,
    );

    final checkboxField = Container(
      width: checkboxSize * 0.7,
      height: checkboxSize * 0.7,
      alignment: labelLeftOfCheckbox ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColor.formFieldFillOk,
        border: Border.all(color: Colors.black, width: AppSize.borderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Transform.scale(
        scale: checkboxScale,
        child: checkbox,
      ),
    );

    var labelBox = SizedBox(
      width: textWidth,
      child: Text(label, style: AppStyle.labelTextStyle),
    );

    List<Widget> widgets = [];
    if (labelLeftOfCheckbox) {
      widgets.add(labelBox);
      widgets.add(spacer);
      widgets.add(checkboxField);
    } else {
      widgets.add(checkboxField);
      widgets.add(spacer);
      widgets.add(labelBox);
    }

    return SizedBox(
      width: inputWidth,
      height: AppSize.inputTextHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets,
      ),
    );
  }
}

class CheckboxData {
  const CheckboxData(this.id, this.label, this.initialValue);

  final String id;
  final String label;
  final bool initialValue;
}
