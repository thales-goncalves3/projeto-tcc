import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ValidateQuiz extends StatefulWidget {
  const ValidateQuiz({super.key});

  @override
  State<ValidateQuiz> createState() => _ValidateQuizState();
}

class _ValidateQuizState extends State<ValidateQuiz> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated))
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final DatabaseReference databaseReference = FirebaseDatabase.instance
          .ref()
          .child("qrcodes")
          .child(scanData.code.toString());

      databaseReference.update({"validate": true});

      print("TESTE -----------------------------${scanData.code} ");
    });
  }
}