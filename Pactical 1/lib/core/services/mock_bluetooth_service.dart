import 'dart:async';
import 'dart:math';
import 'bluetooth_service.dart';

class MockBluetoothService implements BluetoothService {
  final _weightController = StreamController<double>.broadcast();
  Timer? _timer;
  bool _isConnected = false;

  @override
  Future<List<String>> scanDevices() async {
    await Future.delayed(const Duration(seconds: 1));
    return ['TeaScale-001', 'TeaScale-002'];
  }

  @override
  Future<bool> connect(String deviceId) async {
    await Future.delayed(const Duration(seconds: 1));
    _isConnected = true;
    _startGeneratingWeights();
    return true;
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
    _timer?.cancel();
  }

  @override
  Stream<double> get weightStream => _weightController.stream;

  @override
  Future<bool> get isBluetoothOn async => true;

  void _startGeneratingWeights() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isConnected) {
        timer.cancel();
        return;
      }
      // Generate some random weight between 10.0 and 50.0
      final weight = 10.0 + Random().nextDouble() * 40.0;
      _weightController.add(double.parse(weight.toStringAsFixed(2)));
    });
  }
}
