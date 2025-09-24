class FormFieldStateData<T> {
  T? initialValue;
  T? value;
  bool dirty; // value changed vs initial
  bool valid; // result of last validation
  bool validating; // if async validator running
  String? errorMessage;

  FormFieldStateData({this.initialValue})
      : dirty = false,
        valid = true,
        validating = false;
}
