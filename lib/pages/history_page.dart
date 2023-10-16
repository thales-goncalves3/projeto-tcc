import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';

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

            return Card(
              margin: const EdgeInsets.all(20),
              child: ListTile(
                title: Text(
                  quiz['titulo'].toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: quiz['perguntas'].map<Widget>((pergunta) {
                          final opcaoCorreta = pergunta['correta'] + 1;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Questão: ${pergunta['questao']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Correta: Opção ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '$opcaoCorreta',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Valor do produto: R\$ ${quiz['valorProduto']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Desconto: R\$ ${quiz['desconto']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Pontuação: ${data[index]['score'].toString()} pontos',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
