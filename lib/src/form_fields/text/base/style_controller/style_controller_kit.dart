import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/style_controller/compound_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/style_controller/double_widget_states_controller.dart';

class StyleControllerKit {
  // final DoubleWidgetStatesController doubleWidgetStatesController;
  final CompoundWidgetStatesController compoundWidgetStatesController;
  final StatesColorMaker statesColorMaker;

  const StyleControllerKit(
    this.compoundWidgetStatesController,
    // this.doubleWidgetStatesController,
    this.statesColorMaker,
  );
}
