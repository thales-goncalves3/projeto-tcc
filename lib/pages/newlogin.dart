// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/controllers/database_controller.dart';
import 'package:projeto_tcc/pages/partner_page.dart';
import 'package:projeto_tcc/pages/user_page.dart';

class NewLoginPage extends StatefulWidget {
  const NewLoginPage({super.key});

  @override
  State<NewLoginPage> createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Row(
        children: [
          TextFormField(
            controller: email,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Email",
                labelText: "Email"),
          ),
          TextFormField(
            controller: password,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Password",
                labelText: "Password"),
          ),
          ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final login =
                      await AuthController.login(email.text, password.text);

                  if (login) {
                    QuerySnapshot query = await DatabaseController.getUser();
                    List<QueryDocumentSnapshot> documents = query.docs;
                    var teste = documents[0].data() as Map<String, dynamic>;
                    if (teste["partner"]) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PartnerPage(),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserPage(),
                          ));
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Email ou senha errado(s)"),
                          content: const Text("Não foi possivel logar"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  email.clear();
                                  password.clear();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK"))
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: Text("Entrar"))
        ],
      ),
    );
  }
}
