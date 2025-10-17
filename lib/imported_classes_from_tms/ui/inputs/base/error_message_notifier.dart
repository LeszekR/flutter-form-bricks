import 'package:shipping_ui/ui/forms/form_manager/form_manager.dart';

mixin ErrorMessageNotifier {
  void setErrorMessageListener(FormManager formManager, String keyString){
    var focusNode = formManager.getFocusNode(keyString);
    focusNode.addListener(() {
      if (focusNode.hasFocus) formManager.showFieldErrorMessage(keyString);
    });
  }
}