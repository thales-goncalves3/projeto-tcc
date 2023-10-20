import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:projeto_tcc/controllers/database_controller.dart';
import 'package:projeto_tcc/pages/login_page.dart';
import 'package:projeto_tcc/pages/main_page.dart';
import 'package:projeto_tcc/pages/register_page.dart';
import 'package:projeto_tcc/providers/change_page_provider.dart';
import 'package:projeto_tcc/providers/color_provider.dart';
import 'package:provider/provider.dart';

class QuizBarganhaPage extends StatelessWidget {
  const QuizBarganhaPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < 512
            ? Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Bem-vindo ao Quiz Barganha - O Caminho Divertido para Descontos Incríveis!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[300]),
                          ),
                        ),
                        Image.asset("lib/assets/desconto.png"),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 1,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Você já imaginou transformar a diversão em economia? Com o Quiz Barganha, a jornada para adquirir seus produtos favoritos com descontos exclusivos se torna uma experiência empolgante e cativante. Este é o lugar onde entretenimento e compras se unem para redefinir a forma como você economiza.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[300]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    minimumSize: const Size(200, 60),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ));
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      minimumSize: const Size(200, 60),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage(),
                                      ));
                                    },
                                    child: const Text(
                                      "Cadastro",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 8,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            "Bem-vindo ao Quiz Barganha - O Caminho Divertido para Descontos Incríveis!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[300]),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Image.asset("lib/assets/desconto.png"),
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .5,
                          child: Text(
                            "Você já imaginou transformar a diversão em economia? Com o Quiz Barganha, a jornada para adquirir seus produtos favoritos com descontos exclusivos se torna uma experiência empolgante e cativante. Este é o lugar onde entretenimento e compras se unem para redefinir a forma como você economiza.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[300]),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            minimumSize: const Size(200, 60),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(200, 60),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ));
                          },
                          child: const Text(
                            "Cadastro",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
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

                              if (FirebaseAuth.instance.currentUser != null) {
                                final user = FirebaseAuth.instance.currentUser;

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

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MainPage(isPartner: false),
                                    ));
                                final navigationProvider =
                                    Provider.of<ChangePageProvider>(context,
                                        listen: false);
                                navigationProvider
                                    .navigateToPage(AppPage.UserPage);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    ));
  }
}
