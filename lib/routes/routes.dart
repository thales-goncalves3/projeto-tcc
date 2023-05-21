import 'package:flutter/material.dart';
import 'package:projeto_tcc/pages/home_page.dart';

import '../pages/login_page.dart';
import '../pages/register_page.dart';

class Routes{
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder>{
    "/login_page": (context) => const LoginPage(),
    "/register_page": (context) => const RegisterPage(partner: null,),
    "/": (context) => const HomePage(),
  };


  static String initial = "/";

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}