import 'package:flutter/material.dart';

import '../../style/app_color.dart';
import '../../style/app_size.dart';
import '../../style/app_style.dart';

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

  bool _isChecked = false;

  @override
  _RadioButtonCustomState createState() => _RadioButtonCustomState();
}

class _RadioButtonCustomState extends State<_RadioButtonCustom> {
  @override
  Widget build(BuildContext context) {
    var textContainer = Container(
      // width: ((widget.width ?? AppSize.inputTextWidth) - AppSize.inputTextHeight),
      height: AppSize.inputTextHeight,
      decoration: BoxDecoration(color: AppColor.formWorkAreaBackground),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.label,
        style: AppStyle.inputLabelStyle(),
      ),
    );

    var iconContainer = Container(
      width: AppSize.inputTextHeight,
      height: AppSize.inputTextHeight,
      decoration: BoxDecoration(color: AppColor.formWorkAreaBackground),
      child: GestureDetector(
        onTap: () => setChecked,
        child: widget._isChecked
            ? Icon(
          Icons.check_circle,
          size: AppSize.inputTextHeight * AppSize.radioScale,
          color: Colors.black, //AppColor.radioSelected,
        )
            : Icon(
          Icons.circle_outlined,
          size: AppSize.inputTextHeight * AppSize.radioScale,
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
      widget._isChecked = !widget._isChecked;
    });
  }
}
