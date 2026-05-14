import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class UpdateOnceWidgetStatesController extends WidgetStatesController {

  void updateOnce(WidgetState state, bool add) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      super.update(state, add);
    });
  }

  @override
  void update(WidgetState state, bool add) {
    // do nothing! the state has been updated in updateOnce.
    // otherwise IconButton fires 3 times after updateOnce (which propagates correct actual state), but with empty
    // controller value what deletes the very state we want to keep
  }
}
