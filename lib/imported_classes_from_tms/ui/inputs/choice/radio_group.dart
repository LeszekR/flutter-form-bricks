import 'package:flutter/material.dart';

import '../../style/app_size.dart';
import 'checkbox_custom.dart';
import 'choice_inputs.dart';
import '../../forms/form_manager/form_manager.dart';

class RadioGroup extends StatefulWidget {
  final String groupLabel;
  final Map<String, String> options;
  final bool labelOnLeft;
  final double? width;
  final bool readonly;
  final FormManager? formManager;

  const RadioGroup({
    super.key,
    required this.groupLabel,
    required this.options,
    required this.labelOnLeft,
    required this.width,
    this.readonly = false,
    this.formManager,
  });

  @override
  State<StatefulWidget> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  static String errorRadioGroupLessThan2 = 'RadioGroup must contain at least 2 Radios';
  static String errorRadioGroupMultiKeys = 'RadioGroup cannot be built - duplicated label';
  static String errorRadioGroupMultiValues = 'RadioGroup cannot be built - duplicated value';

  final Map<String, CheckboxCustom> _radioButtons = {};
  final Map<String, bool> _radioValues = {};

  var _width = -10.0;

  var tmpBool = false;

  @override
  void initState() {
    assertMinTwoOptions();
    assertNoDuplicates();

    _width = widget.width ?? AppSize.inputTextWidth;
    widget.options.forEach((id, label) {
      _radioValues.addAll({id: false});
    });

    // widget.formManager.addInputLabelMapping(widget.key.toString()/*, widget.groupLabel*/);

    super.initState();
  }

  void assertMinTwoOptions() {
    assert(widget.options.length > 1, errorRadioGroupLessThan2);
  }

  void assertNoDuplicates() {
    int i = 0, k = 0;
    widget.options.forEach((key1, value1) {
      i = 0;
      k = 0;
      widget.options.forEach((key2, value2) {
        if (key1 == key2) i++;
        assert(i < 2, errorRadioGroupMultiKeys);
        if (value1 == value2) k++;
        assert(k < 2, errorRadioGroupMultiValues);
      });
    });
  }

  void makeRadioButtons() {
    _radioButtons.clear();

    widget.options.forEach((id, label) {
      _radioButtons[id] = CheckboxCustom(
        keyString: id,
        label: label,
        initialValue: _radioValues[id]!,
        labelLeftOfCheckbox: widget.labelOnLeft,
        onChanged: (val) => onClicked(id),
        shapeType: ECheckboxShape.round,
        width: _width,
        readOnly: widget.readonly,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    makeRadioButtons();

    return SizedBox(
      width: _width,
      height: widget.options.length * AppSize.inputTextHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _radioButtons.values.toList(),
      ),
    );
  }

  void onClicked(String idActive) {
    setState(() {
      _radioValues.forEach((id, value) {
        _radioValues[id] = _radioButtons[id]!.keyString == idActive;
      });
    });
  }

  String getAcceptedOption() {
    var acceptedOption = '';
    _radioValues.forEach((id, radio) {
      if (radio) {
        acceptedOption = id;
      }
    });
    return acceptedOption;
  }
}
