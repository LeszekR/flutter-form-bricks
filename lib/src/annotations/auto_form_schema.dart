// lib/src/annotations/auto_form_schema.dart
library flutter_form_bricks.annotations;

/// Marks a FormBrick widget for which a `<FormName>Schema` will be generated.
///
/// Usage:
/// ```dart
/// @AutoFormSchema()
/// class ExampleForm extends FormBrick { ... }
/// ```
/// The generator looks into the associated `State` class (`createState()`), then
/// recursively traverses `build()` and helper methods (e.g., `buildBody(...)`)
/// to find widget constructions whose root supertype is `FormFieldBrick`.
class AutoFormSchema {
  /// When true, method calls inside `build()`/`buildBody()` are recursively analyzed.
  final bool deepScan;

  /// Optional override for the output schema class name. If null, `<FormName>Schema` is used.
  final String? name;

  const AutoFormSchema({this.deepScan = true, this.name});
}
