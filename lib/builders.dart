import 'package:build/build.dart';
import 'package:flutter_form_bricks/src/annotations/auto_form_schema_generator_back_2.dart';
import 'package:source_gen/source_gen.dart';

Builder autoFormSchemaBuilder(BuilderOptions options) =>
    PartBuilder([AutoFormSchemaGenerator()], '.g.dart');
