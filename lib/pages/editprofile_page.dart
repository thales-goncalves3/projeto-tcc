import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  String? selectedFile;

  var alterarEmail = false;

  TextEditingController emailController = TextEditingController();

  FilePickerResult? fileResult;

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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text("Usuário: ${dadosDoUser['username']}"),
                          subtitle: TextFormField(
                            controller: usuarioController,
                            decoration: const InputDecoration(
                                hintText: "Alterar nome de Usuário"),
                          ),
                          leading: const Icon(Icons.person),
                          trailing: const Icon(Icons.edit),
                        ),
                      ),
                      ListTile(
                          title: Text("Email: ${dadosDoUser['email']}"),
                          subtitle: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                hintText: "Alterar E-mail"),
                          ),
                          leading: const Icon(Icons.mail),
                          trailing: const Icon(Icons.edit)),
                      ListTile(
                          title:
                              Text("Descrição: ${dadosDoUser['description']}"),
                          subtitle: TextFormField(
                            controller: descricaoController,
                            decoration: const InputDecoration(
                                hintText: "Alterar E-mail"),
                          ),
                          leading: const Icon(Icons.description),
                          trailing: const Icon(Icons.edit)),
                      ListTile(
                        leading: const Icon(Icons.photo),
                        title: const Text("Foto: "),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              dadosDoUser['urlPhoto'] ??
                                  "https://cdn-icons-png.flaticon.com/512/17/17004.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: () async {
                              fileResult = await FilePicker.platform.pickFiles(
                                  allowMultiple: false, type: FileType.image);
                            },
                            icon: Icon(Icons.add_a_photo)),
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
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          color: Colors.white.withOpacity(0.7),
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
                                        color: Colors.white.withOpacity(0.7),
                                        child: Center(
                                          child: SizedBox(
                                            width: 300.0,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "As alterações foram salvas!",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Provider.of<
                                                                ColorProvider>(
                                                            context)
                                                        .mainColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0),
                                                TextButton(
                                                  onPressed: () async {
                                                    try {
                                                      if (usuarioController
                                                          .text.isNotEmpty) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection("users")
                                                            .doc(AuthController
                                                                .getUserId())
                                                            .update({
                                                          'username':
                                                              usuarioController
                                                                  .text
                                                        });
                                                      }

                                                      if (descricaoController
                                                          .text.isNotEmpty) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection("users")
                                                            .doc(AuthController
                                                                .getUserId())
                                                            .update({
                                                          'description':
                                                              descricaoController
                                                                  .text
                                                        });
                                                      }

                                                      if (emailController
                                                          .text.isNotEmpty) {
                                                        User? user =
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser;

                                                        if (user != null) {
                                                          await user.updateEmail(
                                                              emailController
                                                                  .text);

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(AuthController
                                                                  .getUserId())
                                                              .update({
                                                            'email':
                                                                emailController
                                                                    .text
                                                          });
                                                        }
                                                      }

                                                      if (fileResult != null) {
                                                        print("entrou aq");

                                                        var fileBytes =
                                                            fileResult!.files
                                                                .first.bytes;
                                                        var fileName =
                                                            fileResult!.files
                                                                .first.name;

                                                        await FirebaseStorage
                                                            .instance
                                                            .ref(
                                                                'usersPhotos/${AuthController.getUserId()}')
                                                            .putData(
                                                                fileBytes!,
                                                                SettableMetadata(
                                                                    contentType:
                                                                        'image/jpeg'));

                                                        var photo =
                                                            await FirebaseStorage
                                                                .instance
                                                                .ref(
                                                                    'usersPhotos/${AuthController.getUserId()}')
                                                                .getDownloadURL();

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection("users")
                                                            .doc(AuthController
                                                                .getUserId())
                                                            .update({
                                                          'urlPhoto': photo
                                                        });
                                                      }
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                    setState(() {
                                                      descricaoController
                                                          .clear();
                                                      emailController.clear();
                                                      usuarioController.clear();
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("OK"),
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
                        ],
                      ),
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
