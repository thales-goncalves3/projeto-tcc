import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  final dynamic userInfos;

  const QrCodePage({
    Key? key,
    required this.userInfos,
  }) : super(key: key);

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  bool gera = true;
  bool validate = false;

  @override
  void initState() {
    super.initState();

    final databaseReference = FirebaseDatabase.instance
        .ref()
        .child("qrcodes")
        .child(widget.userInfos['codigo']);

    databaseReference.child("validate").onValue.listen((event) {
      if (event.snapshot.value != null) {
        bool validateValue = event.snapshot.value as bool;
        setState(() {
          validate = validateValue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerar QR Code'),
      ),
      body: !validate
          ? Center(
              child: gera
                  ? Column(
                      children: [
                        Text("Quiz criado por: ${widget.userInfos['userId']}"),
                        Text(
                            "Valor do produto: R\$${widget.userInfos['valorProduto']}"),
                        Text(
                            "Desconto aplicado: ${widget.userInfos['desconto']}%"),
                        Text(
                            "Valor Final: R\$${double.parse(widget.userInfos['valorProduto']) - (double.parse(widget.userInfos['valorProduto']) * (int.parse(widget.userInfos['desconto']) / 100))}"),
                        TextButton(
                          onPressed: () {
                            final DatabaseReference databaseReference =
                                FirebaseDatabase.instance
                                    .ref()
                                    .child("qrcodes");

                            databaseReference
                                .child(widget.userInfos['codigo'])
                                .set({
                              'validate': false,
                            });

                            setState(() {
                              gera = !gera;
                            });
                          },
                          child: const Text("Gerar QrCode"),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        children: [
                          QrImageView(
                            data: widget.userInfos['codigo'],
                            size: 300,
                            version: QrVersions.auto,
                          ),
                        ],
                      ),
                    ))
          : const Text("deu certo"),
    );
  }
}
