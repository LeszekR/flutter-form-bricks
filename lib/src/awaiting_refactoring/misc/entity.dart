import 'dart:convert';

mixin Entity {
  Map<String, dynamic> toJson();
  String toJsonString() => jsonEncode(toJson());
  dynamic getId();
  String entityName();
  String shortDescription();
}