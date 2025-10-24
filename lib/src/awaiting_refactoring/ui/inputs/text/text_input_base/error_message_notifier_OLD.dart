import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';

mixin ErrorMessageNotifierOLD {
  void setErrorMessageListener(FormManager formManager, String keyString) {
    var focusNode = formManager.getFocusNode(keyString);
    focusNode.addListener(() {
      if (focusNode.hasFocus) formManager.showFieldErrorMessage(keyString);
    });
  }
}
