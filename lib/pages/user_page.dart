import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:projeto_tcc/controllers/database_controller.dart';
import 'package:projeto_tcc/pages/history_page.dart';
import 'package:projeto_tcc/pages/login_page.dart';
import 'package:projeto_tcc/pages/qrcode_page.dart';
import 'package:projeto_tcc/pages/rank_page.dart';
import 'package:projeto_tcc/pages/user_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();

    final providerUser = Provider.of<UserProvider>(context, listen: false);

    providerUser.initUser();
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 100,
                            child: Image.asset(
                              "lib/assets/desconto-icon-branco.png",
                              height: 100,
                            ),
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
                leading: const Icon(Icons.leaderboard), // Ícone
                title: const Text("Rank"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RankPage(),
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.history), // Ícone
                title: const Text("Historico"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HistoryPage(),
                  ));
                },
              ),
              const SizedBox(height: 300.0),
              ListTile(
                leading: const Icon(Icons.exit_to_app), // Ícone
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
          title: const Text('Lista de Quizzes'),
        ),
        body: StreamBuilder<List<QueryDocumentSnapshot>>(
          stream: DatabaseController.getUsersStream(),
          builder: (BuildContext context,
              AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Nenhum usuário encontrado.');
            }

            final userData = snapshot.data!;

            return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF723172),
                ),
                child: ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .2,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Image.network(
                                            userData[index]['urlPhoto'],
                                            scale: 1,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                );
                                              }
                                            },
                                            errorBuilder: (BuildContext context,
                                                Object error,
                                                StackTrace? stackTrace) {
                                              return const Text(
                                                  "Erro ao carregar a imagem");
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData[index]['username'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(userData[index]['description']),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('quizzes')
                                  .where('creatorUserId',
                                      isEqualTo: userData[index]['uuid'])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Text('Erro: ${snapshot.error}');
                                }
                                if (!snapshot.hasData) {
                                  return const Text(
                                      'Nenhum usuário encontrado.');
                                }

                                var data = snapshot.data!.docs;

                                if (data.isNotEmpty) {
                                  return CarouselSlider(
                                    items: [
                                      for (var item in data)
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              1,
                                          child: Card(
                                            color: const Color(0xFF723172),
                                            elevation: 20.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  item['titulo'].toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Desconto a ser aplicado: R\$ ${item['desconto']}",
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Valor do produto: R\$ ${item['valorProduto']}",
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Valor final: R\$ ${double.parse(item['valorProduto']) - (double.parse(item['valorProduto']) * (int.parse(item['desconto']) / 100))}",
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[300],
                                                            minimumSize:
                                                                const Size(
                                                                    200, 60),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        QrCodePage(
                                                                  userInfos: item
                                                                      .data(),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: const Text(
                                                            "Realizar Quiz",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                    options: CarouselOptions(
                                      height: 300.0,
                                      autoPlay: false,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: false,
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF723172),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width:
                                        MediaQuery.of(context).size.width * .7,
                                    height:
                                        MediaQuery.of(context).size.height * .3,
                                    child: const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Ainda não há quiz para esse parceiro",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ));
          },
        ));
  }
}
