# FormSchema generation

You can define a `FormSchema` manually or delegate it to the `@AutoFormSchema`
annotation provided by this library.

The annotation scans your form widget (in `build()` and `buildBody()`), finds
all widgets that inherit from `FormFieldBrick`, and generates the corresponding
`FormSchema` as a `part` file of your form’s library. This removes repetitive
and error-prone boilerplate.

## Visibility rules (important)

Because the schema is emitted into a **part** file, only identifiers visible
to the parent library can be referenced by the generator.

- **`keyString` constants**
  Use `String` constants and keep them **top-level** or **static**.
  The `keyString` must be identical in both the `FormFieldBrick` and the
  corresponding `FormFieldDescriptor`. If defined locally inside `build()` or
  `buildBody()`, they are not visible to the part file and will not resolve.

- **Objects used by `FormFieldBrick`s (e.g., formatter/validator chains)**
  If you want these to appear in the generated schema, define them as
  **top-level const** or **static const**. Values created as local variables
  in `build()`/`buildBody()` are not visible to the part file and will be
  omitted (the generator will emit `null` for those parameters).

- **Multiple files**
  If your form is split across files, ensure they belong to the **same
  library** using `part`/`part of`, so identifiers remain visible to the
  generated part.

## Usage

1. Annotate your `FormBrick` class with `@AutoFormSchema()`.
2. Add `part '<form_name>_schema.g.dart';` to your form file.
3. Run `dart run build_runner build` to generate `<form_name>_schema.g.dart`
   containing `<FormName>Schema`.
