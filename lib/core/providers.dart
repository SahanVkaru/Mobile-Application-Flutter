import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constants.dart';
import '../features/weighing/data/repositories/hive_weight_repository.dart';
import '../features/weighing/domain/repositories/weight_repository.dart';

// Box Provider
final hiveBoxProvider = Provider<Box>((ref) {
  return Hive.box(AppStrings.hiveBoxName);
});

// Repository Provider
final weightRepositoryProvider = Provider<WeightRepository>((ref) {
  final box = ref.watch(hiveBoxProvider);
  return HiveWeightRepository(box);
});
