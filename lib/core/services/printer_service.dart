abstract class PrinterService {
  /// Connects to a printer.
  Future<bool> connect(String deviceId);

  /// Disconnects from the printer.
  Future<void> disconnect();

  /// Prints a receipt.
  Future<void> printReceipt({
    required String supplierId,
    required double weight,
    required double deductions,
    required double netWeight,
    required String date,
  });
}
