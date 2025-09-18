import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Base marker for key generators. Forces the use of uniqueness-checking implementations of `ValueKey`, `ObjectKey`.
/// In order to prevent circumventing this mechanism also uniqueness-guaranteed `Key` implementations: `GlobalKey`,
/// `UniqueKey` have to be obtained only as implementations of this marker-class.
abstract class KeyGen {}

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

  @visibleForTesting
  static void reset() {
    _keyRegistry.clear();
  }}

/// Replacement for ValueKey<T> with debug-only global uniqueness checks.
class ValueKeyGen<T> extends ValueKey<T> implements KeyGen {
  ValueKeyGen(T value) : super(value) {
    KeyRegistry.assertUnique(value, 'ValueKeyGen');
  }
}

/// Replacement for ObjectKey with debug-only global uniqueness checks.
class ObjectKeyGen extends ObjectKey implements KeyGen {
  ObjectKeyGen(Object value) : super(value) {
    KeyRegistry.assertUnique(value, 'ObjectKeyGen');
  }
}

/// Replacement for UniqueKey. Always unique by definition,
/// so no need for extra checks.
class UniqueKeyGen extends UniqueKey implements KeyGen {
  UniqueKeyGen() : super();
}

/// Wrapper for GlobalKey. Flutter already enforces uniqueness globally,
/// so this class mainly exists for consistency and potential debug labels.
class GlobalKeyGen<T extends State<StatefulWidget>> extends LabeledGlobalKey<T> implements KeyGen {
  GlobalKeyGen([String? debugLabel]) : super(debugLabel) {
    if (debugLabel != null) {
      KeyRegistry.assertUnique(debugLabel, 'GlobalKeyGen');
    }
  }
}
