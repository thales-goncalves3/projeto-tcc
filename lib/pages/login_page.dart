// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/controllers/database_controller.dart';
import 'package:projeto_tcc/pages/partner_page.dart';
import 'package:projeto_tcc/pages/register_page.dart';
import 'package:projeto_tcc/pages/user_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Center(
            child: Column(
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
                        final login = await AuthController.login(
                            email.text, password.text);

                        if (login) {
                          QuerySnapshot query =
                              await DatabaseController.getUser();
                          List<QueryDocumentSnapshot> documents = query.docs;
                          var teste =
                              documents[0].data() as Map<String, dynamic>;
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
                    child: const Text("Entrar")),
                ElevatedButton(
                  onPressed: () async {
                    // final FirebaseAuth _auth = FirebaseAuth.instance;
                    // final GoogleSignIn _googleSignIn = GoogleSignIn();

                    // Future<User?> signInWithGoogle() async {
                    //   try {
                    //     final GoogleSignInAccount? googleSignInAccount =
                    //         await _googleSignIn.signIn();

                    //     if (googleSignInAccount != null) {
                    //       final GoogleSignInAuthentication
                    //           googleSignInAuthentication =
                    //           await googleSignInAccount.authentication;

                    //       final AuthCredential credential =
                    //           GoogleAuthProvider.credential(
                    //         accessToken: googleSignInAuthentication.accessToken,
                    //         idToken: googleSignInAuthentication.idToken,
                    //       );

                    //       final UserCredential authResult =
                    //           await _auth.signInWithCredential(credential);
                    //       final User? user = authResult.user;
                    //       print(user);
                    //       return user;
                    //     }

                    //     return null;
                    //   } catch (e) {
                    //     print(e.toString());
                    //     return null;
                    //   }
                    // }
                  },
                  child: const Text("Entrar com o Google"),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ));
                    },
                    child: Text("Cadastrar"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
