import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_manager.dart';

mixin ErrorMessageNotifierOLD {
  void setErrorMessageListener(FormManagerOLD formManager, String keyString) {
    var focusNode = formManager.getFocusNode(keyString);
    focusNode.addListener(() {
      if (focusNode.hasFocus) formManager.showFieldErrorMessage(keyString);
    });
  }
}
