/// # Validation Flow Overview
///
/// ## 1. Ownership
/// `FormManager` owns all `FormatterValidatorChain` (FVC) instances.
/// Each field’s validator chain is defined in `FormSchema`.
///
/// ## 2. Validation Trigger
/// A `FormFieldBrick` does **not** hold or access an FVC directly.
/// Instead, it calls:
/// ```dart
/// formManager.validateField(keyString);
/// ```
///
/// ## 3. Validation Execution
/// Inside `FormManager`:
/// - The appropriate FVC is retrieved from `FormSchema`.
/// - Validation runs for the specified field value.
/// - The result (`ValidationResult`) is recorded in `FormFieldData`.
/// - A `ChangeNotifier` update triggers the global validation display area.
///
/// ## 4. Field Reaction
/// The field receives the `ValidationResult` returned by `validateField()`:
/// - Updates its color or visual state.
/// - Optionally displays the error text inline (via `InputDecoration.errorText`).
///
/// ## Summary
/// Validation ownership and propagation are centralized in `FormManager`.
/// Fields remain thin UI layers that display validation feedback,
/// while business logic and schema consistency are enforced by the manager.
