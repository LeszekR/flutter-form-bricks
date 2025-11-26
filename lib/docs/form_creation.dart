/// # Form Creation and Initialization Flow
///
/// ## 1. FormSchema
/// - Defines each field’s:
///   - `keyString` (unique field identifier)
///   - `initialInput`
///   - field input and value types (`I`, `V`)
///   - optional `FormatterValidatorChain`
/// - Also defines `focusedKeyString`, specifying which field
///   should gain focus when the form first appears.
///
/// ## 2. FormManager Setup
/// - The form widget creates a `FormManager`, providing it with a `FormSchema`
///   and a `FormData`.
/// - If `FormData` is meant to persist, it should be stored higher in the widget tree.
/// - Upon initialization, `FormManager` populates its
///   `FormData.fieldDataMap`:
///   - From **FormSchema** if `FormData` is empty.
///   - From **FormData** itself if already populated.
///
/// ## 3. Validation Initialization
/// - After population, `FormManager` validates all field values.
/// - Validation results (error messages) are stored in
///   each `FormFieldData.fieldContent.error`.
///
/// ## 4. FormBrick Creation
/// - The main `FormBrick` receives the initialized `FormManager`.
/// - It builds all form fields as declared in `FormSchema`.
///
/// ## 5. FormField Registration
/// Each `FormFieldBrick`:
/// - Receives the same `FormManager`.
/// - Registers itself in it.
/// - Throws if:
///   - Its `keyString` does not exist in `FormSchema`.
///   - Its input or value type differs from the type declared in `FormSchema`.
/// - Retrieves its initial value from `FormManager`.
/// - Obtains its `onFieldChanged` callback from `FormManager`, which:
///   - Validates the new field value.
///   - Updates both the input and validation result in
///     the corresponding `FormFieldData`.
///   - Triggers revalidation and save logic as needed.
///
/// ## Summary
/// This design enforces:
/// - A **single source of truth** for field configuration and state.
/// - Automatic validation and synchronization.
/// - Strong type and key safety at field registration time.
