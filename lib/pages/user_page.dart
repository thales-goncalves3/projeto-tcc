import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/controllers/database_controller.dart';
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

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  child: ListView.builder(
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.grey[300]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Image.network(
                                            userData[index]['urlPhoto'] ??
                                                "https://cdn-icons-png.flaticon.com/512/17/17004.png",
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .1,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .1,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .2,
                                          child: ListTile(
                                            title: Text(
                                              userData[index]['username'],
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                                userData[index]['description']),
                                          ),
                                        ),
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

                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CarouselSlider(
                                      items: [
                                        for (var item in data)
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .8,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Card(
                                                child: ListTile(
                                                  title: Text(
                                                    item['titulo'].toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 30),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Desconto a ser aplicado: R\$ ${item['desconto']}",
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        "Valor do produto: R\$ ${item['valorProduto']}",
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        "Valor final: R\$ ${double.parse(item['valorProduto']) - (double.parse(item['valorProduto']) * (int.parse(item['desconto']) / 100))}",
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: AnimatedButton(
                                                          text: 'Realizar Quiz',
                                                          animatedOn: AnimatedOn
                                                              .onHover,
                                                          height: 40,
                                                          width: 200,
                                                          isReverse: true,
                                                          selectedTextColor:
                                                              Colors.black,
                                                          transitionType:
                                                              TransitionType
                                                                  .LEFT_TO_RIGHT,
                                                          backgroundColor:
                                                              Colors.black,
                                                          borderColor:
                                                              Colors.white,
                                                          borderRadius: 5,
                                                          borderWidth: 2,
                                                          onPress: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      QrCodePage(
                                                                          userInfos:
                                                                              item),
                                                                ));
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                      ],
                                      options: CarouselOptions(
                                        height: 300.0,
                                        autoPlay: false,
                                        autoPlayInterval:
                                            const Duration(seconds: 3),
                                        enlargeCenterPage: true,
                                        enableInfiniteScroll: false,
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
                  ),
                ),
              ),
            );
          },
        ));
  }
}
