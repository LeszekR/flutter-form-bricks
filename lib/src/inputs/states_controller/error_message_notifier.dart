
import '../../forms/form_manager/form_manager.dart';

// TODO move creation of FocusNode to View
mixin ErrorMessageNotifier {
  void setFieldErrorListener(FormManager formManager, String keyString){
    var focusNode = formManager.getFocusNode(keyString);
    focusNode.addListener(() {
      if (focusNode.hasFocus) formManager.showFieldErrorMessage(keyString);
    });
  }
}