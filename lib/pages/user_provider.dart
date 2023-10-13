import 'package:flutter/material.dart';

import 'package:projeto_tcc/controllers/database_controller.dart';

class UserProvider with ChangeNotifier {
  var infos;

  initUser() async {
    infos = await DatabaseController.getUserInfos();
    notifyListeners();
  }
}
