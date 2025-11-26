import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:flutter_form_bricks/src/annotations/auto_form_schema.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class AutoFormSchemaGenerator extends GeneratorForAnnotation<AutoFormSchema> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element,
      ConstantReader annotation,
      BuildStep buildStep,
      ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'AutoFormSchema can only be used on classes.',
        element: element,
      );
    }

    // Get resolved AST for this class.
    final classNode = await buildStep.resolver.astNodeFor(
      element,
      resolve: true,
    );
    if (classNode is! ClassDeclaration) {
      throw InvalidGenerationSourceError(
        'AutoFormSchema can only be used on class declarations.',
        element: element,
      );
    }

    // Find the "build" method.
    final MethodDeclaration? buildMethod = classNode.members
        .whereType<MethodDeclaration>()
        .firstWhere(
          (m) => m.name.lexeme == 'build',
      orElse: () => throw InvalidGenerationSourceError(
        'Class ${element.name} must declare a build method to use @AutoFormSchema.',
        element: element,
      ),
    );

    // Prepare type information.
    final formFieldBrickType = _findFormFieldBrickType(element);

    final collector = _FormFieldBrickCollector(
      formFieldBrickType: formFieldBrickType,
    );

    // Recursively walk the widget tree inside build().
    buildMethod!.body.accept(collector);

    final fields = collector.fields;

    final className = element.name;
    final schemaClassName = '${className}Schema';

    // Emit output
    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.');
    buffer.writeln();
    buffer.writeln('class $schemaClassName extends FormSchema {');
    buffer.writeln('  $schemaClassName() : super([');

    for (final f in fields) {
      if (f.keyStringSource == null) {
        throw InvalidGenerationSourceError(
          'Missing required keyString argument in a FormFieldBrick constructor '
              'inside ${element.name}.build().',
          element: element,
        );
      }

      buffer.write('    FormFieldDescriptor(');
      buffer.write('keyString: ${f.keyStringSource}');

      if (f.initialInputSource != null) {
        buffer.write(', initialInput: ${f.initialInputSource}');
      }
      if (f.formatterChainSource != null) {
        buffer.write(', formatterValidatorChain: ${f.formatterChainSource}');
      }

      buffer.write('),');
      if (f.isFocusedLiteralTrue) buffer.write(' // focused');
      buffer.writeln();
    }

    buffer.writeln('  ]);');
    buffer.writeln('}');

    return buffer.toString();
  }

  InterfaceType? _findFormFieldBrickType(ClassElement element) {
    // Look in current library
    final direct = element.library.exportNamespace.get('FormFieldBrick') as ClassElement?;
    if (direct != null) {
      return direct.thisType;
    }

    // Look in imports
    for (final imported in element.library.importedLibraries) {
      final t = imported.exportNamespace.get('FormFieldBrick') as ClassElement?;
      if (t != null) return t.thisType;
    }

    // fallback: null means fallback to name check
    return null;
  }
}

// -----------------------------------------------------------------------------
// Internal support classes
// -----------------------------------------------------------------------------

class _DiscoveredField {
  final String? keyStringSource;
  final String? initialInputSource;
  final String? formatterChainSource;
  final bool isFocusedLiteralTrue;

  _DiscoveredField({
    required this.keyStringSource,
    required this.initialInputSource,
    required this.formatterChainSource,
    required this.isFocusedLiteralTrue,
  });
}

class _FormFieldBrickCollector extends GeneralizingAstVisitor<void> {
  final InterfaceType? formFieldBrickType;
  final List<_DiscoveredField> fields = [];

  _FormFieldBrickCollector({
    required this.formFieldBrickType,
  });

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (_isFormFieldBrickInstance(node)) {
      final args = node.argumentList;

      // Extract constructor parameters
      final keyExpr = _findNamedArg(args, 'keyString');
      final initialExpr = _findNamedArg(args, 'initialInput');
      final formatterExpr = _findNamedArg(args, 'formatterValidatorChain');
      final focusedExpr = _findNamedArg(args, 'isFocusedOnInit');

      final keySrc = keyExpr?.toSource();
      final initialSrc = initialExpr?.toSource();
      final formatterSrc = formatterExpr?.toSource();

      bool isFocused = false;
      if (focusedExpr is BooleanLiteral && focusedExpr.value == true) {
        isFocused = true;
      }

      fields.add(
        _DiscoveredField(
          keyStringSource: keySrc,
          initialInputSource: initialSrc,
          formatterChainSource: formatterSrc,
          isFocusedLiteralTrue: isFocused,
        ),
      );
    }

    super.visitInstanceCreationExpression(node);
  }

  bool _isFormFieldBrickInstance(InstanceCreationExpression node) {
    DartType? type = node.staticType;

    if (type is! InterfaceType) {
      final t = node.constructorName.type.type;
      if (t is InterfaceType) type = t;
    }

    if (type is! InterfaceType) return false;

    // strong type check
    if (formFieldBrickType != null) {
      if (_isSubtypeOf(type, formFieldBrickType!)) return true;
    }

    // fallback name check
    final name = type.element.name;
    return name == 'FormFieldBrick' || name.endsWith('FormFieldBrick');
  }

  bool _isSubtypeOf(InterfaceType type, InterfaceType target) {
    if (type.element == target.element) return true;
    for (final sup in type.allSupertypes) {
      if (sup.element == target.element) return true;
    }
    return false;
  }

  Expression? _findNamedArg(ArgumentList args, String name) {
    for (final a in args.arguments) {
      if (a is NamedExpression && a.name.label.name == name) {
        return a.expression;
      }
    }
    return null;
  }
}
