# QRScannerService

The `QRScannerService` class is used to provide the functionality of scanning QR codes in a Flutter application. The `qr_code_scanner` package provides the `QRViewController` and `Barcode` classes which are necessary for scanning QR codes.

This service is created as a Singleton design pattern, meaning that there will be only one instance of `QRScannerService` throughout the application.

```dart
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
```
# QRScannerPage

The `QRScannerPage` class represents a screen for scanning a QR code. It consists of a Scaffold widget containing an AppBar and a QRView widget.

The `QRView` widget is created using the `qrKey` from `QRScannerService` and the `onQRViewCreated` callback is set to the `QRScannerService.onQRViewCreated` method.

The results of the last scan are displayed on the screen using the `ValueListenableBuilder` widget. This widget listens to the `resultNotifier` from `QRScannerService` and automatically rebuilds the widget when a new QR code is scanned.

```dart
class _QRScannerPageState extends State<QRScannerPage> {
  final QRScannerService _scannerService = QRScannerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scanner')),
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
                  return Text('Scan a code');
                } else {
                  return Text('QR Data: ${result.code}');
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
```
