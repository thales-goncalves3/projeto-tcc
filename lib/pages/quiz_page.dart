// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/pages/partner_page.dart';
import 'package:projeto_tcc/providers/change_page_provider.dart';
import 'package:projeto_tcc/providers/color_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<FormState> formKeyQuestion = GlobalKey();

  List<Map<String, dynamic>> quizData = [];
  List<Map<String, dynamic>> quizDataAux = [];
  List<bool> showEditInput = [];

  TextEditingController questao = TextEditingController();
  TextEditingController opcaoUm = TextEditingController();
  TextEditingController opcaoDois = TextEditingController();
  TextEditingController opcaoTres = TextEditingController();
  TextEditingController correta = TextEditingController();

  bool showChange = false;
  bool activateButton = true;
  bool config = true;

  int cont = 2;

  TextEditingController questaoAux = TextEditingController();
  TextEditingController corretaAux = TextEditingController();

  TextEditingController valorDoProduto = TextEditingController();
  TextEditingController desconto = TextEditingController();
  TextEditingController titulo = TextEditingController();

  List<TextEditingController> opcaoAux = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  void addQuestion() {
    if (formKeyQuestion.currentState!.validate()) {
      if (questao.text.isEmpty ||
          opcaoUm.text.isEmpty ||
          opcaoDois.text.isEmpty ||
          opcaoTres.text.isEmpty ||
          correta.text.isEmpty) {
        return;
      }

      setState(() {
        quizData.add({
          'questao': questao.text,
          'opcao': [
            opcaoUm.text,
            opcaoDois.text,
            opcaoTres.text,
          ],
          'correta': int.parse(correta.text) - 1,
        });

        showEditInput.add(false);

        questao.clear();
        opcaoUm.clear();
        opcaoDois.clear();
        opcaoTres.clear();
        correta.clear();
      });
    }
  }

  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: !config
            ? quizData.length != cont
                ? FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Adicionar Questão',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: SingleChildScrollView(
                              child: Card(
                                elevation: 2.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Form(
                                    key: formKeyQuestion,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        TextFormField(
                                          controller: questao,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Esse campo é obrigatório";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Pergunta',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        TextFormField(
                                          controller: opcaoUm,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Esse campo é obrigatório";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Opção 1',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        TextFormField(
                                          controller: opcaoDois,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Esse campo é obrigatório";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Opção 2',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        TextFormField(
                                          controller: opcaoTres,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Esse campo é obrigatório";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Opção 3',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        TextFormField(
                                          controller: correta,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Esse campo é obrigatório";
                                            }
                                            int? parsedValue =
                                                int.tryParse(value);
                                            if (parsedValue == null ||
                                                parsedValue < 1 ||
                                                parsedValue > 3) {
                                              return "O valor precisa estar entre 1 e 3";
                                            }

                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            labelText:
                                                'Resposta Correta (Digite o número da opção)',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  if (formKeyQuestion.currentState!
                                      .validate()) {
                                    addQuestion();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text(
                                  'Adicionar Pergunta',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancelar',
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                : null
            : null,
        backgroundColor: Provider.of<ColorProvider>(context).mainColor,
        body: config
            ? Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: MediaQuery.of(context).size.height * .8,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                width: 300,
                                child: ListTile(
                                  title: const Text(
                                    "Qual o título do quiz?",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: TextFormField(
                                    controller: titulo,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: ListTile(
                                  title: const Text(
                                    "Quantas perguntas deseja?",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (cont > 2) cont--;
                                            });
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Text(
                                          cont.toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (cont <= 6) cont++;
                                            });
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: ListTile(
                                  title: const Text(
                                    "Quantidade de desconto? %",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: desconto,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Esse campo é obrigatório";
                                      }
                                      int? parsedValue = int.tryParse(value);
                                      if (parsedValue == null ||
                                          parsedValue < 5 ||
                                          parsedValue > 100) {
                                        return "O desconto deve ser de 5% a 100%";
                                      }

                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 300,
                                child: ListTile(
                                  title: const Text(
                                    "Qual valor do produto? R\$",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: valorDoProduto,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Esse campo é obrigatório";
                                      }

                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      minimumSize: const Size(200, 60),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        setState(() {
                                          if (formKey.currentState!
                                              .validate()) {
                                            config = !config;
                                          }
                                        });
                                      });
                                    },
                                    child: const Text(
                                      "Configurar",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          quizData.length == cont
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      minimumSize: const Size(200, 60),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Confirmação",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                content: const Text(
                                                    "Deseja realmente finalizar o quiz?",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        "Não",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                  TextButton(
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'quizzes')
                                                            .add({
                                                          'creatorUserId':
                                                              AuthController
                                                                  .getUserId(),
                                                          'perguntas': quizData,
                                                          'desconto':
                                                              desconto.text,
                                                          'valorProduto':
                                                              valorDoProduto
                                                                  .text,
                                                          'titulo': titulo.text,
                                                          'codigo': uuid.v1(),
                                                        });
                                                        final navigationProvider =
                                                            Provider.of<
                                                                    ChangePageProvider>(
                                                                context,
                                                                listen: false);
                                                        navigationProvider
                                                            .navigateToPage(
                                                                AppPage
                                                                    .PartnerPage);

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        "Sim",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                ],
                                              );
                                            });
                                      });
                                    },
                                    child: const Text(
                                      "Finalizar",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ))
                              : Text(
                                  "Número de perguntas: ${quizData.length} / $cont",
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: quizData.length,
                          itemBuilder: (context, index) {
                            if (quizData.isEmpty) {
                              return const Text("");
                            }
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                print(constraints.maxWidth);
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 4.0,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 16.0,
                                            horizontal: 16.0,
                                          ),
                                          tileColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                          title: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: Text(
                                              "Pergunta: ${quizData[index]['questao']}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var i = 0;
                                                  i <
                                                      quizData[index]['opcao']
                                                          .length;
                                                  i++)
                                                Text(
                                                  "Opção ${i + 1}: ${quizData[index]['opcao'][i]}",
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                "Opção correta: ${(quizData[index]['correta'] + 1).toString()}",
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        quizData
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    color: Colors.red,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
