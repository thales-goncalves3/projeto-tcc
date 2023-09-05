// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/pages/partner_page.dart';
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

  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Criar Quiz'),
        ),
        body: config
            ? Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: ListTile(
                          title: const Text("Qual o título do quiz?"),
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
                          title: const Text("Quantas perguntas deseja?"),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                          title: const Text("Quantidade de desconto? %"),
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
                      const SizedBox(height: 10), // Espaço vertical maior

                      SizedBox(
                        width: 300,
                        child: ListTile(
                          title: const Text("Qual valor do produto? R\$"),
                          subtitle: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: valorDoProduto,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Esse campo é obrigatório";
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const SizedBox(height: 20), // Espaço vertical maior
                      SizedBox(
                        width: 200,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (formKey.currentState!.validate()) {
                                config = !config;
                              }
                            });
                          },
                          child: const Text(
                            "Configurar",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Número de perguntas: ${quizData.length} / $cont",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        quizData.length == cont
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  child: const Text("Finalizar quiz"),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Confirmação"),
                                            content: const Text(
                                                "Deseja realmente finalizar o quiz?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Não")),
                                              TextButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('quizzes')
                                                        .add({
                                                      'userId': AuthController
                                                          .getUserId(),
                                                      'perguntas': quizData,
                                                      'desconto': desconto.text,
                                                      'valorProduto':
                                                          valorDoProduto.text,
                                                      'titulo': titulo.text,
                                                      'codigo': uuid.v1(),
                                                    });

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const PartnerPage(),
                                                        ));
                                                  },
                                                  child: const Text("Sim")),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              )
                            : const Text(""),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Card(
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: formKeyQuestion,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: questao,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
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
                                  if (value == null || value.isEmpty) {
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
                                  if (value == null || value.isEmpty) {
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
                                  if (value == null || value.isEmpty) {
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
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Esse campo é obrigatório";
                                  }
                                  int? parsedValue = int.tryParse(value);
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
                              ElevatedButton(
                                onPressed: cont == quizData.length
                                    ? () {}
                                    : addQuestion,
                                child: const Text(
                                  'Adicionar Pergunta',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: quizData.length,
                        itemBuilder: (context, index) {
                          if (quizData.isEmpty) {
                            return const Text("teste");
                          }
                          return SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 2.0,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: showEditInput[index]
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  controller: questaoAux,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        "Editar Pergunta",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              for (var i = 0;
                                                  i <
                                                      quizData[index]["opcao"]
                                                          .length;
                                                  i++)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    controller: opcaoAux[i],
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Editar Opção ${i + 1}",
                                                      border:
                                                          const OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                              const SizedBox(height: 16.0),
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    showEditInput[index] =
                                                        !showEditInput[index];

                                                    if (questaoAux
                                                        .text.isNotEmpty) {
                                                      quizData[index]
                                                              ['questao'] =
                                                          questaoAux.text;
                                                    }

                                                    for (var i = 0;
                                                        i < opcaoAux.length;
                                                        i++) {
                                                      if (opcaoAux[i]
                                                          .text
                                                          .isNotEmpty) {
                                                        quizData[index]['opcao']
                                                                [i] =
                                                            opcaoAux[i].text;
                                                      }
                                                    }
                                                    activateButton =
                                                        !activateButton;
                                                    questaoAux.clear();
                                                  });
                                                },
                                                child: const Text("Salvar"),
                                              ),
                                            ],
                                          )
                                        : ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 16.0,
                                                    horizontal: 16.0),
                                            tileColor: Colors
                                                .grey[100], // Cor de fundo
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // Borda arredondada
                                              side: BorderSide(
                                                  color: Colors.grey[
                                                      300]!), // Borda cinza
                                            ),
                                            title: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 16.0),
                                              child: Text(
                                                "Pergunta: ${quizData[index]['questao']}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
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
                                                        fontSize: 14.0),
                                                  ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                    "Opção correta: ${(quizData[index]['correta'] + 1).toString()}"),
                                                const SizedBox(
                                                    height:
                                                        8.0), // Espaçamento vertical entre opções e botão
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: activateButton
                                                          ? () {
                                                              setState(() {
                                                                showEditInput[
                                                                        index] =
                                                                    !showEditInput[
                                                                        index];
                                                                activateButton =
                                                                    !activateButton;
                                                              });
                                                            }
                                                          : null,
                                                      child: const Text(
                                                        "Editar pergunta",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .blue, // Cor do texto do botão
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            quizData.removeAt(
                                                                index);
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ));
  }
}
