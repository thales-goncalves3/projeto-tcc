import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_tcc/controllers/database_controller.dart';

import 'package:projeto_tcc/pages/qrcode_page.dart';
import 'package:projeto_tcc/providers/aux_image_provider.dart';
import 'package:projeto_tcc/providers/change_page_provider.dart';

import 'package:projeto_tcc/providers/color_provider.dart';
import 'package:projeto_tcc/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  UserPage({super.key});

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

  Future<ImageProvider> fetchImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final File imageFile =
          File('path_to_local_image'); // Salve a imagem localmente
      await imageFile.writeAsBytes(response.bodyBytes);
      return FileImage(imageFile);
    } else {
      return AssetImage("lib/assets/desconto.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
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
            decoration: BoxDecoration(
              color: Provider.of<ColorProvider>(context).mainColor,
            ),
            child: ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundImage: userData[index]
                                        ['urlPhoto'],
                                    child: const CircularProgressIndicator(),
                                  )),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            return const Text('Nenhum usuário encontrado.');
                          }

                          var data = snapshot.data!.docs;

                          if (data.isNotEmpty) {
                            return CarouselSlider(
                              items: [
                                for (var item in data)
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    height:
                                        MediaQuery.of(context).size.height * 1,
                                    child: Card(
                                      color: Provider.of<ColorProvider>(context)
                                          .mainColor,
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
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Valor do produto: R\$ ${item['valorProduto']}",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Valor final: R\$ ${double.parse(item['valorProduto']) - (double.parse(item['valorProduto']) * (int.parse(item['desconto']) / 100))}",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.grey[300],
                                                      minimumSize:
                                                          const Size(200, 60),
                                                    ),
                                                    onPressed: () {
                                                      try {
                                                        Provider.of<UserProvider>(
                                                                context,
                                                                listen: false)
                                                            .changeData(
                                                                item.data());
                                                        final navigationProvider =
                                                            Provider.of<
                                                                    ChangePageProvider>(
                                                                context,
                                                                listen: false);
                                                        navigationProvider
                                                            .navigateToPage(
                                                                AppPage
                                                                    .QrCodePage);
                                                      } catch (e) {
                                                        print(e);
                                                      }
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         const QrCodePage(),
                                                      //   ),
                                                      // );
                                                    },
                                                    child: const Text(
                                                      "Realizar Quiz",
                                                      style: TextStyle(
                                                          color: Colors.black,
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
                                autoPlayInterval: const Duration(seconds: 3),
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Provider.of<ColorProvider>(context)
                                      .mainColor,
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width * .7,
                              height: MediaQuery.of(context).size.height * .3,
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
                );
              },
            ));
      },
    );
  }
}
