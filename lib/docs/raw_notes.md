/// If TextFieldBrick receives TextEditingController in the constructor and the passed controller

/// text is null then its initial text is set to FormData.initialValue.

/// `FormFieldBrick` descendants do not declare their arg `initialValue` - initial value is passed
/// via `FormFieldDescriptor` → `FormSchema` → `FormManager` → `FormFieldBrick`