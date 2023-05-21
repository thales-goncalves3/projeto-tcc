import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tcc/controllers/database_controller.dart';
import 'package:projeto_tcc/pages/home_page.dart';
import 'package:projeto_tcc/pages/partner_page.dart';
import 'package:projeto_tcc/pages/register_page.dart';
import 'package:projeto_tcc/pages/user_page.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var obscure = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalKey formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            border: OutlineInputBorder(),
                            hintText: "Email",
                            labelText: "Email"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: password,
                        obscureText: obscure,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "Senha",
                            labelText: "Senha",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final login =
                          await AuthController.login(email.text, password.text);

                      if (login) {
                        QuerySnapshot query =
                            await DatabaseController.getUser();
                        List<QueryDocumentSnapshot> documents = query.docs;
                        var teste = documents[0].data() as Map<String, dynamic>;
                        if(teste["partner"]){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PartnerPage(),));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const UserPage(),));
                        }
                      }

                      // if (login == null) {
                      //   // ignore: use_build_context_synchronously

                      // } else {
                      //   // ignore: use_build_context_synchronously
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         title: const Text("Error"),
                      //         content: Text(login),
                      //         actions: [
                      //           TextButton(
                      //               onPressed: () {
                      //                 Navigator.of(context).pop();
                      //               },
                      //               child: const Text("OK"))
                      //         ],
                      //       );
                      //     },
                      //   );
                      // }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("LOGAR"),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ));
                    },
                    child: const Text("Não tem cadastro? Cadastrar")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
