import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                                subtitle: Text(dadosDoUser['username']),
                                leading: const Icon(Icons.person),
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
                              subtitle: Text(dadosDoUser['descricao'] ??
                                  "Ainda não tem uma descrição"),
                              leading: const Icon(Icons.description),
                            )),
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
                              title: const Text("Foto: "),
                              subtitle: Image.network(
                                dadosDoUser['urlPhoto'] ??
                                    "https://cdn-icons-png.flaticon.com/512/17/17004.png",
                                width: MediaQuery.of(context).size.width * .2,
                                height: MediaQuery.of(context).size.height * .2,
                              ),
                            )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                  onPressed: () {},
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
