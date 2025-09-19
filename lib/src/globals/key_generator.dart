import 'package:flutter/widgets.dart';

/// ## Key Uniqueness Guard
///
/// This module defines a custom key-generation mechanism for the project.
/// Its purpose is to eliminate widget state bugs caused by
/// duplicate keys that Flutter itself does not always detect.
///
/// ### Problem
/// Flutter enforces `LocalKey` uniqueness **only among siblings under the
/// same parent**. This means that two widgets in the same form can both
/// accidentally use `ValueKey("email")`. The framework will not complain,
/// but during rebuilds it may reuse the wrong state object, leading to
/// unpredictable behavior.
///
/// ### Solution
/// - All keys are created through `KeyGenerator` implementations:
///   - [ValueKeyGen]
///   - [ObjectKeyGen]
///   - [UniqueKeyGen]
///   - [GlobalKeyGen]
/// - Each generator calls [KeyRegistry.assertUnique] during **debug mode**.
/// - If a duplicate is found, a [FlutterError] is thrown immediately.
/// - In **release builds**, all checks are removed by the compiler
///   (tree shaking), so there is no runtime overhead.
///
/// ### Testing
/// - [KeyRegistry.reset] clears the registry between test cases.
/// - It must **never** be used in production code.
///
/// ### Future direction
/// The long-term goal is to enforce that **all keys** in the application
/// are created exclusively via `KeyGenerator` implementations. This guarantees
/// that uniqueness validation covers every key type uniformly.
abstract class KeyGenerator {}

/// Central registry for tracking key uniqueness during development.
///
/// - Stores every key value constructed through `KeyGenerator` implementations.
/// - Validates that each new key is globally unique across the widget tree.
/// - Only active in **debug mode**; all logic is stripped out in release builds.
///
/// ### Methods
/// - [assertUnique] — invoked automatically by each `KeyGenerator` subclass to check
///   whether the given value has already been registered.
/// - [reset] — clears the registry. Intended **only** for use in tests so that
///   each test case starts with a clean slate.
///
/// ### Notes
/// - This guard goes beyond Flutter’s built-in behavior: Flutter enforces
///   `LocalKey` uniqueness only among siblings, while [KeyRegistry] enforces
///   uniqueness globally across the entire app.
/// - Attempting to register a duplicate key in debug mode will throw a
///   [FlutterError].
sealed class KeyRegistry {
  static final Set<Object?> _keyRegistry = <Object?>{};

  static void assertUnique(Object? value, String source) {
    assert(() {
      if (_keyRegistry.contains(value)) {
        throw FlutterError('Duplicate $source("$value") found');
      }
      _keyRegistry.add(value);
      return true;
    }());
  }

  /// Clears the registry.
  ///
  /// Intended **only for use in tests**, to ensure that each test starts
  /// with a clean slate. Do not call this in production code.
  @visibleForTesting
  static void reset() {
    _keyRegistry.clear();
  }
}

/// A replacement for [ValueKey] with global uniqueness checks in debug mode.
///
/// Ensures that no two `ValueKeyGen` instances across the entire widget tree
/// share the same value, preventing subtle state-reuse bugs.
///
/// ### Example
/// ```dart
/// // Throws in debug mode if another field already uses "email"
/// TextField(key: ValueKeyGen('email')),
/// ```
///
/// In release builds, uniqueness checks are removed, and this class behaves
/// exactly like a normal [ValueKey].
class ValueKeyGen<T> extends ValueKey<T> implements KeyGenerator {
  ValueKeyGen(T value) : super(value) {
    KeyRegistry.assertUnique(value, 'ValueKeyGen');
  }
}

/// A replacement for [ObjectKey] with global uniqueness checks in debug mode.
///
/// Requires a non-null object. Two `ObjectKeyGen` instances referring to the
/// same object (or objects that compare equal with `==`) will be considered
/// duplicates and rejected during development.
///
/// ### Example
/// ```dart
/// final user = User(id: 42);
/// // Ensures no other ObjectKeyGen has been created for the same user object
/// ListTile(key: ObjectKeyGen(user), title: Text(user.name));
/// ```
class ObjectKeyGen extends ObjectKey implements KeyGenerator {
  ObjectKeyGen(Object value) : super(value) {
    KeyRegistry.assertUnique(value, 'ObjectKeyGen');
  }
}

/// A replacement for [UniqueKey].
///
/// Always produces a unique identity that never collides with any other key.
/// No global uniqueness checks are necessary.
///
/// ### Example
/// ```dart
/// ElevatedButton(
///   key: UniqueKeyGen(),
///   onPressed: () {},
///   child: const Text('Click'),
/// )
/// ```
class UniqueKeyGen extends UniqueKey implements KeyGenerator {
  UniqueKeyGen() : super();
}

/// A wrapper for [LabeledGlobalKey] with optional debug-label uniqueness checks.
///
/// - Flutter already guarantees that [GlobalKey] instances are unique across
///   the entire app.
/// - This subclass adds an **optional** safeguard: if a [debugLabel] is provided,
///   it must also be unique across the app in debug mode.
///
/// ### Example
/// ```dart
/// // Two GlobalKeyGen instances with the same label will throw in debug mode
/// final formKey = GlobalKeyGen<FormState>('login-form');
///
/// Form(key: formKey, child: ...);
/// ```
///
/// If no label is provided, the key behaves like a normal [GlobalKey].
class GlobalKeyGen<T extends State<StatefulWidget>> extends LabeledGlobalKey<T> implements KeyGenerator {
  GlobalKeyGen([String? debugLabel]) : super(debugLabel) {
    if (debugLabel != null) {
      KeyRegistry.assertUnique(debugLabel, 'GlobalKeyGen');
    }
  }
}
