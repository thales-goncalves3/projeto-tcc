import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:projeto_tcc/pages/quiz_page.dart';
import 'package:projeto_tcc/pages/validate_quiz.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateQuizPage(),
                    ));
              },
              child: const Text("Criar desconto")),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ValidateQuiz(),
                    ));
              },
              child: const Text("Validar quiz"))
        ],
      ),
      body: Container(
        color: Colors.grey[300],
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
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${listaPerguntas[index]['titulo']}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(
                                      height: 20,
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
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Resposta correta: ${listaPerguntas[index]['perguntas'][innerIndex]['opcao'][listaPerguntas[index]['perguntas'][innerIndex]['correta']]}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Divider(
                                              height: 20,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    Text(
                                        "Preço do produto: R\$ ${listaPerguntas[index]['valorProduto']}"),
                                    Text(
                                        "Desconto a ser aplicado: ${listaPerguntas[index]['desconto']}%"),
                                    Text(
                                        "Valor final: R\$ ${(double.parse(listaPerguntas[index]['valorProduto']) - (double.parse(listaPerguntas[index]['valorProduto']) * (int.parse(listaPerguntas[index]['desconto']) / 100))).toString()}"),
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
      ),
    );
  }
}
