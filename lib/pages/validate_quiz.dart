import 'dart:io';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/pages/partner_page.dart';
import 'package:projeto_tcc/providers/change_page_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ValidateQuiz extends StatefulWidget {
  const ValidateQuiz({super.key});

  @override
  State<ValidateQuiz> createState() => _ValidateQuizState();
}

class _ValidateQuizState extends State<ValidateQuiz> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  late String resultText;
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
      body: result != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    resultText,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final navigationProvider =
                          Provider.of<ChangePageProvider>(context,
                              listen: false);
                      navigationProvider.navigateToPage(AppPage.PartnerPage);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                    ),
                    child: const Text(
                      "Voltar",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                const SizedBox(
                    height: 30,
                    child: Center(
                        child: Text(
                      "Lendo QRCODE",
                      style: TextStyle(color: Colors.white),
                    )))
              ],
            ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        try {
          final DataSnapshot databaseReference = await FirebaseDatabase.instance
              .ref()
              .child("qrcodes")
              .child(scanData.code.toString())
              .get();

          if (databaseReference.exists) {
            final data = databaseReference.value as Map<dynamic, dynamic>;

            if (data['data']['creatorUserId'] == AuthController.getUserId()) {
              FirebaseDatabase.instance
                  .ref()
                  .child("qrcodes")
                  .child(scanData.code.toString())
                  .update({"validate": true});
              setState(() {
                result = scanData;
                resultText = "Quiz validado com sucesso.";
              });
            } else {
              setState(() {
                result = scanData;
                resultText = "Parceiro não autorizado";
              });
            }
          }
        } catch (e) {
          print('Erro ao acessar os valores: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
