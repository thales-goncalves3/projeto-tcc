import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tcc/pages/user_provider.dart';

import 'package:projeto_tcc/routes/routes.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = const ColorScheme(
      primary: Color(0xFF723172), // Cor primária
      secondary: Colors.green, // Cor secundária
      surface: Colors.white, // Cor da superfície
      background: Color(0xFF723172), // Cor de fundo
      error: Colors.red, // Cor de erro
      onPrimary: Colors.white, // Cor do texto sobre a cor primária
      onSecondary: Colors.black, // Cor do texto sobre a cor secundária
      onSurface: Colors.black, // Cor do texto sobre a cor de superfície
      onBackground: Colors.black, // Cor do texto sobre a cor de fundo
      onError: Colors.white, // Cor do texto sobre a cor de erro
      brightness: Brightness.light, // Brilho (claro ou escuro)
    );

    return MaterialApp(
      initialRoute: Routes.initial,
      onGenerateRoute: Routes.generateRoute,
      navigatorKey: Routes.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Quiz Barganha',
      theme: ThemeData(
          colorScheme: colorScheme, useMaterial3: true, fontFamily: 'Roboto'),
    );
  }
}
