import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/compound_widget_states_controller.dart';

class StatesControllerProvider {
  final WidgetStatesController? widgetStatesController;
  final CompoundWidgetStatesController? compoundWidgetStatesController;

  const StatesControllerProvider(
    this.widgetStatesController,
    this.compoundWidgetStatesController,
  ) : assert((widgetStatesController == null) != (compoundWidgetStatesController == null),
            'Either widgetStatesController or compoundWidgetStatesController must be provided');
}
