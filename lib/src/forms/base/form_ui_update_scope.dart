import 'package:flutter/widgets.dart';
import 'package:flutter_form_bricks/src/forms/base/form_ui_update_coordinator.dart';

class FormUiUpdateScope extends InheritedWidget {
  final FormUiUpdateCoordinator coordinator;

  const FormUiUpdateScope({
    super.key,
    required this.coordinator,
    required super.child,
  });

  static FormUiUpdateCoordinator of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FormUiUpdateScope>();
    assert(scope != null, 'No FormUiUpdateScope found in context');
    return scope!.coordinator;
  }

  @override
  bool updateShouldNotify(FormUiUpdateScope oldWidget) =>
      coordinator != oldWidget.coordinator;
}