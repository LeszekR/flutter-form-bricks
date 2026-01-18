# Validation Flow Overview

## 1. Ownership

`FormManager` owns all `FormatterValidatorChain` (FVC) instances. Each field’s validator chain is
defined in `FormSchema`.

`FormatterValidatorChain`s are not owned by `FormFieldBrick` because the field is an ephemeral
widget, while the `FormManager` must be able to validate the entire form independently of whether a
specific field is currently built.

This design is essential for supporting `TabbedForm` validation, where some fields may be off-screen
and unbuilt, as well as for improving performance by eliminating one extra frame. In widget-owned
validation patterns, fields must first build before validation can occur in the next frame. By
centralizing validation in the `FormManager`, validation can be performed before widgets are built.

## 2. Validation trigger

A `FormFieldBrick` does **not** hold or access an FVC directly. Instead, it calls:

```dart
formManager.validateField(keyString);
```

## 3. Validation execution

Inside `FormManager`:

- The appropriate FVC is retrieved from `FormSchema`.
- Validation runs for the specified field value.
- The result (`ValidationResult`) is recorded in `FormFieldData`.
- A `ChangeNotifier` update triggers the global validation display area.

## 4. Field reaction

The field receives the `ValidationResult` returned by `validateField()`:

- Updates its color or visual state.
- Optionally displays the error text inline (via `InputDecoration.errorText`).

## Summary

Validation ownership and propagation are centralized in `FormManager`. Fields remain thin UI layers
that display validation feedback, while business logic and schema consistency are enforced by the
manager.

## Structure and ownership of formatting and validation logic

### `FormatterValidator`

- Runs sequence of format-validation action like **required**, **digits-only**, **date** etc.
- Owns any field-specific parameters used in the formatting or validation, e.g. `DateTimeLimits` for
  validating `DateField` or `TimeField` and other date-time related fields.

### `FormatterValidatorChain`

- `FormatterValidatorChainEarlyStop` stops at the first encountered error.
- `FormatterValidatorChainFullRun` runs all validators to collect a complete list of errors.
- The chain applies each `FormatterValidator` sequentially to perform formatting and validation.

### Class structure

- A `FormatterValidatorChain` holds a `List<FormatterValidator>`s, allowing any number of validators
  to be chained.
- A `BrickField` that requires formatting and/or validation uses a `FormatterValidatorChain`, but
  does **not** own it.
- A `FormManager` **owns** a `Map` of `FormatterValidatorChain`s, where each chain is associated
  with a `BrickField` by its `keyString` as the map key.

