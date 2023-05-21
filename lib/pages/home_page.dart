import 'package:flutter/material.dart';
import 'package:projeto_tcc/pages/register_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Column(children: [
      ElevatedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage(partner: false,),));
      }, child: const Text("Entrar como usuário")),
      ElevatedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage(partner: true,),));
      }, child: const Text("Entrar como parceerio"))
    ],),);
  }
}