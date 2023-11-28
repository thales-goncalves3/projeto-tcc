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
                return Center(
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.grey[300],
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text(
                            "Quiz: ${item['data']['titulo']}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  "Valor do produto: R\$${item['data']['valorProduto']}"),
                              Text(
                                  "Valor do desconto: ${item['data']['desconto']}%"),
                              Text(
                                  "Valor final: R\$ ${double.parse(item['data']['valorProduto']) - (double.parse(item['data']['valorProduto']) * (int.parse(item['data']['desconto']) / 100))}"),
                              Text("Usuário: ${item['userData']['username']}"),
                              Text(
                                  "Pontuação do usuário: ${item['userData']['score'].toString()}"),
                            ],
                          ),
                        )),
                  ),
                );
              },
            ).toList()
          ],
        ),
      ),
    );
  }
}
