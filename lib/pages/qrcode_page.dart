import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/controllers/database_controller.dart';
import 'package:projeto_tcc/pages/user_page.dart';
import 'package:projeto_tcc/providers/change_page_provider.dart';
import 'package:projeto_tcc/providers/color_provider.dart';
import 'package:projeto_tcc/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({
    Key? key,
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
        "qrcodes/${providerUser.data['codigo'] + AuthController.getUserId()}";
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
    final dynamic userInfos = Provider.of<UserProvider>(context).data;
    return finished
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          final navigationProvider =
                              Provider.of<ChangePageProvider>(context,
                                  listen: false);
                          navigationProvider.navigateToPage(AppPage.UserPage);
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
                                  "Quiz criado por: ${userInfos['creatorUserId']}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    "Valor do produto: R\$${userInfos['valorProduto']}",
                                    style: const TextStyle(fontSize: 20)),
                                Text(
                                    "Desconto aplicado: ${userInfos['desconto']}%",
                                    style: const TextStyle(fontSize: 20)),
                                Text(
                                    "Valor Final: R\$${double.parse(userInfos['valorProduto']) - (double.parse(userInfos['valorProduto']) * (int.parse(userInfos['desconto']) / 100))}",
                                    style: const TextStyle(fontSize: 20)),
                                Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(200, 60),
                                      ),
                                      onPressed: () async {
                                        final user = await DatabaseController
                                            .getUserInfos();

                                        try {
                                          DatabaseReference ref =
                                              FirebaseDatabase.instance.ref(
                                                  'qrcodes/${userInfos['codigo'] + AuthController.getUserId()}');

                                          await ref.set({
                                            'validate': false,
                                            'data': userInfos,
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
                                        style: TextStyle(fontSize: 18),
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
                              data: userInfos['codigo'] +
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
                                  "Questão ${countPergunta + 1} de ${userInfos['perguntas'].length}"),
                              Text(
                                "Pergunta: ${userInfos['perguntas'][countPergunta]['questao']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: List.generate(
                            userInfos['perguntas'][countPergunta]['opcao']
                                .length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: colorOptions[index],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RadioListTile<int>(
                                    title: Text(
                                      userInfos['perguntas'][countPergunta]
                                          ['opcao'][index],
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
                                    backgroundColor:
                                        Provider.of<ColorProvider>(context)
                                            .mainColor,
                                    minimumSize: const Size(200, 60),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      if (userInfos['perguntas'][countPergunta]
                                              ['correta'] ==
                                          selectedOption) {
                                        colorOptions[selectedOption] =
                                            Colors.green[900]!;

                                        respostasCorretas++;
                                      } else {
                                        colorOptions[selectedOption] =
                                            Colors.red[900]!;
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
                                    backgroundColor:
                                        Provider.of<ColorProvider>(context)
                                            .mainColor,
                                    minimumSize: const Size(200, 60),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      if (countPergunta <
                                          userInfos['perguntas'].length - 1) {
                                        countPergunta++;
                                        colorOptions[selectedOption] =
                                            Colors.white;
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
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text(
                                                        'Você acertou $respostasCorretas de ${userInfos['perguntas'].length} perguntas',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Finalizar',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  onPressed: () async {
                                                    var score = 100 *
                                                        respostasCorretas /
                                                        userInfos['perguntas']
                                                            .length;

                                                    var scoreFirebase = 0;

                                                    if (score == 100.0) {
                                                      scoreFirebase = 10;
                                                    } else if (score <= 99 &&
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
                                                          .collection("users")
                                                          .doc(AuthController
                                                              .getUserId())
                                                          .update({
                                                        'score': scoreFirebase +
                                                            newScore
                                                      });

                                                      final databaseReference =
                                                          FirebaseDatabase
                                                              .instance
                                                              .ref()
                                                              .child("qrcodes")
                                                              .child(userInfos[
                                                                      'codigo'] +
                                                                  AuthController
                                                                      .getUserId());

                                                      databaseReference
                                                          .child("finished")
                                                          .set(true);

                                                      FirebaseFirestore.instance
                                                          .collection("history")
                                                          .doc()
                                                          .set({
                                                        'user': AuthController
                                                            .getUserId(),
                                                        'quiz': userInfos,
                                                        'score': scoreFirebase,
                                                      });

                                                      final navigationProvider =
                                                          // ignore: use_build_context_synchronously
                                                          Provider.of<
                                                                  ChangePageProvider>(
                                                              context,
                                                              listen: false);
                                                      navigationProvider
                                                          .navigateToPage(
                                                              AppPage.UserPage);

                                                      // ignore: use_build_context_synchronously
                                                      Navigator.of(context)
                                                          .pop();
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
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
