import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants.dart';
import '../../data/models/weight_record_model.dart';
import 'weight_repository.dart';

class HiveWeightRepository implements WeightRepository {
  final Box box;

  HiveWeightRepository(this.box);

  @override
  Future<void> saveRecord(WeightRecordModel record) async {
    await box.put(record.id, record);
  }

  @override
  Future<List<WeightRecordModel>> getRecords() async {
    final records = box.values.cast<WeightRecordModel>().toList();
    records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return records;
  }

  @override
  Future<void> deleteRecord(String id) async {
    await box.delete(id);
  }

  @override
  Future<void> syncRecords() async {
    // Placeholder for sync logic
    // 1. Get all records where isSynced == false
    // 2. Push to Firestore
    // 3. Update isSynced = true
  }

  @override
  Future<void> clearAll() async {
    await box.clear();
  }
}
