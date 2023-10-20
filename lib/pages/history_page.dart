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
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4, // Adicione sombreamento ao card
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BoldFirstText(
                        label: 'Título do Quiz:',
                        text: quiz['titulo'].toString(),
                      ),
                      ...quiz['perguntas'].map<Widget>((pergunta) {
                        count++;
                        return BoldFirstText(
                          label: 'Questão ${count}:',
                          text: pergunta['questao'],
                        );
                      }).toList(),
                      BoldFirstText(
                        label: 'Valor do produto:',
                        text: 'R\$ ${quiz['valorProduto']}',
                      ),
                      BoldFirstText(
                        label: 'Desconto:',
                        text: 'R\$ ${quiz['desconto']}',
                      ),
                      BoldFirstText(
                        label: 'Pontuação:',
                        text: '${data[index]['score'].toString()} pontos',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
