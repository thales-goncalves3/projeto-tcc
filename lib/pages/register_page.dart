import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/database_controller.dart';

class RegisterPage extends StatefulWidget {
  final bool? partner;
  const RegisterPage({super.key, required this.partner});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscure = true;
  bool obscureConfirm = true;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();

  String passwordChanged = "";
  String passwordChangedConfirm = "";

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Esse campo é obrigatório";
                            }
                  
                            if (value.length < 6) {
                              return "O usuário deve ter 6 ou mais caracteres";
                            }
                  
                            return null;
                          },
                          controller: username,
                          decoration: const InputDecoration(
                            hintText: "Digite seu usuário",
                            labelText: "Usuário",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: email,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.mail),
                            hintText: "Digite seu Email",
                            labelText: "Email",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Esse campo é obrigatório";
                            }
                  
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: password,
                          obscureText: obscure,
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return "Esse campo é obrigatório";
                            }
                  
                            if (password.length < 8) {
                              return "A senha deve conter 8 ou mais digitos";
                            }
                  
                            return null;
                          },
                          onChanged: (value) => passwordChanged = value,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock),
                              hintText: "Digite sua senha",
                              labelText: "Senha",
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
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: passwordConfirm,
                          onChanged: (value) => passwordChangedConfirm = value,
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
                          obscureText: obscureConfirm,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "Confirme sua senha",
                              labelText: "Senha",
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(obscureConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    obscureConfirm = !obscureConfirm;
                                  });
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final result = await AuthController.register(
                            email.text, password.text);
      
                        if (result) {
                          
                          DatabaseController.createUser(
                              username.text, email.text, widget.partner!);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Usuário Criado")));
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(result)));
                        }
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("CADASTRAR"),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/login_page");
                    },
                    child: const Text("Já tem cadastro? Login"))
              ],
            )),
      ),
    );
  }
}
