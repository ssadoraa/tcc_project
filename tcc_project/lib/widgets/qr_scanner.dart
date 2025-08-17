import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  QRScannerPage({Key? key}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> with SingleTickerProviderStateMixin {
  final MobileScannerController _cameraController = MobileScannerController();
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void qrRead(BarcodeCapture capture) async {
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final codeLido = barcodes.first.rawValue;
    if (codeLido == null) return;

    _cameraController.stop();

    try {
      final query = await _firestore
          .collection("missions")
          .where("qr_code", isEqualTo: codeLido)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        _showMessage("QR inválido. Tente novamente.");
        _cameraController.start();
        return;
      }

      final missionDoc = query.docs.first;
      final missionId = missionDoc.id;

      await _firestore
          .collection("users")
          .doc(userId)
          .collection("unlockedMissions")
          .doc(missionId)
          .set({"unlockedAt": FieldValue.serverTimestamp()});

      _showMessage("Missão desbloqueada: ${missionDoc["titulo"]}");
    } catch (e) {
      _showMessage("Erro ao processar QR: $e");
      _cameraController.start();
    }
  }

  void _showMessage(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Resultado"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double scanBoxSize = 250.0;

    return Scaffold(
      appBar: AppBar(title: Text("Escanear QR Code")),
      body: Stack(
        children: [
          MobileScanner(
            controller: _cameraController,
            onDetect: qrRead,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return Stack(
                children: [
                  Container(
                    width: width,
                    height: height,
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                  ),
                  Positioned(
                    top: (height - scanBoxSize) / 2,
                    left: (width - scanBoxSize) / 2,
                    child: Container(
                      width: scanBoxSize,
                      height: scanBoxSize,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Color.fromARGB(255, 155, 152, 152),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              Positioned(
                                top: _animation.value * (scanBoxSize - 2),
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 3,
                                  color: Color.fromARGB(255, 88, 190, 5),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
