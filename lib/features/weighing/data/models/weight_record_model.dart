import 'package:hive/hive.dart';

part 'weight_record_model.g.dart';

@HiveType(typeId: 0)
class WeightRecordModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String supplierId;

  @HiveField(2)
  final double grossWeight;

  @HiveField(3)
  final int sackCount;

  @HiveField(4)
  final double waterDeduction; // Stored as weight (kg)

  @HiveField(5)
  final double bagDeduction; // Stored as weight (kg)

  @HiveField(6)
  final double netWeight;

  @HiveField(7)
  final DateTime timestamp;

  @HiveField(8)
  final bool isSynced;

  WeightRecordModel({
    required this.id,
    required this.supplierId,
    required this.grossWeight,
    required this.sackCount,
    required this.waterDeduction,
    required this.bagDeduction,
    required this.netWeight,
    required this.timestamp,
    this.isSynced = false,
  });
}
