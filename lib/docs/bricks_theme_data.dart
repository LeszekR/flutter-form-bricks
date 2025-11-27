/// # BricksThemeData — Theme abstraction
///
/// **Goal:** Provide a stable, explicit facade over Flutter’s evolving
/// theming APIs by mirroring the **exact** types that `ThemeData` expects
/// on the current SDK channel.
///
/// > Many `ThemeData` properties on newer Flutter channels return `*ThemeData`
/// (e.g. `AppBarThemeData`) instead of the older `*Theme` (e.g. `AppBarTheme`).
/// This library exposes getters that match those types 1:1 to avoid casts and inference pitfalls.
///
/// ---
///
/// ## What you get
///
/// `BricksThemeData` returns the same types as `ThemeData`:
///
/// - `…ThemeData` getters (e.g. `appBarThemeData`, `dialogThemeData`, `tabBarThemeData`,
/// `inputDecorationThemeData`) return the **concrete `*ThemeData`** types.
/// - Plain types (e.g. `TextTheme`, `ColorScheme`, `Color`) are exposed **as-is**.
/// - The `themeData` composer wires all getters into a `ThemeData` without casts.
///
/// ```dart
/// final theme = myBricksTheme.themeData; /// feed into MaterialApp(theme: theme)
class _DocsDummy{}