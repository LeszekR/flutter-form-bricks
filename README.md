# Flutter Form Bricks

## Localizations

Since the lib contains a collection of standard UI messages and names it is localized. Follow flutter_localizations usage rules to add lnaguages by adding

## Gap analysis

As part of building this form library, I performed a **systematic gap analysis between Flutter’s
native form APIs (Form, FormField, RestorationMixin, etc.) and the advanced requirements of
enterprise-grade forms**. This involved surveying existing framework capabilities, identifying
overlaps, and defining clear boundaries for reuse, extension, or replacement. The outcome was an
architecture where Flutter’s proven primitives are leveraged wherever possible, and this library
adds missing features such as centralized validation, error summaries, tabbed form state, built-in
state restoration, etc.

### Key uniqueness guard

This project includes a **key-uniqueness guard** to prevent subtle Flutter bugs caused by duplicate
keys.

- **Classes**: `KeyGen` (marker), `KeyRegistry` (debug-time uniqueness checks), `ValueKeyGen`
  , `ObjectKeyGen`, `UniqueKeyGen`, `GlobalKeyGen`.
- **Mechanism**: In debug mode, every generated key is checked against a global registry. Duplicates
  immediately throw an error. In release builds, all checks are tree-shaken out → no runtime cost.
- **Why**: Flutter only enforces key uniqueness among siblings. Two widgets in the same form can
  share a `ValueKey("x")` and behave unpredictably. Our guard enforces **global uniqueness** during
  development to catch such mistakes.
- **Testing**: `KeyRegistry.reset()` is provided for unit tests to clear the registry between runs.
- **Future**: Eventually, all keys in this app will be supplied only through `KeyGen`
  implementations, ensuring full coverage.

### AutoValidateModeBrick

`AutoValidateModeBrick` defines when form fields automatically validate in Brick forms.

Unlike Flutter’s `AutovalidateMode`, Brick **always validates once before the first build**.  
This replaces Flutter’s default post-build validation and ensures that the form knows its initial
validity immediately.

This approach also allows `TabbedFormBrick` to validate `initialValue`s without instantiating states
for invisible tabs.  
Errors in those initial values (or their absence) can immediately mark the tab header with an error
state, even if the tab’s content hasn’t been built yet.

Modes:

- **onCreateOrSave** → validate before the first build, then only again when the form is saved (
  equivalent to Flutter’s `disabled`, but using pre-build instead of post-build validation).
- **onChange** → validate before the first build and on every change to the field’s value (
  equivalent to Flutter’s `onUserInteraction`, but using pre-build instead of post-build validation)
  .
- **onEditingComplete** → validate before the first build and when editing completes (focus loss, or
  user presses “done”). Useful when a `FormatterValidatorChain` can only complete its work on
  finished multi-character input, e.g. shortened date/time input.

There is no `always` mode: it is redundant in Brick, since every field already validates once before
the first build.  
All fields are also validated on form save, ensuring that external state changes are always taken
into account at that time.

⚠️ Brick does **not** validate fields on every focus gain. While this could catch rare cases where
external state changes affect a field’s validity, it would waste energy by running unnecessary
validations.  
This design deliberately favors slightly worse UX in rare edge cases over continuous revalidation on
focus.

### 🔹 Dual-State Input Handling

Each `FormFieldBrick` tracks:

- `inputString`: what the user types
- `value` (`T?`): the parsed, validated result (or `null` if invalid)

This design ensures:
- Safe typed values for saving
- Raw input preserved across rebuilds
- Friendly error handling without input loss

Validators (like `DateTimeFormatterValidator`) parse `inputString` and return `DateTimeFieldContent<T>` with:
- `parsedValue`: nullable, for precision control
- `errorMessage`: used for in-form feedback

On submit, parsed values are read from the field and passed to your domain layer for saving.


## TODO

**describe / explain / elaborate on:**

- `ElevatedButtonWithDisabling`

## Input widget stack

###

**Assumptions**

- every input in the UI must be labelled
- the label can be placed on top, to the left, to the right of the input
- colors assigned to states are unified across the app
- the colors of states can be overriden individually via passing overloaded AppStyle object
- if a menu/picker/list/etc opening button is attached to a text field it both the button and the
  text field mus react to the change in state of any of them
- states are prioritised so the more important state's color is displayed (e.g. disabled over error,
  error over others, etc)

###

**Elaborate on**

- `AppTheme` - global (scoped), dynamic, possibly scoped when overriding class used - less
  boilerplate, consistent look
- label position around BrickField
- `BrickTextField` can have `IconButton` for any use
- architecture: `LabelledContainer`, `TextFieldBox`, `BrickTextField`
  containint `StateAwareIconButton`
- formatting validation chain
- `FormManager` role: formatting, validation, storing state, collecting data from form_fields, initial
  values

**Visual params**

- Refactored AppColor, AppSize, AppStyle to abstract class + default implementation
- This way no static vars and dynamic change of theme, sizes are possible to implement
- AppStyle can also be overriden by a dev
- All three are accessed via InheritedWidget - this allows for scoping by replacing implementations
  for parts of the tree

###

**Architecture**

- all form_fields are put inside `LabelledContainer`

`LabelledContainer` provides

- label position setting
- bordered container providing unified style and color
- `ValueListenableBuilder` reacting to widget states with colors

**Widget classes**

- `TextFieldStateAware`
- `IconButtonStateAware`
- `(CheckBoxStateAware)`
- `(RadioStateAware)`
- `(DropBoxStateAware)`

**Text input variants**

- no button: `LabelledContainer` + `TextFieldColored`
- with button: `LabelledContainer` + `TextFieldColored` + `IconButtonColored`

### Form Creation and Initialization

- **FormSchema**
  - Declares each field’s `keyString`, value type, `initialValue`, and `FormatterValidatorChain`.
  - Declares `initialFocusKeyString` for the field that receives focus first.

- **FormManager**
  - Receives `FormSchema` and `FormStateData`.
  - Populates its `fieldContentMap`:
    - From **FormSchema** if `isInitiated == false`.
    - From **FormStateData** otherwise.
  - Runs validation on all fields and saves error messages in `FormFieldData`.

- **FormBrick**
  - Receives the initialized `FormManager` and builds all form fields.

- **FormFieldBrick**
  - Registers itself in `FormManager`.
  - Throws if its `keyString` isn’t in `FormSchema` or its value type mismatches.
  - Gets its initial value and `onFieldChanged` callback from `FormManager`.
  - `onFieldChanged`:
    - Validates the new value.
    - Updates `FormData` and triggers revalidation or saving.

  - **FormBrick**
   - must only use `keyStrings` declared in `FormSchema`
   - for validation to work

Ensures type safety, single source of truth, and automatic validation across the form.


### Centralized Validation Flow

- **`FormManager`** owns all `FormatterValidatorChain`s through the `FormSchema`.
- **`FormFieldBrick`** triggers validation by calling
  `formManager.onFieldChanged(keyString, value) -> validateField(keyString)`.
- **`FormManager`**:
  - Runs the corresponding `FormatterValidatorChain`.
  - Updates `FormData`
  - Returns a `ValidationResult` to the field.
  - notifies global UI error display area.
- **FormFieldBrick** reacts locally (color or inline error)
  without directly handling validation logic.

This architecture enforces a single source of truth for validation
and keeps all widgets stateless and presentation-focused.


-----------------------------------
## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file)
  or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file)
  files
- [ ] [Add files using the command line](https://docs.gitlab.com/topics/git/add_files/#add-files-to-a-git-repository)
  or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/zarzur/flutter-desktop-bricks.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/zarzur/flutter-desktop-bricks/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/user/project/merge_requests/auto_merge/)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

