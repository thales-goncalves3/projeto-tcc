// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tcc/pages/history_page.dart';
import 'package:projeto_tcc/pages/qrcode_page.dart';
import 'package:projeto_tcc/pages/rank_page.dart';
import 'package:projeto_tcc/pages/user_page.dart';
import 'package:provider/provider.dart';

import 'package:projeto_tcc/controllers/auth_controller.dart';
import 'package:projeto_tcc/pages/editprofile_page.dart';
import 'package:projeto_tcc/pages/finishedquizzes_page.dart';

import 'package:projeto_tcc/pages/login_page.dart';
import 'package:projeto_tcc/pages/partner_page.dart';
import 'package:projeto_tcc/pages/quiz_page.dart';

import 'package:projeto_tcc/pages/realtimequiz_page.dart';

import 'package:projeto_tcc/pages/validate_quiz.dart';
import 'package:projeto_tcc/providers/change_page_provider.dart';
import 'package:projeto_tcc/providers/color_provider.dart';

class MainPage extends StatefulWidget {
  final bool isPartner;
  const MainPage({
    Key? key,
    required this.isPartner,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Stream<QuerySnapshot> getQuiz() {
    Stream<QuerySnapshot> quizStream = FirebaseFirestore.instance
        .collection('quizzes')
        .where('creatorUserId', isEqualTo: AuthController.getUserId())
        .snapshots();

    return quizStream;
  }

  bool light1 = true;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.sunny,
          color: Colors.black,
        );
      }
      return const Icon(Icons.nightlight_round);
    },
  );

  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<ColorProvider>(context);
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 200,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Provider.of<ColorProvider>(context).mainColor,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          child: Image.asset(
                            "lib/assets/desconto.png",
                            height: 100,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          "Quiz Barganha",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.isPartner) ...[
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () {
                    final navigationProvider =
                        Provider.of<ChangePageProvider>(context, listen: false);
                    navigationProvider.navigateToPage(AppPage.PartnerPage);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Editar Perfil"),
                  onTap: () {
                    final navigationProvider =
                        Provider.of<ChangePageProvider>(context, listen: false);
                    navigationProvider.navigateToPage(AppPage.EditProfile);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_circle),
                  title: const Text("Criar Desconto"),
                  onTap: () {
                    final navigationProvider =
                        Provider.of<ChangePageProvider>(context, listen: false);
                    navigationProvider.navigateToPage(AppPage.CreateQuiz);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle),
                  title: const Text("Validar Quiz"),
                  onTap: () {
                    final navigationProvider =
                        Provider.of<ChangePageProvider>(context, listen: false);
                    navigationProvider.navigateToPage(AppPage.ValidateQuiz);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.timelapse),
                  title: const Text("Quiz em Tempo Real"),
                  onTap: () {
                    final navigationProvider =
                        Provider.of<ChangePageProvider>(context, listen: false);
                    navigationProvider.navigateToPage(AppPage.RealtimeQuiz);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.done),
                  title: const Text("Quizzes já realizados"),
                  onTap: () {
                    final navigationProvider =
                        Provider.of<ChangePageProvider>(context, listen: false);
                    navigationProvider.navigateToPage(AppPage.FinishedQuizzes);
                  },
                ),
                const SizedBox(height: 200.0),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Sair"),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () {
                    final navigationProvider =
                        Provider.of<ChangePageProvider>(context, listen: false);
                    navigationProvider.navigateToPage(AppPage.UserPage);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.leaderboard),
                  title: const Text("Ranking"),
                  onTap: () {
                    final navigationProvider =
                        Provider.of<ChangePageProvider>(context, listen: false);
                    navigationProvider.navigateToPage(AppPage.RankPage);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text("Histórico"),
                  onTap: () {
                    final navigationProvider =
                        Provider.of<ChangePageProvider>(context, listen: false);
                    navigationProvider.navigateToPage(AppPage.HistoryPage);
                  },
                ),
                const SizedBox(height: 200.0),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Sair"),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Provider.of<ColorProvider>(context).textColor,
          ),
          backgroundColor: Provider.of<ColorProvider>(context).appBarColor,
          title: Text(
            "Quiz Barganha",
            style:
                TextStyle(color: Provider.of<ColorProvider>(context).textColor),
          ),
          actions: [
            Switch(
              activeTrackColor: Provider.of<ColorProvider>(context).mainColor,
              thumbIcon: thumbIcon,
              value: colorProvider.light,
              onChanged: (bool value) {
                setState(() {
                  light1 = value;
                  colorProvider.changeColor();
                });
              },
            ),
          ],
        ),
        body: widget.isPartner
            ? Consumer<ChangePageProvider>(
                builder: (context, navigationProvider, child) {
                  switch (navigationProvider.currentPage) {
                    case AppPage.EditProfile:
                      return const EditProfile();
                    case AppPage.CreateQuiz:
                      return const CreateQuizPage();
                    case AppPage.ValidateQuiz:
                      return const ValidateQuiz();
                    case AppPage.RealtimeQuiz:
                      return const RealtimeQuiz();
                    case AppPage.FinishedQuizzes:
                      return const FinishedQuizzes();

                    default:
                      return const PartnerPage();
                  }
                },
              )
            : Consumer<ChangePageProvider>(
                builder: (context, navigationProvider, child) {
                  switch (navigationProvider.currentPage) {
                    case AppPage.RankPage:
                      return const RankPage();
                    case AppPage.HistoryPage:
                      return const HistoryPage();
                    case AppPage.QrCodePage:
                      return const QrCodePage();
                    default:
                      return UserPage();
                  }
                },
              ));
  }
}
