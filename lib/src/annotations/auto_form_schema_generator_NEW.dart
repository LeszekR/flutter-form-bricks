// // lib/src/annotations/auto_form_schema_generator.dart
// // (fixed: no manual writeAsString, returns code; keeps prior bugfixes)
//
// library flutter_form_bricks.generator;
//
// import 'package:analyzer/dart/ast/ast.dart';
// import 'package:analyzer/dart/ast/visitor.dart';
// import 'package:analyzer/dart/element/element.dart';
// import 'package:analyzer/dart/element/nullability_suffix.dart';
// import 'package:analyzer/dart/element/type.dart';
// import 'package:source_gen/source_gen.dart';
//
// import '../forms/base/form_schema.dart' as base_schema show FormSchema;
// import '../forms/base/form_field_descriptor.dart' as base_desc show FormFieldDescriptor;
// import 'auto_form_schema.dart';
//
// class AutoFormSchemaGenerator extends GeneratorForAnnotation<AutoFormSchema> {
//   @override
//   Future<String> generateForAnnotatedElement(
//       Element element,
//       ConstantReader annotation,
//       BuildStep buildStep,
//       ) async {
//     if (element is! ClassElement) {
//       throw InvalidGenerationSourceError(
//         '@AutoFormSchema can only be applied to classes.',
//         element: element,
//       );
//     }
//
//     final deepScan = annotation.peek('deepScan')?.boolValue ?? true;
//     final overrideName = annotation.peek('name')?.stringValue;
//
//     final widgetClass = element;
//     _assertIsFormBrickSubclass(widgetClass);
//
//     final formName = widgetClass.name;
//     final schemaClassName = overrideName ?? '${formName}Schema';
//
//     // Resolve State class from createState()
//     final stateClass = _resolveStateClass(widgetClass);
//     if (stateClass == null) {
//       throw InvalidGenerationSourceError(
//         'Could not resolve State class from ${widgetClass.name}.createState().',
//         element: widgetClass,
//       );
//     }
//
//     // Get AST node of the State class
//     final stateDeclNode = await buildStep.resolver.astNodeFor(stateClass, resolve: true);
//     if (stateDeclNode is! ClassDeclaration) {
//       throw InvalidGenerationSourceError(
//         'State class `${stateClass.name}` AST not found or not a ClassDeclaration.',
//         element: stateClass,
//       );
//     }
//
//     // Entry methods: build(), buildBody()
//     final entryMethods = <MethodDeclaration>[
//       ...stateDeclNode.members.whereType<MethodDeclaration>().where((m) => m.name.lexeme == 'build'),
//       ...stateDeclNode.members.whereType<MethodDeclaration>().where((m) => m.name.lexeme == 'buildBody'),
//     ];
//     if (entryMethods.isEmpty) {
//       throw InvalidGenerationSourceError(
//         'State class `${stateClass.name}` has no build()/buildBody() to scan.',
//         element: widgetClass,
//       );
//     }
//
//     final methodIndex = <String, MethodDeclaration>{
//       for (final m in stateDeclNode.members.whereType<MethodDeclaration>()) m.name.lexeme: m,
//     };
//
//     final collector = _FieldInstantiationCollector(deepScan: deepScan);
//     final visited = <String>{};
//     for (final m in entryMethods) {
//       _recurseVisitMethod(m, collector, methodIndex, visited);
//     }
//
//     final descriptorEntries = collector.items.map((it) {
//       final genericI = it.inputGenericSource ?? 'Object';
//       final genericV = it.valueGenericSource ?? 'Object';
//       final keyCode = it.keyStringSource ?? _quoted(it.keyStringLiteral ?? it.unknownKeyFallback);
//       final initCode = it.initialInputSource ?? 'null';
//       final chainCode = it.chainSource ?? 'null';
//       return 'base_desc.FormFieldDescriptor<$genericI, $genericV>('
//           'keyString: $keyCode, initialInput: $initCode, formatterValidatorChain: $chainCode)';
//     }).join(',\n    ');
//
//     // IMPORTANT: return code only; SharedPartBuilder emits `.g.part`, then combining_builder creates `<file>.g.dart`
//     return '''
// // GENERATED CODE - DO NOT MODIFY BY HAND
// // ignore_for_file: depend_on_referenced_packages, unnecessary_import, unnecessary_cast
//
// /// Auto-generated schema for $formName by @AutoFormSchema.
// class $schemaClassName extends base_schema.FormSchema {
//   $schemaClassName()
//       : super(<base_desc.FormFieldDescriptor>[
//     $descriptorEntries
//   ]);
// }
// ''';
//   }
//
//   void _assertIsFormBrickSubclass(ClassElement el) {
//     final t = el.thisType;
//     const baseName = 'FormBrick';
//     final ok = _hasSupertypeNamed(t, baseName);
//     if (!ok) {
//       throw InvalidGenerationSourceError(
//         '@AutoFormSchema must annotate a class extending FormBrick.',
//         element: el,
//       );
//     }
//   }
//
//   bool _hasSupertypeNamed(InterfaceType type, String name) {
//     if (type.element.name == name) return true;
//     for (final s in type.allSupertypes) {
//       if (s.element.name == name) return true;
//     }
//     return false;
//   }
//
//   ClassElement? _resolveStateClass(ClassElement widgetClass) {
//     final createState = widgetClass.lookUpMethod('createState', widgetClass.library);
//     if (createState == null) return null;
//     final rt = createState.returnType;
//     if (rt is! InterfaceType) return null;
//     return rt.element as ClassElement;
//   }
//
//   void _recurseVisitMethod(
//       MethodDeclaration method,
//       _FieldInstantiationCollector collector,
//       Map<String, MethodDeclaration> index,
//       Set<String> visited,
//       ) {
//     final key = method.name.lexeme;
//     if (!visited.add(key)) return;
//     method.body.accept(collector);
//     if (!collector.deepScan) return;
//     for (final call in collector.pendingCalls.toList()) {
//       if (!collector.pendingCalls.remove(call)) continue;
//       final target = index[call];
//       if (target != null) {
//         _recurseVisitMethod(target, collector, index, visited);
//       }
//     }
//   }
//
//   String _quoted(String s) {
//     if (s.startsWith("'") || s.startsWith('"')) return s;
//     final escaped = s.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
//     return "'$escaped'";
//   }
// }
//
// class _FieldInstantiationCollector extends RecursiveAstVisitor<void> {
//   final bool deepScan;
//   final items = <_FieldInfo>[];
//   final pendingCalls = <String>{};
//
//   _FieldInstantiationCollector({required this.deepScan});
//
//   @override
//   void visitMethodInvocation(MethodInvocation node) {
//     pendingCalls.add(node.methodName.name);
//     super.visitMethodInvocation(node);
//   }
//
//   @override
//   void visitInstanceCreationExpression(InstanceCreationExpression node) {
//     final t = node.staticType;
//     if (t is InterfaceType && _isFormFieldBrickSubtype(t)) {
//       final info = _FieldInfo.fromCreation(node);
//       final superI = _extractIFromFormFieldBrick(t);
//       if (superI != null) info.inputGenericSource = superI;
//       info.valueGenericSource ??= 'Object';
//       items.add(info);
//     }
//     super.visitInstanceCreationExpression(node);
//   }
//
//   bool _isFormFieldBrickSubtype(InterfaceType t) {
//     for (final s in [t, ...t.allSupertypes]) {
//       if (s.element.name == 'FormFieldBrick') return true;
//     }
//     return false;
//   }
//
//   String? _extractIFromFormFieldBrick(InterfaceType t) {
//     for (final s in [t, ...t.allSupertypes]) {
//       if (s.element.name == 'FormFieldBrick') {
//         final args = s.typeArguments;
//         if (args.isNotEmpty) {
//           final a = args.first;
//           if (a is InterfaceType) {
//             return a.getDisplayString(
//               withNullability: a.nullabilitySuffix != NullabilitySuffix.none,
//             );
//           }
//           if (a is TypeParameterType) {
//             return a.getDisplayString(withNullability: true);
//           }
//         }
//       }
//     }
//     return null;
//   }
// }
//
// class _FieldInfo {
//   _FieldInfo();
//
//   String? inputGenericSource;
//   String? valueGenericSource;
//
//   String? keyStringSource;
//   String? initialInputSource;
//   String? chainSource;
//
//   String? keyStringLiteral;
//
//   String get unknownKeyFallback => '<unknown_key>';
//
//   static _FieldInfo fromCreation(InstanceCreationExpression node) {
//     final info = _FieldInfo();
//     for (final arg in node.argumentList.arguments) {
//       if (arg is! NamedExpression) continue;
//       final name = arg.name.label.name;
//       final expr = arg.expression;
//
//       if (name == 'keyString') {
//         info.keyStringSource = expr.toString();
//         if (expr is StringLiteral) info.keyStringLiteral = expr.stringValue;
//       } else if (name == 'initialInput') {
//         info.initialInputSource = expr.toString();
//       } else if (name == 'formatterValidatorChain') {
//         info.chainSource = expr.toString();
//       }
//     }
//     return info;
//   }
// }
