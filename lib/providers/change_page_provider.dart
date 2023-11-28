import 'package:flutter/material.dart';

enum AppPage {
  PartnerPage,
  EditProfile,
  ValidateQuiz,
  History,
  CreateQuiz,
  RealtimeQuiz,
  FinishedQuizzes,
  RankPage,
  HistoryPage,
  UserPage,
  QrCodePage,
  UserPerfil
}

class ChangePageProvider with ChangeNotifier {
  AppPage _currentPage = AppPage.PartnerPage;

  AppPage get currentPage => _currentPage;

  void navigateToPage(AppPage page) {
    _currentPage = page;
    notifyListeners();
  }
}
