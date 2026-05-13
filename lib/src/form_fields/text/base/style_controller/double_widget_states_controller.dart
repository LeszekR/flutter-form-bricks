import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/style_controller/update_once_widget_states_controller.dart';

class DoubleWidgetStatesController extends WidgetStatesController implements ValueListenable<Set<WidgetState>> {
  // final WidgetStatesController statesObserver = UpdateOnceWidgetStatesController();
  final WidgetStatesController statesObserver = WidgetStatesController();
  final UpdateOnceWidgetStatesController updateOnceWidgetStatesController = UpdateOnceWidgetStatesController();

  final Set<WidgetState> _newState1 = {};
  final Set<WidgetState> _newState2 = {};

  final Set<WidgetState> _newValue = {};
  var dummyState = WidgetState.focused;

  WidgetState? lastState;

  DoubleWidgetStatesController() {
    statesObserver.addListener(() => setNewWidgetState(statesObserver));
    updateOnceWidgetStatesController.addListener(() => setNewWidgetState(updateOnceWidgetStatesController));
  }

  // TODO check whether can't be simplified to only manipulating Set<WidgetState> of regular WidgetStatesController
  void setNewWidgetState(WidgetStatesController controller) {
    if (controller.value.isEmpty) return;

    WidgetState? newState;

    if (controller == statesObserver) {
      _newState1.clear();
      _newState1.addAll(controller.value);
      print('statesObserver add: ${controller.value.toString()}');
    }
    if (controller == updateOnceWidgetStatesController) {
      _newState2.clear();
      _newState2.addAll(controller.value);
      print('updateOnceStatesController add: ${controller.value.toString()}');
    }

    _newValue.clear();
    _newValue.addAll(_newState1);
    _newValue.addAll(_newState2);
    print('_newValue states: ${controller.value.toString()}');

    newState = extractDominantState();

    if (newState == null) {
      value.clear();
      value.add(dummyState);
      scheduleUpdate(dummyState, false);
    } else {
      // value.clear();
      for (WidgetState state in value) {
        print('remove: ${state.toString()}');
        update(state, false);
      }
      // value.addAll(_newValue);
      // for(WidgetState state in value) {
      //   print('add: ${state.toString()}');
      //   update(state, true);
      // }
      value.add(newState);
      print('newState: ${newState.toString()}');
      print('controller before: ${value.toString()}');
      scheduleUpdate(newState, true);
    }
    print('controller after: ${value.toString()}');
  }

  WidgetState? extractDominantState() {
    WidgetState? newState;
    if (_newValue.contains(WidgetState.disabled)) {
      newState = WidgetState.disabled;
    } else if (_newValue.contains(WidgetState.error)) {
      newState = WidgetState.error;
    } else if (_newValue.contains(WidgetState.hovered)) {
      newState = WidgetState.hovered;
    } else if (_newValue.contains(WidgetState.focused) || _newValue.contains(WidgetState.pressed)) {
      newState = WidgetState.focused;
    }
    return newState;
  }

  void scheduleUpdate(WidgetState? newState, bool add) {
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    super.update(newState!, add);
    // });
  }
}
