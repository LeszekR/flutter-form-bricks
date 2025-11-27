// lib/src/annotations/auto_form_schema_generator.dart
library flutter_form_bricks.generator;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'auto_form_schema.dart';

class AutoFormSchemaGenerator extends GeneratorForAnnotation<AutoFormSchema> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@AutoFormSchema can only be applied to classes.',
        element: element,
      );
    }

    final widgetClass = element;
    _ensureExtends(widgetClass.thisType, 'FormBrick', widgetClass);

    final formName = widgetClass.name;
    final schemaClassName = annotation.peek('name')?.stringValue ?? '${formName}Schema';

    // 1) Load ALL units in the same library as the annotated widget.
    final lib = widgetClass.library;
    final stateDeclarations = <ClassDeclaration>[];
    for (final unitElement in lib.units) {
      // unitElement is a CompilationUnitElement (defining unit + all parts)
      for (final classElement in unitElement.classes) {
        final t = classElement.thisType;
        if (_isSubtypeOf(t, 'FormStateBrick')) {
          // 2) Get a *resolved* AST node for this class.
          final node = await buildStep.resolver.astNodeFor(classElement, resolve: true);
          if (node is ClassDeclaration) {
            stateDeclarations.add(node);
          }
        }
      }
    }

    if (stateDeclarations.isEmpty) {
      throw InvalidGenerationSourceError(
        'No State class extending FormStateBrick found in the same library as ${widgetClass.name}.',
        element: widgetClass,
      );
    }

    // 3) Scan each State class: both buildBody and build.
    final allItems = <_FieldInfo>[];
    for (final stateDeclaration in stateDeclarations) {
      final methodIndex = <String, MethodDeclaration>{
        for (final method in stateDeclaration.members.whereType<MethodDeclaration>()) method.name.lexeme: method,
      };
      final collector = _FieldCollector(
        methodIndex: methodIndex,
        targetMethods: const {'buildBody', 'build'},
      );
      stateDeclaration.accept(collector);
      allItems.addAll(collector.items);
    }

    // 4) Emit schema.
    final descriptorEntries = allItems.map((it) {
      final genericI = it.inputGenericSource ?? 'Object';
      final genericV = it.valueGenericSource ?? 'Object';

      final keyCode = it.keyStringSource ?? _quote(it.keyStringLiteral ?? it.unknownKeyFallback);

      final initCode = it.initialInputSource ?? 'null';
      final chainCode = it.chainSource ?? 'null';

      return 'FormFieldDescriptor<$genericI, $genericV>('
          'keyString: $keyCode, initialInput: $initCode, formatterValidatorChain: $chainCode)';
    }).join(',\n    ');

    return '''
// // GENERATED CODE - DO NOT MODIFY BY HAND
/// Auto-generated schema for $formName by @AutoFormSchema.

class $schemaClassName extends FormSchema {
  $schemaClassName()
      : super(<FormFieldDescriptor>[
    $descriptorEntries
  ]);
}
''';
  }

  // ---------- Utils ----------

  void _ensureExtends(InterfaceType type, String name, Element on) {
    final ok = type.element.name == name || type.allSupertypes.any((s) => s.element.name == name);
    if (!ok) {
      throw InvalidGenerationSourceError(
        '@AutoFormSchema must annotate a class extending $name.',
        element: on,
      );
    }
  }

  static bool _isSubtypeOf(InterfaceType interfaceType, String base) {
    if (interfaceType.element.name == base) return true;
    for (final s in interfaceType.allSupertypes) {
      if (s.element.name == base) return true;
    }
    return false;
  }

  String _quote(String s) {
    if (s.startsWith("'") || s.startsWith('"')) return s;
    final escaped = s.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
    return "'$escaped'";
  }
}

// ---------- Scanner (inheritance-only; scans build & buildBody; enters all closures) ----------

class _FieldCollector extends RecursiveAstVisitor<void> {
  final Map<String, MethodDeclaration> methodIndex;
  final Set<String> targetMethods;

  final Set<String> _inlined = {}; // avoid infinite recursion
  final items = <_FieldInfo>[];

  _FieldCollector({
    required this.methodIndex,
    required this.targetMethods,
  });

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // Visit only target method bodies.
    for (final m in node.members.whereType<MethodDeclaration>()) {
      if (targetMethods.contains(m.name.lexeme)) {
        m.body.accept(this);
      }
    }
    // No super: skip other methods.
  }

  // Inline same-class helpers by exact name match, once.
  @override
  void visitMethodInvocation(MethodInvocation node) {
    final name = node.methodName.name;
    final helper = methodIndex[name];
    if (helper != null && _inlined.add(name)) {
      helper.body.accept(this);
    }
    super.visitMethodInvocation(node);
  }

  // Enter ALL closures (covers builder: and any lambda bodies).
  @override
  void visitFunctionExpression(FunctionExpression node) {
    node.body.accept(this);
    super.visitFunctionExpression(node);
  }

  // Detect FormFieldBrick descendants only.
  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final type = _resolveConstructedInterfaceType(node);
    if (type != null && _isFormFieldBrick(type)) {
      final info = _FieldInfo.fromCreation(node);
      final i = _extractIFromFormFieldBrick(type);
      if (i != null) info.inputGenericSource = i;
      info.valueGenericSource ??= 'Object';
      items.add(info);
    }
    super.visitInstanceCreationExpression(node);
  }

  // ----- helpers -----

  InterfaceType? _resolveConstructedInterfaceType(InstanceCreationExpression node) {
    // 1) constructor → enclosing class
    final constructor = node.constructorName.staticElement;
    final enclosing = constructor?.enclosingElement;
    if (enclosing is ClassElement) return enclosing.thisType;

    // 2) expression staticType
    final staticType = node.staticType;
    if (staticType is InterfaceType) return staticType;

    // 3) NamedType resolved type (compat across analyzer versions)
    final tn = node.constructorName.type;
    final resolved = tn.type;
    if (resolved is InterfaceType) return resolved;
    final dynamic maybeElement = (tn as dynamic).element;
    if (maybeElement is ClassElement) return maybeElement.thisType;
    return null;
  }

  bool _isFormFieldBrick(InterfaceType t) => _isSubtypeOf(t, 'FormFieldBrick');

  static bool _isSubtypeOf(InterfaceType t, String base) {
    if (t.element.name == base) return true;
    for (final superType in t.allSupertypes) {
      if (superType.element.name == base) return true;
    }
    return false;
  }

  String? _extractIFromFormFieldBrick(InterfaceType t) {
    for (final superType in [t, ...t.allSupertypes]) {
      if (superType.element.name == 'FormFieldBrick') {
        final args = superType.typeArguments;
        if (args.isNotEmpty) {
          final argFirst = args.first;
          if (argFirst is InterfaceType) {
            return argFirst.getDisplayString(
              withNullability: argFirst.nullabilitySuffix != NullabilitySuffix.none,
            );
          }
          if (argFirst is TypeParameterType) {
            return argFirst.getDisplayString(withNullability: true);
          }
        }
      }
    }
    return null;
  }
}

// ---------- DTO ----------

class _FieldInfo {
  _FieldInfo();

  String? inputGenericSource;
  String? valueGenericSource;

  String? keyStringSource;
  String? initialInputSource;
  String? chainSource;

  String? keyStringLiteral;

  String get unknownKeyFallback => '<unknown_key>';

  static _FieldInfo fromCreation(InstanceCreationExpression node) {
    final info = _FieldInfo();
    for (final arg in node.argumentList.arguments) {
      if (arg is! NamedExpression) continue;
      final name = arg.name.label.name;
      final expression = arg.expression;

      // Only for descriptor payload; not used to identify the field.
      if (name == 'keyString') {
        info.keyStringSource = expression.toString();
        if (expression is StringLiteral) info.keyStringLiteral = expression.stringValue;
      } else if (name == 'initialInput') {
        info.initialInputSource = expression.toString();
      } else if (name == 'formatterValidatorChain') {
        info.chainSource = expression.toString();
      }
    }
    return info;
  }
}
