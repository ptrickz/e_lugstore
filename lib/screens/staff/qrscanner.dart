import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/constants.dart';
import 'package:e_lugstore/screens/staff/home.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  alertBox(String title, String message, VoidCallback onPressed) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(onPressed: onPressed, child: const Text("OK"))
              ],
            ));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout Luggage"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQRView(context),
        ],
      ),
    );
  }

  Widget buildQRView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: accent,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: MediaQuery.of(context).size.width * 0.8),
      );
  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
        alertBox("Confirm Checkout?",
            "Item: ${barcode.code} will be checked out once user press confirmed.",
            () {
          final docBooking = FirebaseFirestore.instance
              .collection('bookings')
              .doc(barcode.code);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const StaffHome()));
          docBooking
              .update({'checkoutConfirmation': "Pending User Confirmation"});
        });
      });
    });
  }
}
