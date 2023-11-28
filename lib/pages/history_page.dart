import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/widgets/customtext_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List historyList = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('history')
          .where('user', isEqualTo: AuthController.getUserId())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }

        final data = snapshot.data?.docs;

        if (data == null || data.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum quiz realizado ainda.',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final quiz = data[index]['quiz'];
            var count = 0;

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                child: Card(
                  elevation: 8,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          'Título do Quiz: ${quiz['titulo'].toString()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ...quiz['perguntas'].map<Widget>((pergunta) {
                              count++;
                              return Text(
                                  "Questão $count: ${pergunta['questao']}");
                            }).toList(),
                            Text(
                                'Valor do produto: R\$ ${quiz['valorProduto']}'),
                            Text('Desconto: ${quiz['desconto']}%'),
                            Text(
                                'Pontuação: ${data[index]['score'].toString()} pontos'),
                            Text('Data da realização: ${data[index]['date']}')
                          ],
                        ),
                      )),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
