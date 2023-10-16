import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:projeto_tcc/pages/editprofile_page.dart';
import 'package:projeto_tcc/pages/finishedquizzes_page.dart';
import 'package:projeto_tcc/pages/login_page.dart';
import 'package:projeto_tcc/pages/quiz_page.dart';
import 'package:projeto_tcc/pages/realtimequiz_page.dart';
import 'package:projeto_tcc/pages/validate_quiz.dart';
import 'package:projeto_tcc/providers/change_page_provider.dart';
import 'package:projeto_tcc/providers/color_provider.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';

class PartnerPage extends StatefulWidget {
  const PartnerPage({super.key});

  @override
  State<PartnerPage> createState() => _PartnerPageState();
}

class _PartnerPageState extends State<PartnerPage> {
  Stream<QuerySnapshot> getQuiz() {
    Stream<QuerySnapshot> quizStream = FirebaseFirestore.instance
        .collection('quizzes')
        .where('creatorUserId', isEqualTo: AuthController.getUserId())
        .snapshots();

    return quizStream;
  }

  bool light1 = true;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.sunny,
          color: Colors.black,
        );
      }
      return const Icon(Icons.nightlight_round);
    },
  );

  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<ColorProvider>(context);
    return Container(
      color: Provider.of<ColorProvider>(context).mainColor,
      child: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Não foi possivel buscar o usuario"),
            );
          }
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> quizList = snapshot.data!.docs;

            List<Map<String, dynamic>> listaPerguntas = [];

            for (var element in quizList) {
              listaPerguntas.add(element.data() as Map<String, dynamic>);
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;

                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverStaggeredGrid.countBuilder(
                        crossAxisCount: crossAxisCount,
                        itemCount: listaPerguntas.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${listaPerguntas[index]['titulo']}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(
                                    height: 20,
                                    color: Colors.black,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: listaPerguntas[index]
                                            ['perguntas']
                                        .length,
                                    itemBuilder: (context, innerIndex) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pergunta ${innerIndex + 1}: ${listaPerguntas[index]['perguntas'][innerIndex]['questao']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Resposta correta: ${listaPerguntas[index]['perguntas'][innerIndex]['opcao'][listaPerguntas[index]['perguntas'][innerIndex]['correta']]}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Divider(
                                            height: 20,
                                            color: Colors.black,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Text(
                                    "Preço do produto: R\$ ${listaPerguntas[index]['valorProduto']}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Desconto a ser aplicado: ${listaPerguntas[index]['desconto']}%",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Valor final: R\$ ${(double.parse(listaPerguntas[index]['valorProduto']) - (double.parse(listaPerguntas[index]['valorProduto']) * (int.parse(listaPerguntas[index]['desconto']) / 100))).toString()}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[300],
                                          minimumSize: const Size(200, 60),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  "Excluir Quiz",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                content: const Text(
                                                    "Tem certeza que deseja excluir esse quiz?",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Não",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      var valorParaExcluir =
                                                          listaPerguntas[index]
                                                              ['codigo'];
                                                      QuerySnapshot
                                                          querySnapshot =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "quizzes")
                                                              .where("codigo",
                                                                  isEqualTo:
                                                                      valorParaExcluir)
                                                              .limit(1)
                                                              .get();
                                                      if (querySnapshot
                                                          .docs.isNotEmpty) {
                                                        var documentoParaExcluir =
                                                            querySnapshot
                                                                .docs.first;
                                                        await documentoParaExcluir
                                                            .reference
                                                            .delete();
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    child: const Text("Sim",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text(
                                          "Finalizar",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) =>
                            StaggeredTile.fit(crossAxisCount),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                    ),
                  ],
                );
              },
            );
          }

          return const Text('Nenhum dado encontrado');
        },
        stream: getQuiz(),
      ),
    );
  }
}
