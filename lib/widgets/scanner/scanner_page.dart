import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../features/home/controller/dashboard_controller.dart';
import '../toast/my_toast.dart' show MyToasts;

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  MobileScannerController controller = MobileScannerController();
  final dashboardCntlr = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());
  bool isProcessing = false; // Flag to prevent multiple scans

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
        backgroundColor: const Color(0xFF001519),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.flashlight_on),
            iconSize: 32.0,
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: Icon(
              controller.facing == CameraFacing.front
                  ? Icons.camera_front
                  : Icons.camera_rear,
            ),
            iconSize: 32.0,
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
            fit: BoxFit.cover,
            placeholderBuilder: (p0, p1) {
              return Center(child: CircularProgressIndicator());
            },

            overlayBuilder: (p0, p1) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Text(
                    'Point the camera at a QR code',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              );
            },
          ),
          // Scanning overlay
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: Colors.transparent,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      controller.start();
                    },
                    icon: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.stop();
                    },
                    icon: const Icon(Icons.stop, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.start();
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (isProcessing) return; // Prevent multiple simultaneous scans

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      setState(() {
        isProcessing = true;
      });

      final String? code = barcodes.first.rawValue;
      if (code != null) {
        _handleScannedCode(code);
      }
    }
  }

  void _handleScannedCode(String code) async {
    // Stop the scanner
    controller.stop();

    print("Scanned QR Code: $code");

    try {
      // Call API to verify the QR code
      final success = await dashboardCntlr.qrVerification(data: code);

      // Navigate back after successful verification
      if (mounted && success) {
        Navigator.of(context).pop();
      } else if (mounted && !success) {
        // If verification failed, allow scanning again
        setState(() {
          isProcessing = false;
        });
      }
    } catch (e) {
      print("Error processing QR code: $e");

      // If it's not JSON or API call fails, show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('QR Code Error'),
              content: Text('Failed to process QR code: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isProcessing = false;
                    });
                    controller.start(); // Restart scanning
                  },
                  child: const Text('Scan Again'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Go back to previous screen
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      }

      MyToasts.toastError(e.toString());
    }
  }
}

// Custom overlay shape for the scanner
class QrScannerOverlayShape extends ShapeBorder {
  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(double cutOutSize) {
      return Path()
        ..moveTo(
          rect.center.dx - cutOutSize / 2,
          rect.center.dy - cutOutSize / 2,
        )
        ..lineTo(
          rect.center.dx - cutOutSize / 2 + borderLength,
          rect.center.dy - cutOutSize / 2,
        )
        ..moveTo(
          rect.center.dx - cutOutSize / 2,
          rect.center.dy - cutOutSize / 2,
        )
        ..lineTo(
          rect.center.dx - cutOutSize / 2,
          rect.center.dy - cutOutSize / 2 + borderLength,
        );
    }

    Path _getRightTopPath(double cutOutSize) {
      return Path()
        ..moveTo(
          rect.center.dx + cutOutSize / 2,
          rect.center.dy - cutOutSize / 2,
        )
        ..lineTo(
          rect.center.dx + cutOutSize / 2 - borderLength,
          rect.center.dy - cutOutSize / 2,
        )
        ..moveTo(
          rect.center.dx + cutOutSize / 2,
          rect.center.dy - cutOutSize / 2,
        )
        ..lineTo(
          rect.center.dx + cutOutSize / 2,
          rect.center.dy - cutOutSize / 2 + borderLength,
        );
    }

    Path _getLeftBottomPath(double cutOutSize) {
      return Path()
        ..moveTo(
          rect.center.dx - cutOutSize / 2,
          rect.center.dy + cutOutSize / 2,
        )
        ..lineTo(
          rect.center.dx - cutOutSize / 2 + borderLength,
          rect.center.dy + cutOutSize / 2,
        )
        ..moveTo(
          rect.center.dx - cutOutSize / 2,
          rect.center.dy + cutOutSize / 2,
        )
        ..lineTo(
          rect.center.dx - cutOutSize / 2,
          rect.center.dy + cutOutSize / 2 - borderLength,
        );
    }

    Path _getRightBottomPath(double cutOutSize) {
      return Path()
        ..moveTo(
          rect.center.dx + cutOutSize / 2,
          rect.center.dy + cutOutSize / 2,
        )
        ..lineTo(
          rect.center.dx + cutOutSize / 2 - borderLength,
          rect.center.dy + cutOutSize / 2,
        )
        ..moveTo(
          rect.center.dx + cutOutSize / 2,
          rect.center.dy + cutOutSize / 2,
        )
        ..lineTo(
          rect.center.dx + cutOutSize / 2,
          rect.center.dy + cutOutSize / 2 - borderLength,
        );
    }

    return Path.combine(
        PathOperation.difference,
        Path()..addRect(rect),
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: rect.center,
              width: cutOutSize,
              height: cutOutSize,
            ),
            Radius.circular(borderRadius),
          ),
        ),
      )
      ..addPath(_getLeftTopPath(cutOutSize), Offset.zero)
      ..addPath(_getRightTopPath(cutOutSize), Offset.zero)
      ..addPath(_getLeftBottomPath(cutOutSize), Offset.zero)
      ..addPath(_getRightBottomPath(cutOutSize), Offset.zero);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawPath(getOuterPath(rect), paint);
    canvas.drawPath(getOuterPath(rect), borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
