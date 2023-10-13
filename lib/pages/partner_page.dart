import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:projeto_tcc/pages/editprofile_page.dart';
import 'package:projeto_tcc/pages/login_page.dart';
import 'package:projeto_tcc/pages/quiz_page.dart';
import 'package:projeto_tcc/pages/realtimequiz_page.dart';
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
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF723172),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Image.asset(
                          "lib/assets/desconto-icon-branco.png",
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        "Quiz Barganha",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Editar Perfil"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfile(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text("Criar Desconto"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateQuizPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text("Validar Quiz"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ValidateQuiz(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.timelapse),
              title: const Text("Quiz em Tempo Real"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RealtimeQuiz(),
                  ),
                );
              },
            ),
            const SizedBox(height: 200.0),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Sair"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Quiz Barganha"),
      ),
      body: Container(
        color: const Color(0xFF723172),
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
                              elevation:
                                  5, // Elevação para dar uma sombra sutil
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Borda arredondada
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Borda arredondada para o container
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${listaPerguntas[index]['titulo']}',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .black, // Cor do texto do título
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(
                                      height: 20,
                                      color: Colors.black, // Cor do divisor
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
                                                color: Colors
                                                    .black, // Cor do texto da pergunta
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Resposta correta: ${listaPerguntas[index]['perguntas'][innerIndex]['opcao'][listaPerguntas[index]['perguntas'][innerIndex]['correta']]}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .black, // Cor do texto da resposta correta
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Divider(
                                              height: 20,
                                              color: Colors
                                                  .black, // Cor do divisor
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    Text(
                                      "Preço do produto: R\$ ${listaPerguntas[index]['valorProduto']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors
                                            .black, // Cor do texto do preço do produto
                                      ),
                                    ),
                                    Text(
                                      "Desconto a ser aplicado: ${listaPerguntas[index]['desconto']}%",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors
                                            .black, // Cor do texto do desconto
                                      ),
                                    ),
                                    Text(
                                      "Valor final: R\$ ${(double.parse(listaPerguntas[index]['valorProduto']) - (double.parse(listaPerguntas[index]['valorProduto']) * (int.parse(listaPerguntas[index]['desconto']) / 100))).toString()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors
                                            .black, // Cor do texto do valor final
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AnimatedButton(
                                        text: "Finalizar",
                                        animatedOn: AnimatedOn.onHover,
                                        height: 40,
                                        width: 200,
                                        isReverse: true,
                                        selectedTextColor: Colors.black,
                                        transitionType:
                                            TransitionType.LEFT_TO_RIGHT,
                                        backgroundColor:
                                            const Color(0xFF723172),
                                        borderColor: Colors.white,
                                        borderRadius: 5,
                                        borderWidth: 2,
                                        onPress: () async {
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
                                      ),
                                    ),
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
