import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/error_position.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_bottom_space_config.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_editing_area_config.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/widget_height_probe.dart';

/// Provides method for measuring TextField with error/helper/counter space below it. Then the measured
/// height can be used in `LabelledBox` to create pixel-perfect layout with a button or outer label.
class HeightResolver {
  static Column buildHeightMeasuringProbes(
    TextFieldEditingAreaConfig editingAreaConfig,
    TextFieldBottomSpaceConfig bottomSpaceConfig,
    ErrorPosition? errorPosition,
    List<TextEditingController> controllers,
    ValueChanged<double> setTextEditingAreaHeight,
    ValueChanged<double> setHeightWithError,
    ValueChanged<double> setHeightWithHelper,
    ValueChanged<double> setHeightWithCounter,
  ) {
    List<Widget> children = [];
    TextFieldBottomWidgetConfig? config;

    children.add(_buildHeightProbe(editingAreaConfig, editingAreaConfig, null, setTextEditingAreaHeight, controllers));

    config = bottomSpaceConfig.errorConfig;
    if (config != null) {
      children.add(_buildHeightProbe(config, editingAreaConfig, config, setHeightWithError, controllers));
    }

    config = bottomSpaceConfig.helperConfig;
    if (config != null) {
      children.add(_buildHeightProbe(config, editingAreaConfig, config, setHeightWithHelper, controllers));
    }

    config = bottomSpaceConfig.counterConfig;
    if (config != null) {
      children.add(_buildHeightProbe(config, editingAreaConfig, config, setHeightWithCounter, controllers));
    }

    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  static SizedBox _buildHeightProbe(
    Equatable cacheKey,
    TextFieldEditingAreaConfig editingAreaConfig,
    TextFieldBottomWidgetConfig? bottomWidgetConfig,
    ValueChanged<double> onMeasured,
    List<TextEditingController> controllers,
  ) {
    return SizedBox(
      width: editingAreaConfig.width ?? 500,
      child: WidgetHeightProbe(
        cacheKey: cacheKey,
        measuredWidgetBuilder: (context) =>
            _buildTextFieldForMeasuring(editingAreaConfig, bottomWidgetConfig, controllers),
        onMeasured: onMeasured,
      ),
    );
  }

  static Widget _buildTextFieldForMeasuring(
    TextFieldEditingAreaConfig editingAreaConfig,
    TextFieldBottomWidgetConfig? bottomWidgetConfig,
    List<TextEditingController> controllers,
  ) {
    final controller = TextEditingController(text: editingAreaConfig.text);
    controllers.add(controller);
    return SizedBox(
      width: editingAreaConfig.width ?? 500,
      child: TextField(
        controller: controller,
        decoration: _copyInputDecorationForOneBottomWidget(editingAreaConfig, bottomWidgetConfig),
        style: editingAreaConfig.style,
        expands: editingAreaConfig.expands,
        strutStyle: editingAreaConfig.strutStyle,
        minLines: editingAreaConfig.minLines,
        maxLines: editingAreaConfig.maxLines,
      ),
    );
  }

  static InputDecoration _copyInputDecorationForOneBottomWidget(
    TextFieldEditingAreaConfig editingAreaConfig,
    TextFieldBottomWidgetConfig? bottomWidgetConfig,
  ) {
    final withError = bottomWidgetConfig is ErrorWidgetConfig && !bottomWidgetConfig.isEmpty;
    final withHelper = bottomWidgetConfig is HelperWidgetConfig && !bottomWidgetConfig.isEmpty;
    final withCounter = bottomWidgetConfig is CounterWidgetConfig && !bottomWidgetConfig.isEmpty;

    final InputDecoration srcDecoration = editingAreaConfig.decoration;

    return InputDecoration(
      labelText: srcDecoration.labelText,
      label: srcDecoration.label,
      hintText: srcDecoration.hintText,
      border: srcDecoration.border,
      enabledBorder: srcDecoration.enabledBorder,
      focusedBorder: srcDecoration.focusedBorder,
      contentPadding: srcDecoration.contentPadding,
      isDense: srcDecoration.isDense,
      visualDensity: srcDecoration.visualDensity,
      constraints: srcDecoration.constraints,
      filled: srcDecoration.filled,
      fillColor: srcDecoration.fillColor,
      //
      error: withError ? bottomWidgetConfig.widget : null,
      errorStyle: withError ? bottomWidgetConfig.textStyle : null,
      errorMaxLines: withError ? bottomWidgetConfig.maxLines : null,
      errorText: withError
          ? bottomWidgetConfig.widget == null
              ? bottomWidgetConfig.text
              : null
          : null,
      //
      helper: withHelper ? bottomWidgetConfig.widget : null,
      helperText: withHelper ? bottomWidgetConfig.text : null,
      helperStyle: withHelper ? bottomWidgetConfig.textStyle : null,
      helperMaxLines: withHelper ? bottomWidgetConfig.maxLines : null,
      //
      counter: withCounter ? bottomWidgetConfig.widget : null,
      counterText: withCounter ? bottomWidgetConfig.text : null,
      counterStyle: withCounter ? bottomWidgetConfig.textStyle : null,
    );
  }
}
