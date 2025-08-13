import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  QRScannerPage({Key? key}) : super(key: key);
  
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController _cameraController = MobileScannerController();

  showQrContent(String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Conteúdo do QR Code"),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cameraController.start();
            },
            child: Text("Fechar"),
          ),
        ],
      ),
    );
  }

  qrRead(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final code = barcodes.first.rawValue;
      if (code != null) {
        _cameraController.stop();
        showQrContent(code);
      }
    }
  }

  @override
  dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Escanear QR Code")),
      body: MobileScanner(
        controller: _cameraController,
        onDetect: qrRead,
      ),
    );
  }
}
