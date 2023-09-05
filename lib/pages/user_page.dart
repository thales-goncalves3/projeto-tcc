import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tcc/pages/login_page.dart';
import 'package:projeto_tcc/pages/qrcode_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Lista de Quizzes'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            List<QueryDocumentSnapshot> quizList = snapshot.data!.docs;

            List<Map<String, dynamic>> listaPerguntas = [];

            for (var element in quizList) {
              listaPerguntas.add(element.data() as Map<String, dynamic>);
            }

            return ListView.builder(
              itemCount: listaPerguntas.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> quizData =
                    quizList[index].data() as Map<String, dynamic>;

                getUserInfo() {
                  final teste = FirebaseFirestore.instance
                      .collection('users')
                      .doc(quizData['userId'])
                      .collection('infos')
                      .snapshots();

                  return teste;
                }

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: StreamBuilder(
                        stream: getUserInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasData) {
                            var user = snapshot.data!.docs[0].data();

                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user['username'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            listaPerguntas[index]['titulo'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: TextButton(
                                              onPressed: () {
                                                quizData['userId'] =
                                                    user['username'];

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          QrCodePage(
                                                              userInfos:
                                                                  quizData),
                                                    ));
                                              },
                                              child:
                                                  const Text("Realizar Quiz"))),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const Text(
                                'Erro ao carregar informações do usuário.');
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Nenhum quiz disponível.'),
            );
          }
        },
      ),
    );
  }
}
