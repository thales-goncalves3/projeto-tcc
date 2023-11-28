import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_tcc/pages/quiz_barganha_page.dart';
import 'package:projeto_tcc/providers/aux_image_provider.dart';
import 'package:projeto_tcc/providers/change_page_provider.dart';
import 'package:projeto_tcc/providers/color_provider.dart';
import 'package:projeto_tcc/providers/user_provider.dart';

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
      ),
      ChangeNotifierProvider(
        create: (context) => ColorProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ChangePageProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => AuxImageProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = ColorScheme(
      primary: Provider.of<ColorProvider>(context).mainColor,
      secondary: Colors.green,
      surface: Colors.grey[300]!,
      background: Provider.of<ColorProvider>(context).mainColor,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.red,
      brightness: Brightness.light,
    );

    ThemeData meuTema = ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme());

    return MaterialApp(
      home: const QuizBarganhaPage(),
      onGenerateRoute: Routes.generateRoute,
      navigatorKey: Routes.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Quiz Barganha',
      theme: meuTema,
    );
  }
}
