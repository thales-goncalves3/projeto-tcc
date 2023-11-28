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
        bool finished = qrcodeData['finished'] ?? false;
        if (!finished &&
            validate &&
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
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 5)),
      builder: (context, snapshot) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          child: Center(
              child: qrcodesList.isEmpty
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "Ainda não há quizzes sendo realizados",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: ListView(
                        children: [
                          ...qrcodesList.map((item) {
                            return Center(
                              child: Card(
                                elevation: 4,
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text(
                                    item['data']['titulo'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        "Pontuação do usuário: ${item['userData']['score']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    )),
        );
      },
    );
  }
}
