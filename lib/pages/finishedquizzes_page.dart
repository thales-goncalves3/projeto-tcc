import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/widgets/customtext_widget.dart';

class FinishedQuizzes extends StatefulWidget {
  const FinishedQuizzes({super.key});

  @override
  State<FinishedQuizzes> createState() => _FinishedQuizzesState();
}

class _FinishedQuizzesState extends State<FinishedQuizzes> {
  late DatabaseReference _databaseReference;
  List<Map<String, dynamic>> qrcodesList = [];

  bool light = true;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child("qrcodes");

    _databaseReference.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> qrcodeData =
            event.snapshot.value as Map<String, dynamic>;

        bool finished = qrcodeData['finished'] ?? false;
        if (finished &&
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ListView(
          children: [
            ...qrcodesList.map(
              (item) {
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.grey[300],
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BoldFirstText(
                              label: "Quiz:", text: item['data']['titulo']),
                          const SizedBox(
                            height: 5,
                          ),
                          BoldFirstText(
                              label: "Valor do produto:",
                              text: "R\$${item['data']['valorProduto']}"),
                          const SizedBox(
                            height: 5,
                          ),
                          BoldFirstText(
                              label: "Valor do desconto:",
                              text: "${item['data']['desconto']}%"),
                          const SizedBox(
                            height: 5,
                          ),
                          BoldFirstText(
                              label: "Usuário:",
                              text: item['userData']['username']),
                          const SizedBox(
                            height: 5,
                          ),
                          BoldFirstText(
                              label: "Pontuação do usuário:",
                              text: item['userData']['score'].toString()),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      )),
                );
              },
            ).toList()
          ],
        ),
      ),
    );
  }
}
