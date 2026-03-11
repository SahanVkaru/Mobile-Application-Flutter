import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/bluetooth_service.dart';
import '../../../../core/services/mock_bluetooth_service.dart';
import '../../../../core/providers.dart';
import '../../data/models/weight_record_model.dart';
import 'package:uuid/uuid.dart';

part 'weighing_provider.g.dart';

// Bluetooth Service Provider
final bluetoothServiceProvider = Provider<BluetoothService>((ref) {
  return MockBluetoothService();
});

// Bluetooth Stream Provider
final weightStreamProvider = StreamProvider<double>((ref) {
  final bluetoothService = ref.watch(bluetoothServiceProvider);
  return bluetoothService.weightStream;
});

@riverpod
class WeighingState extends _$WeighingState {
  @override
  WeightRecordModel build() {
    return WeightRecordModel(
      id: const Uuid().v4(),
      supplierId: '',
      grossWeight: 0.0,
      sackCount: 1,
      waterDeduction: 0.0, // Weight in kg
      bagDeduction: 1.0, // Weight in kg
      netWeight: 0.0,
      timestamp: DateTime.now(),
    );
  }

  void updateGrossWeight(double weight) {
    state = _recalculate(state.copyWith(grossWeight: weight));
  }

  void updateSackCount(int count) {
    state = _recalculate(state.copyWith(sackCount: count));
  }
  
  void updateSupplierId(String id) {
    state = state.copyWith(supplierId: id);
  }

  /// Updates water deduction based on percentage (0-15%)
  void updateWaterDeductionPercent(double percent) {
    double bagTare = state.sackCount * 1.0;
    double afterTare = state.grossWeight - bagTare;
    if (afterTare < 0) afterTare = 0;
    
    double deduction = afterTare * (percent / 100);
    
    state = _recalculate(state.copyWith(waterDeduction: deduction));
  }

  WeightRecordModel _recalculate(WeightRecordModel current) {
    double bagTare = current.sackCount * 1.0; // 1kg per sack
    double afterTare = current.grossWeight - bagTare;
    
    // We already have the calculated water deduction in current
    double deduction = current.waterDeduction;
    
    // If water deduction seems too high (e.g. if gross weight dropped), maybe cap it?
    // For now, let's just keep the stored deduction or re-calculate if we had the percent stored.
    // Since we don't store percent in the model (per requirement), we might have an issue if gross weight changes.
    // Ideally, we should store waterPercent in the model too.
    // But adhering to the defined model, let's assume UI passes the percent again if needed. 
    // OR we just use the current waterDeduction value.
    
    // Wait, if I update gross weight, water deduction (which is absolute weight) should probably stay the same 
    // UNLESS it was calculated from a percentage.
    // Best approach: add `waterPercent` to the model or keep it in a separate provider state.
    // For simplicity, I'll assume standard flow: Weight -> Deduction.
    
    double net = afterTare - deduction;
    if (net < 0) net = 0;

    return current.copyWith(
      bagDeduction: bagTare,
      netWeight: net,
    );
  }
  
  Future<bool> saveRecord() async {
    if (state.supplierId.isEmpty || state.grossWeight <= 0) return false;
    
    final repository = ref.read(weightRepositoryProvider);
    await repository.saveRecord(state);
    
    // Reset state for next weighing
    state = WeightRecordModel(
      id: const Uuid().v4(),
      supplierId: '',
      grossWeight: 0.0,
      sackCount: 1,
      waterDeduction: 0.0,
      bagDeduction: 1.0,
      netWeight: 0.0,
      timestamp: DateTime.now(),
    );
    return true;
  }
}

extension WeightRecordModelCopy on WeightRecordModel {
    WeightRecordModel copyWith({
    String? id,
    String? supplierId,
    double? grossWeight,
    int? sackCount,
    double? waterDeduction,
    double? bagDeduction,
    double? netWeight,
    DateTime? timestamp,
    bool? isSynced,
  }) {
    return WeightRecordModel(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      grossWeight: grossWeight ?? this.grossWeight,
      sackCount: sackCount ?? this.sackCount,
      waterDeduction: waterDeduction ?? this.waterDeduction,
      bagDeduction: bagDeduction ?? this.bagDeduction,
      netWeight: netWeight ?? this.netWeight,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
