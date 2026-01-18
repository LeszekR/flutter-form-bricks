# Creating a dedicated field with default formatters/validators

You can introduce your own specialized form field by defining a custom `FormatterValidator` and
exposing its default list via `FormatterValidatorDefaults`. Your field then uses those defaults
automatically (while still allowing the app to add extra validators).

## TL;DR steps

1. Create a validator for your value type:
    - Extend `FormatterValidator<I, V>` with explicit generics (e.g., `String` input → `PhoneNumber`
      value).
2. Register defaults in `FormatterValidatorDefaults`:
    - Add a non-static method returning `List<FormatterValidator<I, V>>`.
    - This is mockable in tests via `setFormatterValidatorDefaultsForTest`.
3. Use defaults in your field:
    - In your dedicated `*Field` widget’s constructor call
      `super(defaultFormatterValidatorListMaker: formatterValidatorDefaults.yourMethod)`.
    - Apps can still pass `addFormatterValidatorListMaker` to append extra validators.

## Example

### 1) Custom validator

```dart
final class PhoneNumber {
  final String e164;

  PhoneNumber(this.e164);
}

final class PhoneNumberFormatterValidator extends FormatterValidator<String, PhoneNumber> {
  @override
  FieldContent<String, PhoneNumber> run(BricksLocalizations l10n,
      String keyString,
      FieldContent<String, PhoneNumber> fc,) {
    final raw = fc.input ?? '';
    final normalized = raw.replaceAll(RegExp(r'\s+|-'), '');
    final isValid = RegExp(r'^\+?[1-9]\d{7,14}$').hasMatch(normalized);

    if (!isValid) {
      return fc.copyWith(
        formattedInput: normalized,
        value: null,
        isValid: false,
        error: l10n.invalidPhoneNumber, // your localization key
      );
    }
    return fc.copyWith(
      formattedInput: normalized,
      value: PhoneNumber(normalized),
      isValid: true,
      error: null,
    );
  }
}
```

///
/// 2) Register defaults
///

```dart
// lib/src/form_fields/base/formatter_validator_base/formatter_validator_defaults.dart

final class FormatterValidatorDefaults {
  // Existing
  List<FormatterValidator<String, Date>> date() =>
      [
        DateFormatterValidator(DateTimeUtils(), CurrentDate()),
      ];

  // New: phone
  List<FormatterValidator<String, PhoneNumber>> phone() =>
      [
        PhoneNumberFormatterValidator(),
      ];
}

// Tests can swap:
@visibleForTesting
void setFormatterValidatorDefaultsForTest(FormatterValidatorDefaults replacement) {
  formatterValidatorDefaults = replacement;
}
 ```

### 3) Dedicated field using defaults

```dart
final class PhoneField extends TextFieldBrick<PhoneNumber> {
  PhoneField({
    super.key,
    required super.keyString,
    required super.formManager,
    StatesColorMaker? colorMaker,
    super.initialInput,
    super.isFocusedOnStart = false,
    super.isRequired = false,
// App can still add extras:
    super.addFormatterValidatorListMaker,
// plus any TextField props…
  }) : super(defaultFormatterValidatorListMaker: formatterValidatorDefaults
      .phone); // Use your defaults here

  @override
  State<StatefulWidget> createState() => _PhoneFieldState();
}

final class _PhoneFieldState extends TextFieldStateBrick<PhoneNumber> {}
```

## Notes

- Why non-static defaults? They’re easy to mock in tests (`setFormatterValidatorDefaultsForTest`).
- Order of validators: The chain builder merges `defaultFormatterValidatorListMaker` and
  `addFormatterValidatorListMaker` (configurable order). By default, defaults run first, then
  additions.
- Chain policy: By default the chain is FullRun (runs all steps). You can switch to EarlyStop if
  desired (stop after first valid result).
- Schema generator: The generator records the two makers on the descriptor. At runtime,
  `FormManager` builds the chain from the descriptor - your defaults are picked up automatically.

