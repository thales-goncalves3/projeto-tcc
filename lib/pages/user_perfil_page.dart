import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/providers/change_page_provider.dart';
import 'package:projeto_tcc/providers/color_provider.dart';
import 'package:provider/provider.dart';

class UserPerfil extends StatefulWidget {
  const UserPerfil({super.key});

  @override
  State<UserPerfil> createState() => _UserPerfilState();
}

class _UserPerfilState extends State<UserPerfil> {
  bool alterarUsuario = false;

  bool alterarEmail = false;

  Stream<DocumentSnapshot> getUser() {
    Stream<DocumentSnapshot> userStream = FirebaseFirestore.instance
        .collection("users")
        .doc(AuthController.getUserId())
        .snapshots();
    return userStream;
  }

  bool infos = false;

  TextEditingController usuarioController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          Map<String, dynamic> userInfos =
              snapshot.data!.data() as Map<String, dynamic>;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Bem vindo, ${userInfos['username']}!",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      infos
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        "Usuário: ${userInfos['username']}"),
                                    subtitle: TextFormField(
                                      controller: usuarioController,
                                      decoration: const InputDecoration(
                                          hintText: "Alterar nome de Usuário"),
                                    ),
                                    leading: const Icon(Icons.person),
                                    trailing: const Icon(Icons.edit),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListTile(
                                      title:
                                          Text("Email: ${userInfos['email']}"),
                                      subtitle: TextFormField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                            hintText: "Alterar E-mail"),
                                      ),
                                      leading: const Icon(Icons.mail),
                                      trailing: const Icon(Icons.edit)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () async {
                                          // ignore: use_build_context_synchronously
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return FutureBuilder(
                                                future: Future.delayed(
                                                    const Duration(seconds: 3)),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Container(
                                                      color: Colors.white
                                                          .withOpacity(0.7),
                                                      child: const Center(
                                                        child: SizedBox(
                                                          height: 100.0,
                                                          width: 100.0,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return Container(
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                    child: Center(
                                                      child: SizedBox(
                                                        width: 300.0,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "As alterações foram salvas!",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color: Provider.of<
                                                                            ColorProvider>(
                                                                        context)
                                                                    .mainColor,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 20.0),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  if (usuarioController
                                                                      .text
                                                                      .isNotEmpty) {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "users")
                                                                        .doc(AuthController
                                                                            .getUserId())
                                                                        .update({
                                                                      'username':
                                                                          usuarioController
                                                                              .text
                                                                    });
                                                                  }

                                                                  if (emailController
                                                                      .text
                                                                      .isNotEmpty) {
                                                                    User? user =
                                                                        FirebaseAuth
                                                                            .instance
                                                                            .currentUser;

                                                                    if (user !=
                                                                        null) {
                                                                      await user
                                                                          .updateEmail(
                                                                              emailController.text);

                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "users")
                                                                          .doc(AuthController
                                                                              .getUserId())
                                                                          .update({
                                                                        'email':
                                                                            emailController.text
                                                                      });
                                                                    }
                                                                  }
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                                setState(() {
                                                                  infos =
                                                                      !infos;

                                                                  emailController
                                                                      .clear();
                                                                  usuarioController
                                                                      .clear();
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  "OK"),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: const Text(
                                          "Salvar",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            infos = !infos;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        child: const Text(
                                          "Voltar",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Sua pontuação é ${userInfos['score']} pontos",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Você realizou ${userInfos['countQuiz'] ?? 0} quiz(zes)",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Economizou: R\$ ${userInfos['savedMoney'] ?? 0} reais",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            infos = !infos;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          "Alterar informações",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          final navigationProvider =
                                              Provider.of<ChangePageProvider>(
                                                  context,
                                                  listen: false);
                                          navigationProvider.navigateToPage(
                                              AppPage.HistoryPage);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          "Ver seu histórico",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const Text("");
      },
    );
  }
}
