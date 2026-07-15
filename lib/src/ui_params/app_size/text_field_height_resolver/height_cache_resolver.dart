import 'package:equatable/equatable.dart' show Equatable;

abstract class HeightCacheResolver extends Equatable {
  const HeightCacheResolver();
  bool isCacheable();
}