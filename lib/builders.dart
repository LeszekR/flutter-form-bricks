// CREATED by: ChagGPT.CodeCopilot, zarzur
library flutter_form_bricks.builders;

import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart' show ImportDirective;
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/annotations/auto_form_schema.dart';
import 'src/annotations/auto_form_schema_generator.dart';

class _AutoFormSchemaStandaloneBuilder implements Builder {
  final _gen = AutoFormSchemaGenerator();
  final _checker = const TypeChecker.fromRuntime(AutoFormSchema);

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': ['_schema.g.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    // Load the input library.
    final lib = await buildStep.resolver.libraryFor(inputId, allowSyntaxErrors: false);
    final reader = LibraryReader(lib);

    // Collect annotated classes and generated code chunks.
    final chunks = <String>[];
    for (final klass in reader.classes) {
      final ann = _checker.firstAnnotationOf(klass, throwOnUnresolved: false);
      if (ann == null) continue;
      final code = await _gen.generateForAnnotatedElement(klass, ConstantReader(ann), buildStep);
      if (code.trim().isNotEmpty) chunks.add(code.trim());
    }

    if (chunks.isEmpty) return; // Nothing to generate for this input.

    // Gather imports from the source unit and add the source file itself.
    final sourceImports = <String>{};
    final unit = await buildStep.resolver.compilationUnitFor(inputId);
    for (final d in unit.directives) {
      if (d is ImportDirective) {
        final uri = d.uri.stringValue;
        if (uri != null && uri.isNotEmpty) sourceImports.add(uri);
      }
    }

    // Import the original source file so its top-level constants are visible.
    final srcUri = 'package:${inputId.package}/${inputId.path}';
    sourceImports.add(srcUri);

    // Baseline imports required by the schema types.
    sourceImports.addAll({
      'package:flutter_form_bricks/src/forms/base/form_schema.dart',
      'package:flutter_form_bricks/src/forms/base/form_field_descriptor.dart',
    });

    // Compose standalone file.
    final buf = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln('// ignore_for_file: unused_import, directives_ordering, depend_on_referenced_packages')
      ..writeln();

    for (final uri in sourceImports.toList()..sort()) {
      buf.writeln("import '$uri';");
      buf.writeln();
    }

    for (final c in chunks) {
      buf.writeln(c);
      buf.writeln();
    }

    // Write to `<input>_schema.g.dart` next to the input file.
    final outPath = inputId.path.replaceFirst(RegExp(r'\.dart$'), '_schema.g.dart');
    final outputId = AssetId(inputId.package, outPath);
    await buildStep.writeAsString(outputId, buf.toString());
  }
}

Builder autoFormSchema(BuilderOptions options) => _AutoFormSchemaStandaloneBuilder();
