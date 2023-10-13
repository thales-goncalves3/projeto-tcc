import 'package:flutter/material.dart';

import 'package:projeto_tcc/controllers/database_controller.dart';

import 'package:projeto_tcc/pages/login_page.dart';

import 'package:string_validator/string_validator.dart';

import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool visibility = true;
  bool visibilityConfirm = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  bool checkboxValue = false;

  String passwordChanged = "";
  String passwordChangedConfirm = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        height: MediaQuery.of(context).size.height * 1,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Image.asset(
                          "lib/assets/desconto-icon-preto.png",
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "QuizBarganha",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 26),
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: username,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(),
                              hintText: "Nome de usuário",
                              labelText: "Nome de usuário",
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Esse campo é obrigatório";
                              }

                              if (!isEmail(value)) {
                                return "Esse campo deve ser do tipo email";
                              }

                              return null;
                            },
                            controller: email,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(),
                              hintText: "Email",
                              labelText: "Email",
                              prefixIcon: Icon(Icons.mail, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (value) => passwordChanged = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Esse campo é obrigatório";
                              }

                              if (passwordChanged.length < 8) {
                                return "A senha deve conter 8 ou mais digitos";
                              }

                              return null;
                            },
                            controller: password,
                            obscureText: visibility,
                            decoration: InputDecoration(
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                border: const OutlineInputBorder(),
                                hintText: "Senha",
                                labelText: "Senha",
                                prefixIcon:
                                    const Icon(Icons.lock, color: Colors.black),
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
                      SizedBox(
                        width: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (value) =>
                                passwordChangedConfirm = value,
                            controller: passwordConfirm,
                            validator: (passwordConfirm) {
                              if (passwordConfirm == null ||
                                  passwordConfirm.isEmpty) {
                                return "Esse campo é obrigatório";
                              }

                              if (passwordConfirm.length < 8) {
                                return "A senha deve conter 8 ou mais digitos";
                              }

                              if (passwordChanged != passwordChangedConfirm) {
                                return "As senhas devem ser iguais";
                              }
                              return null;
                            },
                            obscureText: visibilityConfirm,
                            decoration: InputDecoration(
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                border: const OutlineInputBorder(),
                                hintText: "Confirmar Senha",
                                labelText: "Confirmar Senha",
                                prefixIcon:
                                    const Icon(Icons.lock, color: Colors.black),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      visibilityConfirm = !visibilityConfirm;
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
                      SizedBox(
                        width: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                activeColor: Colors.black,
                                value: checkboxValue,
                                onChanged: (value) {
                                  setState(() {
                                    checkboxValue = value!;
                                  });
                                },
                              ),
                              const Text(
                                "Quero ser parceiro",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    minimumSize: const Size(200, 60),
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      var result =
                                          await AuthController.createuser(
                                              email.text, password.text);

                                      if (result == null) {
                                        DatabaseController.createUser(
                                            username.text,
                                            email.text,
                                            checkboxValue);

                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text("Usuário Criado")));
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text(result.toString())));
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Criar Conta",
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ));
                                  },
                                  child: const Text(
                                    "Voltar para o Login",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
