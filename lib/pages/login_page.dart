// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
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
  TextEditingController emailConfirmacao = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  bool esqueceuASenha = false;
  bool visibility = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "lib/assets/desconto-icon-preto.png",
                    width: 100,
                    height: 100,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Quiz Barganha",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                    ),
                  ),
                ),
                !esqueceuASenha
                    ? Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 500,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: email,
                                  decoration: const InputDecoration(
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(),
                                    hintText: "Email",
                                    labelText: "Email",
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 500,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: password,
                                  obscureText: visibility,
                                  decoration: InputDecoration(
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                      border: const OutlineInputBorder(),
                                      hintText: "Senha",
                                      labelText: "Senha",
                                      prefixIcon: const Icon(Icons.lock,
                                          color: Colors.black),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            visibility = !visibility;
                                          });
                                        },
                                        icon: visibility
                                            ? const Icon(Icons.visibility_off,
                                                color: Colors.black)
                                            : const Icon(Icons.visibility,
                                                color: Colors.black),
                                      )),
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[300],
                                          minimumSize: const Size(200, 60),
                                        ),
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            final login =
                                                await AuthController.login(
                                                    email.text, password.text);

                                            if (login) {
                                              bool isPartner =
                                                  await DatabaseController
                                                      .isPartner();

                                              if (isPartner) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const PartnerPage(),
                                                    ));
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const UserPage(),
                                                    ));
                                              }
                                              email.clear();
                                              password.clear();
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Email ou senha errado(s)"),
                                                    content: const Text(
                                                        "Não foi possivel logar"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            email.clear();
                                                            password.clear();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text("OK"))
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          }
                                        },
                                        child: const Text(
                                          "Entrar",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SignInButton(
                                      Buttons.Google,
                                      onPressed: () async {
                                        GoogleAuthProvider googleProvider =
                                            GoogleAuthProvider();
                                        googleProvider.setCustomParameters(
                                            {'login_hint': 'user@example.com'});

                                        await FirebaseAuth.instance
                                            .signInWithPopup(googleProvider);

                                        if (FirebaseAuth.instance.currentUser !=
                                            null) {
                                          final user =
                                              FirebaseAuth.instance.currentUser;

                                          final db = FirebaseFirestore.instance;

                                          final docRef = db
                                              .collection("users")
                                              .doc(user!.uid)
                                              .collection("infos");

                                          docRef.get().then((doc) => {
                                                if (doc.docs.isEmpty)
                                                  {
                                                    DatabaseController
                                                        .createUser(
                                                            user.displayName
                                                                .toString(),
                                                            user.email
                                                                .toString(),
                                                            false)
                                                  }
                                              });

                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                const UserPage(),
                                          ));
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            esqueceuASenha = !esqueceuASenha;
                                          });
                                        },
                                        child: const Text(
                                          "Esqueceu a senha?",
                                          style: TextStyle(color: Colors.blue),
                                        )),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[300],
                                          minimumSize: const Size(200, 60),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const RegisterPage(),
                                              ));
                                        },
                                        child: const Text(
                                          "Cadastrar",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 500,
                              child: TextFormField(
                                controller: emailConfirmacao,
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(),
                                  hintText: "Email de recuperação",
                                  labelText: "Email de recuperação",
                                  prefixIcon: Icon(Icons.mail),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                  minimumSize: const Size(200, 60),
                                ),
                                onPressed: () async {
                                  try {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: emailConfirmacao.text);
                                  } catch (e) {
                                    SnackBar(content: Text(e.toString()));
                                  }

                                  emailConfirmacao.clear();
                                  setState(() {
                                    esqueceuASenha = !esqueceuASenha;
                                  });
                                },
                                child: const Text(
                                  "Enviar",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                  minimumSize: const Size(200, 60),
                                ),
                                onPressed: () {
                                  setState(() {
                                    esqueceuASenha = !esqueceuASenha;
                                  });
                                },
                                child: const Text(
                                  "Voltar",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              )),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
