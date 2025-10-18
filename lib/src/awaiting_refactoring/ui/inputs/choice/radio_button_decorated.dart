import 'package:flutter/material.dart';

import '../../../../ui_params/ui_params.dart';

class RadioButtonDecorated extends StatelessWidget {
  final String label;
  final double borderWidth;
  final Color selectedColor;
  final Color unselectedColor;

  const RadioButtonDecorated({
    super.key,
    required this.label,
    this.borderWidth = 2.0,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

class _RadioButtonCustom extends StatefulWidget {
  _RadioButtonCustom({
    required this.label,
    required this.value,
    required this.labelOnTheLeft,
  });

  final String label;
  final String value;
  final bool labelOnTheLeft;

  @override
  _RadioButtonCustomState createState() => _RadioButtonCustomState();
}

class _RadioButtonCustomState extends State<_RadioButtonCustom> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;
    final appStyle = uiParams.appStyle;
    final appColor = uiParams.appColor;
    var textContainer = Container(
      // width: ((widget.width ?? appSize.textFieldWidth) - appSize.inputTextLineHeight),
      height: appSize.inputTextLineHeight,
      decoration: BoxDecoration(color: appColor.formWorkAreaBackground),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.label,
        style: appStyle.inputLabelStyle(),
      ),
    );

    var iconContainer = Container(
      width: appSize.inputTextLineHeight,
      height: appSize.inputTextLineHeight,
      decoration: BoxDecoration(color: appColor.formWorkAreaBackground),
      child: GestureDetector(
        onTap: () => setChecked,
        child: _isChecked
            ? Icon(
                Icons.check_circle,
                size: appSize.inputTextLineHeight * appSize.radioScale,
                color: Colors.black, //AppColor.radioSelected,
              )
            : Icon(
                Icons.circle_outlined,
                size: appSize.inputTextLineHeight * appSize.radioScale,
                color: Colors.black, //AppColor.radioSelected,
              ),
      ),
    );

    var flexibleFill = const Expanded(child: SizedBox(width: 0));

    return Row(
      children: widget.labelOnTheLeft
          ? [textContainer, flexibleFill, iconContainer]
          : [iconContainer, flexibleFill, textContainer],
    );
  }

  void setChecked() {
    setState(() {
      _isChecked = !_isChecked;
    });
  }
}
