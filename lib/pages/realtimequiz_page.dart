import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';

class RealtimeQuiz extends StatefulWidget {
  const RealtimeQuiz({super.key});

  @override
  State<RealtimeQuiz> createState() => _RealtimeQuizState();
}

class _RealtimeQuizState extends State<RealtimeQuiz> {
  late DatabaseReference _databaseReference;
  List<Map<String, dynamic>> qrcodesList = [];

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child("qrcodes");

    _databaseReference.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> qrcodeData =
            event.snapshot.value as Map<String, dynamic>;
        bool validate = qrcodeData['validate'] ?? false;
        if (validate &&
            qrcodeData['data']['creatorUserId'] == AuthController.getUserId()) {
          setState(() {
            qrcodesList.add(qrcodeData);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF723172),
        appBar: AppBar(
          title: const Text(
            "Quizes que estão sendo feitos: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.5,
              viewportFraction: 0.8,
              enableInfiniteScroll: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            items: qrcodesList.map((item) {
              return SizedBox(
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          item['data']['titulo'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Código: ${item['data']['codigo']}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Usuário: ${item['userData']['username']}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Email: ${item['userData']['email']}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Score: ${item['userData']['score']}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }
}
