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

ASSERTS

Other than Flutter's practise to ignore params when they are irrelevant here numerous asserts guard
against using not only contradictory but als redundant params. Initially it may be annoying but in
the long run it reduces amount of debugging by preventing scenarios where params you declare seem
not to work as expected - while they are actually redundant because of other params
defining construction of given widget.  
Example: `OuterLabelConfig.width` must not be declared when `OuterLabelConfig.side` is `Side.top` or
`Side.bottom`. (Here because outer label placed over or below the text field must get its width from
its parent Widget.)

TEXTFIELDBRICK ADDED OUTER ELEMENTS HEIGHT

Flutter offers no API to read actual Height of a `TextField`. Since `TextFieldBrick` under the hood
actually creates a `TextField` it never knows the exact height of the field. But the height is
necessary to correctly scale additional elements: `TextFieldButton` and outer label. The simplest,
although not elegant workaround was to set the height of those elements manually.  
The height you pass will be scaled with `AppSize.zoom` factor so it will follow zooming in and out
of the UI.
The correct ways to find out the height are

- run the app with Flutter Dev Tools and read the actual height of the text field
- if the outer label is placed on `Side.left` or `Side.right`set exactly the same height in
  `OuterLabelConfig` .
- set in your (or default) implementation of `AppSize.textFieldHeight` to the same height - this
  will set `TextFieldButton` height (unless you set a different height in `TextFieldButtonConfig`)

