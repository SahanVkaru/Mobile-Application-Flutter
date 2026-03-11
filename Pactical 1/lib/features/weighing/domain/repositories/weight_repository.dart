import '../../data/models/weight_record_model.dart';

abstract class WeightRepository {
  /// Saves a new weight record to local storage.
  Future<void> saveRecord(WeightRecordModel record);

  /// Retrieves all weight records, sorted by date (newest first).
  Future<List<WeightRecordModel>> getRecords();

  /// Deletes a record by ID.
  Future<void> deleteRecord(String id);

  /// Syncs unsynced records to the backend (Placeholder).
  Future<void> syncRecords();

  /// Clears local storage (for testing/reset).
  Future<void> clearAll();
}
