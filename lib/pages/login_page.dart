// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/controllers/database_controller.dart';
import 'package:projeto_tcc/pages/main_page.dart';
import 'package:projeto_tcc/pages/quiz_barganha_page.dart';

import 'package:projeto_tcc/pages/register_page.dart';

import 'package:projeto_tcc/providers/change_page_provider.dart';
import 'package:provider/provider.dart';

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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "lib/assets/desconto.png",
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Quiz Barganha",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                      color: Colors.white),
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
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none),
                                      borderRadius: BorderRadius.circular(10),
                                      gapPadding: 6.0),
                                  hintText: "Email",
                                  prefixIcon: const Icon(
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
                                    filled: true,
                                    fillColor: Colors.grey[300],
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            style: BorderStyle.none),
                                        borderRadius: BorderRadius.circular(10),
                                        gapPadding: 6.0),
                                    hintText: "Senha",
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
                                        backgroundColor: Colors.green,
                                        minimumSize: const Size(200, 60),
                                      ),
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
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
                                                        const MainPage(
                                                      isPartner: true,
                                                    ),
                                                  ));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MainPage(
                                                            isPartner: false),
                                                  ));
                                              final navigationProvider =
                                                  Provider.of<
                                                          ChangePageProvider>(
                                                      context,
                                                      listen: false);
                                              navigationProvider.navigateToPage(
                                                  AppPage.UserPage);
                                            }
                                            email.clear();
                                            password.clear();
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.black,
                                                  icon: const Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                                  title: const Text(
                                                    "Email ou senha errado(s)",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  content: const Text(
                                                    "Não foi possivel logar",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          email.clear();
                                                          password.clear();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          "OK",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ))
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
                                            color: Colors.white, fontSize: 18),
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
                                                  DatabaseController.createUser(
                                                      user.displayName
                                                          .toString(),
                                                      user.email.toString(),
                                                      false)
                                                }
                                            });

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainPage(
                                                      isPartner: false),
                                            ));
                                        final navigationProvider =
                                            Provider.of<ChangePageProvider>(
                                                context,
                                                listen: false);
                                        navigationProvider
                                            .navigateToPage(AppPage.UserPage);
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
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
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
                                                  const QuizBarganhaPage(),
                                            ));
                                      },
                                      child: const Text(
                                        "Voltar",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
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
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                hintText: "Email de recuperação",
                                prefixIcon: Icon(Icons.mail),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
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
                                    color: Colors.white, fontSize: 18),
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
    );
  }
}
