class FormFieldStateData<T> {
  T? value;
  bool dirty = false; // value changed vs initialValue
  bool valid = true; // result of last validation
  bool validating = false; // if async validator running
  String? errorMessage;

  FormFieldStateData([T? initialValue]) : value = initialValue;
}
