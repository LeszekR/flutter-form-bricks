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

- Creation of new specialised field: create the `FormFieldBrick` descendant, `FormFieldDescriptor`
  descendant dedicated for the field, set default `FormatterValidator` list in the
  `FormFieldDescriptor`,

ZOOM
By default, `flutter_form_bricks` does not require any scaling setup.

Advanced users may set `BricksThemeData.zoom` to scale form controls managed by the library. This
affects Bricks-controlled sizes such as field heights, labels, buttons, spacings and icon sizes.

For whole-app visual scaling outside the Bricks design system, Flutter’s `Transform.scale` can be
used at the application level, but it scales the rendered output rather than recomputing layout.

TEXT FIELD BUTTON

- `TextFieldButton` for a TextFieldBrick is created automatically when `TextFieldButtonConfig` is
  supllied
- `TextFieldButton` can react in sync with its color to its `TextFieldBrick` state. To make it work
  you must declare `TextfieldButtonConfig` for the `TextFieldBrick` and NOT declare
  `WidgetStatesController` for the `TextFieldBrick` - then the states controller will be created
  automatically as `DoubleWidgetStatesController` which will then sync both elements - the field and
  the button - color following their states. Since the states can be different tht
  `DoubleWidgetStatesController` uses priorities to present color of the most important state at the
  moment - e.g. "error", "disabled" - get priority over "focused", "hovered", etc 
