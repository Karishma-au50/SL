// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QrScanPage extends StatefulWidget {
//   const QrScanPage({super.key});

//   @override
//     State<QrScanPage> createState() => _QrScanPageState();
// }

// class _QrScanPageState extends State<QrScanPage> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   bool hasScanned = false;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;

//     controller.scannedDataStream.listen((scanData) {
//       if (!hasScanned) {
//         setState(() => hasScanned = true);
//         controller.pauseCamera();
//         _showRewardDialog();
//       }
//     });
//   }

//   void _showRewardDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("🎉 Reward Received"),
//         content: Text("You have earned 50 points!"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               controller?.resumeCamera();
//               setState(() => hasScanned = false);
//             },
//             child: Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildScannerOverlay(BoxConstraints constraints) {
//     final scanArea = constraints.maxWidth * 0.6;
//     return Stack(
//       children: [
//         Center(
//           child: Container(
//             width: scanArea,
//             height: scanArea,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.blue, width: 2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text("QR Code"),
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           Text(
//             'Scan QR Code',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
//             child: Text(
//               'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//           Expanded(
//             child: LayoutBuilder(
//               builder: (_, constraints) => Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   QRView(
//                     key: qrKey,
//                     onQRViewCreated: _onQRViewCreated,
//                     overlay: QrScannerOverlayShape(
//                       borderColor: Colors.blue,
//                       borderRadius: 10,
//                       borderLength: 30,
//                       borderWidth: 5,
//                       cutOutSize: constraints.maxWidth * 0.6,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: OutlinedButton.icon(
//               onPressed: () {
//                 // Simulate image scan from gallery
//                 _showRewardDialog();
//               },
//               icon: Icon(Icons.image),
//               label: Text("Choose Gallery"),
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: Colors.deepPurple,
//                 side: BorderSide(color: Colors.deepPurple),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
