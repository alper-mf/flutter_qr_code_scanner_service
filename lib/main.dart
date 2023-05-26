import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'app/services/qr_scanner_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QrScannerPage(),
    );
  }
}

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPage();
}

class _QrScannerPage extends State<QrScannerPage> {
  final QRScannerService _scannerService = QRScannerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Scanner')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: _scannerService.qrKey,
              onQRViewCreated: _scannerService.onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: ValueListenableBuilder<Barcode?>(
              valueListenable: _scannerService.resultNotifier,
              builder: (context, result, child) {
                if (result == null) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('Scan a code'),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text('QR Data: ${result.code}'),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scannerService.dispose();
    super.dispose();
  }
}
