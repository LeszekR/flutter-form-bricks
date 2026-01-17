// lib/flutter_form_bricks.generator/auto_form_schema_generator.dart

library flutter_form_bricks.generator;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../form_fields/text/text_input_base/formatter_validator_defaults.dart';
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

    final lib = widgetClass.library;
    final classDeclarationList = <ClassDeclaration>[];
    for (final unitElement in lib.units) {
      for (final classElement in unitElement.classes) {
        final t = classElement.thisType;
        if (_isSubtypeOf(t, 'FormStateBrick')) {
          final node = await buildStep.resolver.astNodeFor(classElement, resolve: true);
          if (node is ClassDeclaration) {
            classDeclarationList.add(node);
          }
        }
      }
    }

    if (classDeclarationList.isEmpty) {
      throw InvalidGenerationSourceError(
        'No State class extending FormStateBrick found in the same library as ${widgetClass.name}.',
        element: widgetClass,
      );
    }

    final allItems = <_FieldInfo>[];
    for (final classDeclaration in classDeclarationList) {
      final methodIndexMap = <String, MethodDeclaration>{
        for (final method in classDeclaration.members.whereType<MethodDeclaration>())
          method.name.lexeme: method,
      };
      final collector = _FieldCollector(
        methodIndexMap: methodIndexMap,
        targetMethodsSet: const {'buildBody', 'build'},
      );
      classDeclaration.accept(collector);
      allItems.addAll(collector.items);
    }

    final int focusedCount = allItems.where((fieldInfo) {
      final String? raw = fieldInfo.isFocusedOnStartSource?.trim();
      final bool? literal = fieldInfo.isFocusedOnStartLiteralBool;
      return literal == true || raw == 'true';
    }).length;

    if (focusedCount != 1) {
      throw InvalidGenerationSourceError(
        'Exactly one field must have isFocusedOnStart: true in ${widgetClass.name}. Found $focusedCount.',
        element: element,
      );
    }

    final descriptorEntries = allItems.map((fieldInfo) {
      final genericI = fieldInfo.inputGenericSource ?? 'Object';
      final genericV = fieldInfo.valueGenericSource ?? 'Object';

      final keyCode = fieldInfo.keyStringSource ??
          _quote(fieldInfo.keyStringLiteral ?? fieldInfo.unknownKeyFallback);

      final initCode = fieldInfo.initialInputSource;
      final focusedCode = fieldInfo.isFocusedOnStartSource;

      final requiredCode = fieldInfo.isRequiredSource;
      final fullRunCode = fieldInfo.validatorsFullRunSource;
      final defaultFirstCode = fieldInfo.runDefaultValidatorsFirstSource;

      final defaultMakerFromFieldClass = defaultFormValidListMakerForFieldClassName(fieldInfo.fieldClassName);
      final defaultFormValid = fieldInfo.defaultFormatterValidatorListMaker ?? defaultMakerFromFieldClass;
      final addFormValid = fieldInfo.addFormatterValidatorListMaker;

      return 'FormFieldDescriptor<$genericI, $genericV>('
          'keyString: $keyCode,\n'
          '${_makeParamIfNotNull('initialInput', initCode)}'
          '${_makeParamIfNotNull('isFocusedOnStart', focusedCode)}'
          '${_makeParamIfNotNull('isRequired', requiredCode)}'
          '${_makeParamIfNotNull('validatorsFullRun', fullRunCode)}'
          '${_makeParamIfNotNull('runDefaultValidatorsFirst', defaultFirstCode)}'
          '${_makeParamIfNotNull('defaultFormatterValidatorListMaker', defaultFormValid)}'
          '${_makeParamIfNotNull('addFormatterValidatorListMaker', addFormValid)}'
          ')';
    }).join(',\n    ');

    return '''
// // GENERATED CODE - DO NOT MODIFY BY HAND
/// Auto-generated schema for $formName by @AutoFormSchema.

class $schemaClassName extends FormSchema {
  $schemaClassName()
      : super(<FormFieldDescriptor>[
    $descriptorEntries,
  ]);
}
''';
  }

  String _makeParamIfNotNull(String name, String? valueSource) {
    if (valueSource == null) return '';
    final v = valueSource.trim();
    if (v == 'null') return '';
    return '$name: $v,\n';
  }

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

// ---------- Scanner ----------

class _FieldCollector extends RecursiveAstVisitor<void> {
  final Map<String, MethodDeclaration> methodIndexMap;
  final Set<String> targetMethodsSet;

  final Set<String> _inlined = {};
  final items = <_FieldInfo>[];

  _FieldCollector({
    required this.methodIndexMap,
    required this.targetMethodsSet,
  });

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    for (final m in node.members.whereType<MethodDeclaration>()) {
      if (targetMethodsSet.contains(m.name.lexeme)) {
        m.body.accept(this);
      }
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final name = node.methodName.name;
    final helper = methodIndexMap[name];
    if (helper != null && _inlined.add(name)) {
      helper.body.accept(this);
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    node.body.accept(this);
    super.visitFunctionExpression(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final type = _resolveConstructedInterfaceType(node);
    if (type != null && _isFormFieldBrick(type)) {
      final info = _FieldInfo.fromCreation(node);
      info.fieldClassName = type.element.name; // <-- NEW: capture actual widget class name (e.g. DateField)

      final iv = _extractIVFromFormFieldBrick(type);
      if (iv.$1 != null) info.inputGenericSource = iv.$1;
      if (iv.$2 != null) info.valueGenericSource = iv.$2;
      items.add(info);
    }
    super.visitInstanceCreationExpression(node);
  }

  InterfaceType? _resolveConstructedInterfaceType(InstanceCreationExpression node) {
    final constructor = node.constructorName.staticElement;
    final enclosing = constructor?.enclosingElement;
    if (enclosing is ClassElement) return enclosing.thisType;

    final staticType = node.staticType;
    if (staticType is InterfaceType) return staticType;

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

  (String?, String?) _extractIVFromFormFieldBrick(InterfaceType t) {
    for (final s in <InterfaceType>[t, ...t.allSupertypes]) {
      if (s.element.name == 'FormFieldBrick') {
        final args = s.typeArguments;
        if (args.length >= 2) {
          final iArg = args[0];
          final vArg = args[1];

          String? iSrc;
          String? vSrc;

          if (iArg is InterfaceType) {
            iSrc = iArg.getDisplayString(
              withNullability: iArg.nullabilitySuffix != NullabilitySuffix.none,
            );
          } else if (iArg is TypeParameterType) {
            iSrc = iArg.getDisplayString(withNullability: true);
          }

          if (vArg is InterfaceType) {
            vSrc = vArg.getDisplayString(
              withNullability: vArg.nullabilitySuffix != NullabilitySuffix.none,
            );
          } else if (vArg is TypeParameterType) {
            vSrc = vArg.getDisplayString(withNullability: true);
          }

          return (iSrc, vSrc);
        }
      }
    }
    return (null, null);
  }
}

// ---------- DTO ----------

class _FieldInfo {
  _FieldInfo();

  String? fieldClassName; // <-- NEW

  String? inputGenericSource;
  String? valueGenericSource;

  String? keyStringSource;
  String? initialInputSource;
  String? isFocusedOnStartSource;
  String? isRequiredSource;
  String? validatorsFullRunSource;
  String? runDefaultValidatorsFirstSource;
  String? defaultFormatterValidatorListMaker;
  String? addFormatterValidatorListMaker;

  String? keyStringLiteral;
  bool? isFocusedOnStartLiteralBool;
  bool? isRequiredLiteralBool;
  bool? runDefaultValidatorsFirstLiteralBool;
  bool? validatorsFullRunLiteralBool;

  String get unknownKeyFallback => '<unknown_key>';

  static _FieldInfo fromCreation(InstanceCreationExpression node) {
    final info = _FieldInfo();
    for (final arg in node.argumentList.arguments) {
      if (arg is! NamedExpression) continue;
      final name = arg.name.label.name;
      final expression = arg.expression;

      if (name == 'keyString') {
        info.keyStringSource = expression.toString();
        if (expression is StringLiteral) info.keyStringLiteral = expression.stringValue;
      } else if (name == 'initialInput') {
        info.initialInputSource = expression.toString();
      } else if (name == 'isFocusedOnStart') {
        info.isFocusedOnStartSource = expression.toString();
        if (expression is BooleanLiteral) info.isFocusedOnStartLiteralBool = expression.value;
      } else if (name == 'isRequired') {
        info.isRequiredSource = expression.toString();
        if (expression is BooleanLiteral) info.isRequiredLiteralBool = expression.value;
      } else if (name == 'runDefaultValidatorsFirst') {
        info.runDefaultValidatorsFirstSource = expression.toString();
        if (expression is BooleanLiteral) info.runDefaultValidatorsFirstLiteralBool = expression.value;
      } else if (name == 'validatorsFullRun') {
        info.validatorsFullRunSource = expression.toString();
        if (expression is BooleanLiteral) info.validatorsFullRunLiteralBool = expression.value;
      } else if (name == 'defaultFormatterValidatorListMaker') {
        info.defaultFormatterValidatorListMaker = expression.toString();
      } else if (name == 'addFormatterValidatorListMaker') {
        info.addFormatterValidatorListMaker = expression.toString();
      }
    }
    return info;
  }
}
