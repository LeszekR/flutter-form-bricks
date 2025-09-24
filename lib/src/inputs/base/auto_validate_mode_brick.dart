/// ## AutoValidateModeBrick
///
/// Defines when a [FormFieldBrick] should automatically validate its value.
///
/// This replaces Flutter’s built-in [AutovalidateMode]. The main difference:
/// - Flutter’s `always` mode is redundant here because [FormFieldBrick]
///   *always performs an initial validation before the first build*.
///   This replaces Flutter’s post-build validation. It also allows
///   `TabbedFormBrick`, where fields are initialized with `initialValue`s,
///   to validate them without creating states for invisible tabs. As a result,
///   errors in initial values (or their absence) can immediately mark the tab
///   header with an error state, even if the tab’s content hasn’t been built yet.
/// - As a result, only three modes are needed to fully cover all use cases.
///
/// ### Modes
///
/// - [onCreateOrSave]
///   - Validates **once before the first build** (so the form knows its initial
///     validity).
///   - Does **not** revalidate on user edits during the form’s lifetime.
///   - Validates again **only when the form is saved**.
///   - Equivalent to Flutter’s [AutovalidateMode.disabled], but replaces
///     Flutter’s post-build validation with the pre-build validation
///     described above.
///
/// - [onChange]
///   - Validates **before the first build**.
///   - Validates again **every time the field’s value changes**.
///   - Typical choice for instant feedback as the user types.
///   - Equivalent to Flutter’s [AutovalidateMode.onUserInteraction], but with
///     the added pre-build validation.
///
/// - [onEditingComplete]
///   - Validates **before the first build**.
///   - Validates again **when editing completes** (focus loss or explicit
///     `onEditingComplete` trigger).
///   - In line with the library’s philosophy of instant error display, this
///     should be used only in cases where a [FormatterValidatorChain] can
///     complete its work *only once the user has finished a multi-character
///     input* — for example, date/time inputs entered in shortened form.
///
/// ### Notes
/// - There is no `always` mode: because validation is always performed once
///   before the first build, [onChange] and [onEditingComplete] already cover
///   all remaining use cases.
/// - All fields are validated again when the form is saved, so validation
///   results always include the influence of any external state at save time.
/// - This library **does not validate fields automatically on every focus gain**.
///   While such a mechanism could catch rare cases where external state changes
///   affect validity, it would waste energy by revalidating fields unnecessarily.
///   This design intentionally favors slightly worse UX in rare cases over
///   continuous unnecessary validation.
enum AutoValidateModeBrick {
  /// Validate once before the first build and again only when the form is saved.
  onCreateOrSave,

  /// Validate before the first build and again every time the field’s value changes.
  onChange,

  /// Validate before the first build and again when editing completes (focus lost).
  onEditingComplete,
}
