import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerService {
  static final QRScannerService _singleton = QRScannerService._internal();

  factory QRScannerService() {
    return _singleton;
  }

  QRScannerService._internal();

  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  // ValueNotifier to hold the result
  final resultNotifier = ValueNotifier<Barcode?>(null);

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      resultNotifier.value = scanData;
    });
  }

  void dispose() {
    controller?.dispose();
  }
}
