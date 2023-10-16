import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/providers/color_provider.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Stream<DocumentSnapshot> getUser() {
    Stream<DocumentSnapshot> userStream = FirebaseFirestore.instance
        .collection("users")
        .doc(AuthController.getUserId())
        .snapshots();
    return userStream;
  }

  bool alterarUsuario = false;
  bool alterarDescricao = false;
  TextEditingController usuarioController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Não foi possivel buscar o usuario"),
          );
        }

        if (snapshot.hasData) {
          var dadosDoUser = snapshot.data!.data() as Map<String, dynamic>;

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
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.95,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("Usuário: "),
                        subtitle: alterarUsuario
                            ? TextFormField(
                                controller: usuarioController,
                                decoration: const InputDecoration(
                                    hintText: "Trocar usuário"),
                              )
                            : Text(
                                dadosDoUser['username'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                        leading: const Icon(Icons.person),
                        trailing: IconButton(
                          onPressed: () async {
                            setState(() {
                              alterarUsuario = !alterarUsuario;
                            });
                            if (usuarioController.text.isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(AuthController.getUserId())
                                  .update({'username': usuarioController.text});
                            }
                          },
                          icon: Icon(alterarUsuario ? Icons.check : Icons.edit),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Email: "),
                        subtitle: Text(dadosDoUser['email']),
                        leading: const Icon(Icons.email),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Descrição:"),
                        subtitle: alterarDescricao
                            ? TextFormField(
                                controller: descricaoController,
                                decoration: const InputDecoration(
                                    hintText: "Descrição"),
                              )
                            : Text(
                                dadosDoUser['description'] ??
                                    "Ainda não tem uma descrição",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                        leading: const Icon(Icons.description),
                        trailing: IconButton(
                          onPressed: () async {
                            setState(() {
                              alterarDescricao = !alterarDescricao;
                            });

                            if (descricaoController.text.isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(AuthController.getUserId())
                                  .update({
                                'description': descricaoController.text
                              });
                            }
                          },
                          icon:
                              Icon(alterarDescricao ? Icons.check : Icons.edit),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.photo),
                        title: const Text("Foto: "),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 2.0,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                dadosDoUser['urlPhoto'] ??
                                    "https://cdn-icons-png.flaticon.com/512/17/17004.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            // Adicione aqui a lógica para alterar a foto
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const Text('Nenhum dado encontrado');
      },
    );
  }
}
