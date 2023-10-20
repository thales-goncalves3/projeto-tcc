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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 1,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Image.asset(
                              "lib/assets/desconto.png",
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
                          SizedBox(
                            width: 500,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Esse campo é obrigatório";
                                  }

                                  return null;
                                },
                                controller: username,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  border: const OutlineInputBorder(),
                                  hintText: "Nome de usuário",
                                  prefixIcon: const Icon(Icons.person,
                                      color: Colors.black),
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
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  border: const OutlineInputBorder(),
                                  hintText: "Email",
                                  prefixIcon: const Icon(Icons.mail,
                                      color: Colors.black),
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
                                    filled: true,
                                    fillColor: Colors.grey[300],
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    border: const OutlineInputBorder(),
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

                                  if (passwordChanged !=
                                      passwordChangedConfirm) {
                                    return "As senhas devem ser iguais";
                                  }
                                  return null;
                                },
                                obscureText: visibilityConfirm,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[300],
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    border: const OutlineInputBorder(),
                                    hintText: "Confirmar Senha",
                                    prefixIcon: const Icon(Icons.lock,
                                        color: Colors.black),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          visibilityConfirm =
                                              !visibilityConfirm;
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
                                  Text(
                                    "Quero ser parceiro",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.grey[300]),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth < 512
                                ? MediaQuery.of(context).size.width * 1
                                : MediaQuery.of(context).size.width * .2,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            minimumSize: const Size(200, 60),
                                          ),
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              var result = await AuthController
                                                  .createuser(email.text,
                                                      password.text);

                                              if (result == null) {
                                                DatabaseController.createUser(
                                                    username.text,
                                                    email.text,
                                                    checkboxValue);

                                                // ignore: use_build_context_synchronously
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Colors.black,
                                                      icon: const Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                      ),
                                                      title: const Text(
                                                        "Usuário criado",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      content: const Text(
                                                        "Usuário criado com sucesso",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              email.clear();
                                                              password.clear();
                                                              username.clear();
                                                              passwordConfirm
                                                                  .clear();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const LoginPage(),
                                                                  ));
                                                            },
                                                            child: const Text(
                                                              "OK",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                // ignore: use_build_context_synchronously
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Colors.black,
                                                      icon: const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                      ),
                                                      title: const Text(
                                                        "O Email já está sendo utilizado por outra conta.",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              email.clear();
                                                              password.clear();
                                                              username.clear();
                                                              passwordConfirm
                                                                  .clear();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                              "OK",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            }
                                          },
                                          child: const Text(
                                            "Criar Conta",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Padding(
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
                                            "Login",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
