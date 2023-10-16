import 'package:flutter/material.dart';
import 'package:projeto_tcc/pages/user_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/login_page":
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case "/register_page":
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case "/user_page":
        return MaterialPageRoute(builder: (_) => UserPage());
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }

  static String initial = "/login_page";

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
