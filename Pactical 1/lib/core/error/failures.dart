import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Error']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache Error']);
}

class BluetoothFailure extends Failure {
  const BluetoothFailure([super.message = 'Bluetooth Error']);
}

class HardwareFailure extends Failure {
  const HardwareFailure([super.message = 'Hardware Error']);
}
