import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_bricks/src/ui/inputs/states_controller/update_once_widget_states_controller.dart';

class DoubleWidgetStatesController extends WidgetStatesController implements ValueListenable<Set<WidgetState>> {
  final WidgetStatesController receiverStatesController = WidgetStatesController();
  final UpdateOnceWidgetStatesController lateWidgetStatesController = UpdateOnceWidgetStatesController();

  final Set<WidgetState> _newState1 = {};
  final Set<WidgetState> _newState2 = {};

  final Set<WidgetState> _newValue = {};
  var dummyState = WidgetState.focused;

  WidgetState? lastState;

  DoubleWidgetStatesController() {
    receiverStatesController.addListener(() => setNewWidgetState(receiverStatesController));
    lateWidgetStatesController.addListener(() => setNewWidgetState(lateWidgetStatesController));
  }

  // TODO check whether can't be simplified to only manipulating Set<WidgetState> of regular WidgetStatesController
  void setNewWidgetState(WidgetStatesController controller) {
    WidgetState? newState;

    if (controller == receiverStatesController) {
      _newState1.clear();
      _newState1.addAll(controller.value);
    }
    if (controller == lateWidgetStatesController) {
      _newState2.clear();
      _newState2.addAll(controller.value);
    }

    _newValue.clear();
    _newValue.addAll(_newState1);
    _newValue.addAll(_newState2);

    newState = extractDominantState();

    if (newState == null) {
      value.clear();
      value.add(dummyState);
      scheduleUpdate(dummyState, false);
    } else {
      value.clear();
      scheduleUpdate(newState, true);
    }
  }

  WidgetState? extractDominantState(/*WidgetState? newState*/) {
    WidgetState? newState;
    if (_newValue.contains(WidgetState.disabled)) {
      newState = WidgetState.disabled;
    } else if (_newValue.contains(WidgetState.error)) {
      newState = WidgetState.error;
    } else if (_newValue.contains(WidgetState.focused) || _newValue.contains(WidgetState.pressed)) {
      newState = WidgetState.focused;
    } else if (_newValue.contains(WidgetState.hovered)) {
      newState = WidgetState.hovered;
    }
    return newState;
  }

  void scheduleUpdate(WidgetState? newState, bool add) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      super.update(newState!, add);
    });
  }
}
