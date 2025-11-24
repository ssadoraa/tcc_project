import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tcc_project/services/qr_service.dart';
import 'package:tcc_project/theme/app_colors.dart';
import 'package:confetti/confetti.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _cameraController = MobileScannerController();
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final QrService _qrService = QrService();
  bool _isProcessing = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void qrRead(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final codeLido = barcodes.first.rawValue;
    if (codeLido == null) return;

    _isProcessing = true;

    final result = await _qrService.unlockMission(userId, codeLido);
    final String msg = result["msg"];
    final bool isNew = result["isNew"];

    if (isNew) {
      _confettiController.play();
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isNew ? AppColors.background : AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isNew) ...[
                    Text(
                      "Missão Desbloqueada!!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ] else ...[
                    Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],

                  SizedBox(height: 24),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text("Ok"),
                  ),
                ],
              ),
            ),
            if (isNew)
              Positioned.fill(
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 120,
                  gravity: 0.25,
                ),
              ),
          ],
        ),
      ),
    );
    _isProcessing = false;
  }

  @override
  Widget build(BuildContext context) {
    double scanBoxSize = 250.0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: 13.0),
            child: Text('Escanear QR Code', style: TextStyle(fontSize: 20)),
          ),
          backgroundColor: AppColors.secondary,
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _cameraController, onDetect: qrRead),
          LayoutBuilder(
            builder: (context, raints) {
              final width = raints.maxWidth;
              final height = raints.maxHeight;

              return Stack(
                children: [
                  Container(
                    width: width,
                    height: height,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  Positioned(
                    top: (height - scanBoxSize) / 2,
                    left: (width - scanBoxSize) / 2,
                    child: Container(
                      width: scanBoxSize,
                      height: scanBoxSize,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.grey, width: 4),
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
                                  color: Colors.green,
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
