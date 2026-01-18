- If `TextFieldBrick` receives a `TextEditingController` in the constructor and the passed
  controller’s text is `null`, its initial text is set from `FormData.initialValue`.

- `FormFieldBrick` descendants do not declare an `initialValue` argument. The initial value is
  supplied via `FormFieldDescriptor` → `FormSchema` → `FormManager` → `FormFieldBrick`.

- `FormManager.focusedKeyString` must be set. If a field loses focus and no other `FormFieldBrick`
  acquires focus, `focusedKeyString` remains unchanged and the last error message is displayed (
  e.g., when clicking a button).

- Arguments `String keyString` and `FormatterValidatorPayload payload` passed to
  `FormatterValidator` allow passing additional data to validators for future implementations.
  `keyString` is already required by `DateTimeRangeFormatterValidator` to identify which range field
  triggered validation, so the other fields are not revalidated and their errors are read from
  `RangeController.errorsCacheMap`.
