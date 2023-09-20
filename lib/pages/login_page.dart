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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.network(
                "https://cdn-icons-png.flaticon.com/512/5009/5009570.png",
                width: 100,
                height: 100,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "QuizBarganha",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
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
                                prefixIcon: Icon(Icons.mail),
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
                                  border: const OutlineInputBorder(),
                                  hintText: "Senha",
                                  labelText: "Senha",
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        visibility = !visibility;
                                      });
                                    },
                                    icon: visibility
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                  )),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedButton(
                                  animatedOn: AnimatedOn.onHover,
                                  height: 40,
                                  width: 130,
                                  text: "Entrar",
                                  isReverse: true,
                                  selectedTextColor: Colors.black,
                                  transitionType: TransitionType.LEFT_TO_RIGHT,
                                  backgroundColor: Colors.black,
                                  borderColor: Colors.white,
                                  borderRadius: 5,
                                  borderWidth: 2,
                                  onPress: () async {
                                    if (formKey.currentState!.validate()) {
                                      final login = await AuthController.login(
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("OK"))
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
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
                                                    user.displayName.toString(),
                                                    user.email.toString(),
                                                    false)
                                              }
                                          });

                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => const UserPage(),
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
                                    child: const Text("Esqueceu a senha?")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedButton(
                                  text: 'Cadastrar',
                                  animatedOn: AnimatedOn.onHover,
                                  height: 40,
                                  width: 200,
                                  isReverse: true,
                                  selectedTextColor: Colors.black,
                                  transitionType: TransitionType.LEFT_TO_RIGHT,
                                  backgroundColor: Colors.black,
                                  borderColor: Colors.white,
                                  borderRadius: 5,
                                  borderWidth: 2,
                                  onPress: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage(),
                                        ));
                                  },
                                ),
                              ),
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
                        child: AnimatedButton(
                          text: "Enviar",
                          animatedOn: AnimatedOn.onHover,
                          height: 40,
                          width: 200,
                          isReverse: true,
                          selectedTextColor: Colors.black,
                          transitionType: TransitionType.LEFT_TO_RIGHT,
                          backgroundColor: Colors.black,
                          borderColor: Colors.white,
                          borderRadius: 5,
                          borderWidth: 2,
                          onPress: () async {
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedButton(
                          text: "Voltar",
                          animatedOn: AnimatedOn.onHover,
                          height: 40,
                          width: 200,
                          isReverse: true,
                          selectedTextColor: Colors.black,
                          transitionType: TransitionType.LEFT_TO_RIGHT,
                          backgroundColor: Colors.black,
                          borderColor: Colors.white,
                          borderRadius: 5,
                          borderWidth: 2,
                          onPress: () async {
                            setState(() {
                              esqueceuASenha = !esqueceuASenha;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
