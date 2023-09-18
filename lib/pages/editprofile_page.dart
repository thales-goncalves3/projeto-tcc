import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'dart:html';

import 'package:projeto_tcc/controllers/auth_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Stream<QuerySnapshot> getUser() {
    Stream<QuerySnapshot> userStream = FirebaseFirestore.instance
        .collection("users")
        .doc(AuthController.getUserId())
        .collection("infos")
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
          var dadosDoUser =
              snapshot.data!.docs[0].data() as Map<String, dynamic>;

          return Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              title: const Text("Editar Perfil"),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.grey[200],
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListTile(
                                title: const Text("Usuário: "),
                                subtitle: alterarUsuario
                                    ? TextFormField(
                                        controller: usuarioController,
                                        decoration: const InputDecoration(
                                            hintText: "Trocar usuário"),
                                      )
                                    : Text(dadosDoUser['username']),
                                leading: const Icon(Icons.person),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      alterarUsuario = !alterarUsuario;
                                    });
                                    if (usuarioController.text.isNotEmpty) {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(AuthController.getUserId())
                                          .collection("infos")
                                          .doc(AuthController.getUserId())
                                          .update({
                                        'username': usuarioController.text
                                      });
                                    }
                                  },
                                  child: alterarUsuario
                                      ? const Text("Confirmar")
                                      : const Text("Alterar")),
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: const Text("Email: "),
                                subtitle: Text(dadosDoUser['email']),
                                leading: const Icon(Icons.email),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                  onPressed: () {},
                                  child: const Text("Alterar")),
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                              title: const Text("Descrição:"),
                              subtitle: alterarDescricao
                                  ? TextFormField(
                                      controller: descricaoController,
                                      decoration: const InputDecoration(
                                          hintText: "Descrição"),
                                    )
                                  : Text(dadosDoUser['description'] ??
                                      "Ainda não tem uma descrição"),
                              leading: const Icon(Icons.description),
                            )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      alterarDescricao = !alterarDescricao;
                                    });

                                    if (descricaoController.text.isNotEmpty) {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(AuthController.getUserId())
                                          .collection("infos")
                                          .doc(AuthController.getUserId())
                                          .update({
                                        'description': descricaoController.text
                                      });
                                    }
                                  },
                                  child: const Text("Alterar")),
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                              title: const Text("Foto: "),
                              subtitle: Image.network(
                                dadosDoUser['urlPhoto'] ??
                                    "https://cdn-icons-png.flaticon.com/512/17/17004.png",
                                width: MediaQuery.of(context).size.width * .2,
                                height: MediaQuery.of(context).size.height * .2,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                      'Erro ao carregar a imagem');
                                },
                              ),
                            )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                  onPressed: () async {
                                    final input = FileUploadInputElement()
                                      ..accept = 'image';

                                    FirebaseStorage fs =
                                        FirebaseStorage.instance;

                                    input.click();
                                    input.onChange.listen((event) {
                                      final file = input.files!.first;
                                      final reader = FileReader();
                                      reader.readAsDataUrl(file);
                                      reader.onLoadEnd.listen((event) async {
                                        try {
                                          await fs
                                              .ref('usersPhotos')
                                              .child(AuthController.getUserId())
                                              .putBlob(file);

                                          var urlPhoto = await fs
                                              .ref('usersPhotos')
                                              .child(AuthController.getUserId())
                                              .getDownloadURL();

                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(AuthController.getUserId())
                                              .collection("infos")
                                              .doc(AuthController.getUserId())
                                              .update({'urlPhoto': urlPhoto});
                                        } catch (e) {
                                          print(FirebaseAuth
                                              .instance.currentUser!.uid);
                                          print(e);
                                        }
                                      });
                                    });
                                  },
                                  child: const Text("Alterar")),
                            )
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
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
