import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
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
  int countPergunta = 0;
  bool enviar = false;
  List<bool> marcarOpcoes = [];
  List<Color> colorOptions = [
    Colors.grey[200]!,
    Colors.grey[200]!,
    Colors.grey[200]!
  ];
  int selectedOption = -1;
  bool travarRadioBox = false;
  int respostasCorretas = 0;
  bool enviarResultado = false;

  @override
  void initState() {
    super.initState();

    final databaseReference = FirebaseDatabase.instance
        .ref()
        .child("qrcodes")
        .child(widget.userInfos['codigo'] + AuthController.getUserId());

    databaseReference.child("validate").onValue.listen((event) {
      if (event.snapshot.value != null) {
        bool validateValue = event.snapshot.value as bool;
        setState(() {
          validate = validateValue;
        });
      }
    });

    if (widget.userInfos['perguntas'].isNotEmpty) {
      marcarOpcoes = List.generate(
        widget.userInfos['perguntas'][countPergunta]['opcao'].length,
        (index) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // final DatabaseReference databaseReference =
        //     FirebaseDatabase.instance.ref().child("qrcodes");

        // await databaseReference.child(widget.userInfos['codigo']).remove();

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gerar QR Code'),
        ),
        body: !validate
            ? Center(
                child: gera
                    ? Column(
                        children: [
                          Text(
                              "Quiz criado por: ${widget.userInfos['creatorUserId']}"),
                          Text(
                              "Valor do produto: R\$${widget.userInfos['valorProduto']}"),
                          Text(
                              "Desconto aplicado: ${widget.userInfos['desconto']}%"),
                          Text(
                              "Valor Final: R\$${double.parse(widget.userInfos['valorProduto']) - (double.parse(widget.userInfos['valorProduto']) * (int.parse(widget.userInfos['desconto']) / 100))}"),
                          TextButton(
                            onPressed: () async {
                              final DatabaseReference databaseReference =
                                  FirebaseDatabase.instance
                                      .ref()
                                      .child("qrcodes");

                              await databaseReference
                                  .child(widget.userInfos['codigo'] +
                                      AuthController.getUserId())
                                  .set({
                                'validate': false,
                                'teste': widget.userInfos
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Pergunta: ${widget.userInfos['perguntas'][countPergunta]['questao']}",
                  ),
                  Column(
                    children: List.generate(
                      widget.userInfos['perguntas'][countPergunta]['opcao']
                          .length,
                      (index) => RadioListTile<int>(
                        tileColor: colorOptions[index],
                        activeColor: Colors.black,
                        title: Text(
                          widget.userInfos['perguntas'][countPergunta]['opcao']
                              [index],
                        ),
                        value: index,
                        groupValue: selectedOption,
                        onChanged: travarRadioBox
                            ? null
                            : (value) {
                                setState(() {
                                  selectedOption = value!;
                                });
                              },
                      ),
                    ),
                  ),
                  !enviar
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (widget.userInfos['perguntas'][countPergunta]
                                      ['correta'] ==
                                  selectedOption) {
                                colorOptions[selectedOption] =
                                    Colors.green[100]!;

                                respostasCorretas++;
                              } else {
                                colorOptions[selectedOption] = Colors.red[100]!;
                              }
                              enviar = !enviar;
                            });
                          },
                          child: const Text("Confirmar"),
                        )
                      : ElevatedButton(
                          child: const Text("Próxima pergunta"),
                          onPressed: () {
                            setState(() {
                              if (countPergunta <
                                  widget.userInfos['perguntas'].length - 1) {
                                countPergunta++;
                                colorOptions[selectedOption] =
                                    Colors.grey[200]!;
                                selectedOption = -1;
                                enviar = false;
                              } else {
                                travarRadioBox = true;
                                enviarResultado = true;
                              }
                            });
                          },
                        ),
                  enviarResultado
                      ? Column(
                          children: [
                            Text(
                                "Resultado: $respostasCorretas / ${widget.userInfos['perguntas'].length}"),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
      ),
    );
  }
}
