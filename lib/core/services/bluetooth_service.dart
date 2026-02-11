abstract class BluetoothService {
  /// Scans for available Bluetooth devices.
  Future<List<String>> scanDevices();

  /// Connects to a specific device by ID.
  Future<bool> connect(String deviceId);

  /// Disconnects from the current device.
  Future<void> disconnect();

  /// Reads weight data from the connected scale.
  Stream<double> get weightStream;
  
  /// Helper to check if bluetooth is on
  Future<bool> get isBluetoothOn;
}
