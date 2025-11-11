/// If TextFieldBrick receives TextEditingController in the constructor and the passed controller

/// text is null then its initial text is set to FormData.initialValue.

/// `FormFieldBrick` descendants do not declare their arg `initialValue` - initial value is passed
/// via `FormFieldDescriptor` → `FormSchema` → `FormManager` → `FormFieldBrick`

/// `FormManager.focusedKeyString` must be set. Then when a field losses focus and no other
/// FormFieldBrick acquires it then focusedKeyString remains unchanged and the last error message
/// is displayed - example case: clicking a button

/// Args `String keyString` and `FormatValidatePayload payload` passed to `FormatterValidator`
/// allow passing additional data to `FormatterValidator` should be required in future implementations.
/// Already `keyString` is required by `DateTimeRangeFormatterValidator` to identify which of the
/// range fields is triggering the validation so that the others are not validated only their
/// errors are read from `RangeController.errorsCacheMap`


