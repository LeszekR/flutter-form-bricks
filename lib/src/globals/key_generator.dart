// import 'package:flutter/widgets.dart';
//
// /// ## Key Uniqueness Guard
// ///
// /// This module defines a custom key-generation mechanism for the project.
// /// Its purpose is to eliminate widget state bugs caused by
// /// duplicate keys that Flutter itself does not always detect.
// ///
// /// ### Problem
// /// Flutter enforces `LocalKey` uniqueness **only among siblings under the
// /// same parent**. This means that two widgets in the same form can both
// /// accidentally use `ValueKey("email")` or `Key("email")`.
// /// The framework will not complain, but during rebuilds it may reuse
// /// the wrong state object, leading to unpredictable behavior.
// ///
// /// ### Solution
// /// - All potentially duplicable keys are created through `KeyGenerator`
// ///   implementations:
// ///   - `ValueKeyGen`
// ///   - `PageStorageKeyGen`
// ///   - `StringKeyGen`
// /// - Each generator calls `KeyRegistry.assertUnique()` during **debug mode**.
// /// - If a duplicate is found, a `FlutterError` is thrown immediately.
// /// - In **release builds**, all checks are removed by the compiler
// ///   (tree shaking), so there is no runtime overhead.
// ///
// /// ### Testing
// /// - `KeyRegistry.reset()` clears the registry between test cases.
// /// - It must **never** be used in production code.
// ///
// /// ### Future direction
// /// The long-term goal is to enforce that **all duplicable keys** in the
// /// application are created exclusively via `KeyGenerator` implementations.
// /// This guarantees that uniqueness validation covers all relevant key types.
// abstract class KeyGenerator {}
//
// /// A replacement for `ValueKey` with global uniqueness checks in debug mode.
// ///
// /// Ensures that no two `ValueKeyGen` instances across the entire widget tree
// /// share the same value, preventing subtle state-reuse bugs.
// class ValueKeyGen<T> extends ValueKey<T> implements KeyGenerator {
//   ValueKeyGen(T value) : super(value) {
//     KeyRegistry.assertUnique(value, 'ValueKeyGen');
//   }
// }
//
// /// A replacement for `PageStorageKey` with global uniqueness checks in debug mode.
// ///
// /// Ensures that no two `PageStorageKeyGen` instances share the same storage key
// /// value across the entire app. Useful for preserving scroll position safely
// /// across multiple page views or tab navigations without collision.
// class PageStorageKeyGen<T> extends PageStorageKey<T> implements KeyGenerator {
//   PageStorageKeyGen(T value) : super(value) {
//     KeyRegistry.assertUnique(value, 'PageStorageKeyGen');
//   }
// }
//
// /// A replacement for `Key(String)` or `const Key('string')` with debug checks.
// ///
// /// Provides global uniqueness validation for string-based keys. This helps
// /// catch accidental reuse of simple string keys that Flutter would otherwise
// /// treat as separate `LocalKey`s only under the same parent.
// ///
// /// ### Example
// /// ```dart
// /// // Throws in debug mode if any other widget used "submit-button" as key
// /// ElevatedButton(key: StringKeyGen('submit-button'), onPressed: () {});
// /// ```
// class StringKeyGen extends Key implements KeyGenerator {
//   StringKeyGen(String value) : super(value) {
//     KeyRegistry.assertUnique(value, 'StringKeyGen');
//   }
// }
//
// /// Central registry for tracking key uniqueness during development.
// ///
// /// Stores every key value constructed through `KeyGenerator` implementations
// /// and validates that each new key is globally unique across the widget tree.
// /// Only active in **debug mode**; all logic is stripped out in release builds.
// sealed class KeyRegistry {
//   static final Set<Object?> _keyRegistry = <Object?>{};
//
//   static void assertUnique(Object? value, String source) {
//     assert(() {
//       if (_keyRegistry.contains(value)) {
//         throw FlutterError('Duplicate $source("${value.toString()}") found');
//       }
//       _keyRegistry.add(value);
//       return true;
//     }());
//   }
//
//   /// Clears the registry (for test isolation only).
//   @visibleForTesting
//   static void reset() {
//     _keyRegistry.clear();
//   }
// }
