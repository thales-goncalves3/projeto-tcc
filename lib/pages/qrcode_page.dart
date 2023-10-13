import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/controllers/database_controller.dart';
import 'package:projeto_tcc/pages/user_page.dart';
import 'package:projeto_tcc/pages/user_provider.dart';
import 'package:provider/provider.dart';

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
  bool finished = false;
  int countPergunta = 0;
  bool enviar = false;
  List<bool> marcarOpcoes = [];
  List<Color> colorOptions = [Colors.white, Colors.white, Colors.white];
  int selectedOption = -1;
  bool travarRadioBox = false;
  int respostasCorretas = 0;
  bool enviarResultado = false;
  late DatabaseReference _databaseReference;
  @override
  void initState() {
    super.initState();

    final providerUser = Provider.of<UserProvider>(context, listen: false);

    providerUser.initUser();

    String nodePath =
        "qrcodes/${widget.userInfos['codigo'] + AuthController.getUserId()}";
    _databaseReference = FirebaseDatabase.instance.ref().child(nodePath);

    _databaseReference.child("finished").onValue.listen((event) {
      if (event.snapshot.value != null) {
        bool? finishedValue = event.snapshot.value as bool?;
        if (finishedValue != null) {
          setState(() {
            finished = finishedValue;
          });
        }
      }
    });

    _databaseReference.child("validate").onValue.listen((event) {
      bool? validateValue = event.snapshot.value as bool?;
      if (validateValue != null) {
        setState(() {
          validate = validateValue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF723172),
      appBar: AppBar(
        title: validate ? const Text("Quiz") : const Text('Gerar QR Code'),
      ),
      body: finished
          ? Center(
              child: Container(
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.height * .5,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Este quiz já foi realizado",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const UserPage(),
                            ));
                          },
                          child: const Text("Voltar")),
                    )
                  ],
                )),
              ),
            )
          : !validate
              ? Center(
                  child: gera
                      ? Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * .9,
                            height: MediaQuery.of(context).size.height * .5,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Quiz criado por: ${widget.userInfos['creatorUserId']}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "Valor do produto: R\$${widget.userInfos['valorProduto']}",
                                      style: const TextStyle(fontSize: 20)),
                                  Text(
                                      "Desconto aplicado: ${widget.userInfos['desconto']}%",
                                      style: const TextStyle(fontSize: 20)),
                                  Text(
                                      "Valor Final: R\$${double.parse(widget.userInfos['valorProduto']) - (double.parse(widget.userInfos['valorProduto']) * (int.parse(widget.userInfos['desconto']) / 100))}",
                                      style: const TextStyle(fontSize: 20)),
                                  Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF723172),
                                          minimumSize: const Size(200, 60),
                                        ),
                                        onPressed: () async {
                                          final user = await DatabaseController
                                              .getUserInfos();

                                          try {
                                            DatabaseReference ref =
                                                FirebaseDatabase.instance.ref(
                                                    'qrcodes/${widget.userInfos['codigo'] + AuthController.getUserId()}');

                                            await ref.set({
                                              'validate': false,
                                              'data': widget.userInfos,
                                              'finished': false,
                                              'userData': user,
                                            });
                                          } catch (e) {
                                            print(e);
                                          }

                                          setState(() {
                                            gera = !gera;
                                          });
                                        },
                                        child: const Text(
                                          "Gerar QrCode",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.grey[300]),
                          width: MediaQuery.of(context).size.width * .5,
                          height: MediaQuery.of(context).size.height * .5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: QrImageView(
                                data: widget.userInfos['codigo'] +
                                    AuthController.getUserId(),
                                version: QrVersions.auto,
                              ),
                            ),
                          ),
                        ))
              : Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    width: MediaQuery.of(context).size.width * .9,
                    height: MediaQuery.of(context).size.height * .7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            child: Column(
                              children: [
                                Text(
                                    "Questão ${countPergunta + 1} de ${widget.userInfos['perguntas'].length}"),
                                Text(
                                  "Pergunta: ${widget.userInfos['perguntas'][countPergunta]['questao']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: List.generate(
                              widget
                                  .userInfos['perguntas'][countPergunta]
                                      ['opcao']
                                  .length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RadioListTile<int>(
                                      activeColor: const Color(0xFF723172),
                                      tileColor: const Color(0xFF723172),
                                      title: Text(
                                        widget.userInfos['perguntas']
                                            [countPergunta]['opcao'][index],
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
                              ),
                            ),
                          ),
                          !enviar
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF723172),
                                      minimumSize: const Size(200, 60),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        if (widget.userInfos['perguntas']
                                                [countPergunta]['correta'] ==
                                            selectedOption) {
                                          colorOptions[selectedOption] =
                                              Colors.green;

                                          respostasCorretas++;
                                        } else {
                                          colorOptions[selectedOption] =
                                              Colors.red;
                                        }
                                        enviar = !enviar;
                                      });
                                    },
                                    child: const Text(
                                      'Confirmar',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF723172),
                                      minimumSize: const Size(200, 60),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        setState(() {
                                          if (countPergunta <
                                              widget.userInfos['perguntas']
                                                      .length -
                                                  1) {
                                            countPergunta++;
                                            colorOptions[selectedOption] =
                                                Colors.grey[200]!;
                                            selectedOption = -1;
                                            enviar = false;
                                          } else {
                                            travarRadioBox = true;
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Finalizar Quiz',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                            'Você acertou $respostasCorretas de ${widget.userInfos['perguntas'].length} perguntas',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text(
                                                          'Finalizar',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      onPressed: () async {
                                                        var score = 100 *
                                                            respostasCorretas /
                                                            widget
                                                                .userInfos[
                                                                    'perguntas']
                                                                .length;

                                                        var scoreFirebase = 0;

                                                        if (score == 100.0) {
                                                          scoreFirebase = 10;
                                                        } else if (score <=
                                                                99 &&
                                                            score >= 50) {
                                                          scoreFirebase = 5;
                                                        } else {
                                                          scoreFirebase = 2;
                                                        }
                                                        try {
                                                          final newScore =
                                                              await DatabaseController
                                                                  .getScore();

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(AuthController
                                                                  .getUserId())
                                                              .update({
                                                            'score':
                                                                scoreFirebase +
                                                                    newScore
                                                          });

                                                          final databaseReference =
                                                              FirebaseDatabase
                                                                  .instance
                                                                  .ref()
                                                                  .child(
                                                                      "qrcodes")
                                                                  .child(widget
                                                                              .userInfos[
                                                                          'codigo'] +
                                                                      AuthController
                                                                          .getUserId());

                                                          databaseReference
                                                              .child("finished")
                                                              .set(true);

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "history")
                                                              .doc()
                                                              .set({
                                                            'user':
                                                                AuthController
                                                                    .getUserId(),
                                                            'quiz': widget
                                                                .userInfos,
                                                            'score':
                                                                scoreFirebase,
                                                          });
                                                        } catch (e) {
                                                          print(e);
                                                        }

                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              const UserPage(),
                                                        ));
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        });
                                      });
                                    },
                                    child: const Text(
                                      'Próxima Pergunta',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  @override
  void dispose() {
    _databaseReference.child("validate").set(false).then((_) {
      _databaseReference.child("finished").onValue.drain();
      _databaseReference.child("validate").onValue.drain();
      super.dispose();
    });
  }
}
