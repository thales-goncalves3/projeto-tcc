import 'package:flutter/material.dart';
import 'package:projeto_tcc/pages/user_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    "/login_page": (context) => const LoginPage(),
    "/register_page": (context) => const RegisterPage(),
    "/user_page": (context) => const UserPage(),
  };

  static String initial = "/login_page";

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
