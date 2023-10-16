import 'package:flutter/material.dart';

import 'package:projeto_tcc/controllers/database_controller.dart';

class UserProvider with ChangeNotifier {
  var infos;
  var data;

  initUser() async {
    infos = await DatabaseController.getUserInfos();
    notifyListeners();
  }

  changeData(userInfos) {
    data = userInfos;
    notifyListeners();
  }
}
