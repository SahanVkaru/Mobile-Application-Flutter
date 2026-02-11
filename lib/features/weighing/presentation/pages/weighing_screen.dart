import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants.dart';
import '../providers/weighing_provider.dart';

class WeighingScreen extends ConsumerStatefulWidget {
  const WeighingScreen({super.key});

  @override
  ConsumerState<WeighingScreen> createState() => _WeighingScreenState();
}

class _WeighingScreenState extends ConsumerState<WeighingScreen> {
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _grossWeightController = TextEditingController();
  double _waterDeductionPercent = 0.0;

  @override
  void dispose() {
    _supplierController.dispose();
    _grossWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weighingState = ref.watch(weighingStateProvider);
    final weightStream = ref.watch(weightStreamProvider);

    // Listen to stream and update state if connected
    ref.listen(weightStreamProvider, (previous, next) {
      if (next.value != null) {
        ref.read(weighingStateProvider.notifier).updateGrossWeight(next.value!);
        _grossWeightController.text = next.value!.toStringAsFixed(2);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("TeaSmart Collector"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () {
              // TODO: Open Bluetooth connection dialog
              // For now, Mock service auto-connect logic is inside service
            },
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              // TODO: Trigger Sync
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Supplier ID
            TextField(
              controller: _supplierController,
              decoration: const InputDecoration(
                labelText: "Supplier ID",
                prefixIcon: Icon(Icons.person),
                suffixIcon: Icon(Icons.qr_code_scanner),
              ),
              onChanged: (val) {
                ref.read(weighingStateProvider.notifier).updateSupplierId(val);
              },
            ),
            const SizedBox(height: 16),

            // 2. Weight Display
            Card(
              color: AppColors.primaryGreen,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text("GROSS WEIGHT",
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text(
                      "${weighingState.grossWeight.toStringAsFixed(2)} kg",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Manual Entry Override
             TextField(
              controller: _grossWeightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Manual Weight Entry",
                prefixIcon: Icon(Icons.scale),
              ),
              onChanged: (val) {
                double? weight = double.tryParse(val);
                if (weight != null) {
                   ref.read(weighingStateProvider.notifier).updateGrossWeight(weight);
                }
              },
            ),
            const SizedBox(height: 16),

            // 3. Sack Count
            Row(
              children: [
                Expanded(
                  child: Text("Sack Count: ${weighingState.sackCount}",
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (weighingState.sackCount > 1) {
                      ref.read(weighingStateProvider.notifier).updateSackCount(weighingState.sackCount - 1);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    ref.read(weighingStateProvider.notifier).updateSackCount(weighingState.sackCount + 1);
                  },
                ),
              ],
            ),
            const Divider(),

            // 4. Deductions
            Text("Deductions", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Bag Tare (1kg/bag):"),
                Text("- ${weighingState.bagDeduction.toStringAsFixed(1)} kg",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Water %: ${_waterDeductionPercent.toStringAsFixed(0)}%"),
                Text("- ${weighingState.waterDeduction.toStringAsFixed(2)} kg",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.alertRed)),
              ],
            ),
            Slider(
              value: _waterDeductionPercent,
              min: 0,
              max: 15,
              divisions: 15,
              label: "${_waterDeductionPercent.round()}%",
              activeColor: AppColors.alertRed,
              onChanged: (val) {
                setState(() {
                  _waterDeductionPercent = val;
                });
                ref.read(weighingStateProvider.notifier).updateWaterDeductionPercent(val);
              },
            ),

            const Divider(thickness: 2),

            // 5. Net Weight & Print
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("NET WEIGHT",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  "${weighingState.netWeight.toStringAsFixed(2)} kg",
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen),
                ),
              ],
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              icon: const Icon(Icons.print),
              label: const Text("PRINT RECEIPT"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              onPressed: () async {
                 bool success = await ref.read(weighingStateProvider.notifier).saveRecord();
                 if (success) {
                   if (context.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text("Record Saved & Printed!"), backgroundColor: AppColors.primaryGreen),
                     );
                     // Clear inputs
                     _supplierController.clear();
                     _grossWeightController.clear();
                     setState(() {
                       _waterDeductionPercent = 0.0;
                     });
                   }
                 } else {
                    if (context.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text("Invalid Data. Check Supplier ID & Weight."), backgroundColor: AppColors.alertRed),
                     );
                   }
                 }
              },
            ),
          ],
        ),
      ),
    );
  }
}
