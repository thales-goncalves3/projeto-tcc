import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  var mainColor = Color.fromARGB(255, 10, 92, 122);
  var appBarColor = Colors.grey[300];
  var textColor = Colors.black;
  var light = true;

  void changeColor() {
    light = !light;

    if (light) {
      mainColor = const Color(0xFF308FB1);
      appBarColor = Colors.grey[300];
      textColor = Colors.black;
    } else {
      mainColor = Colors.black;
      appBarColor = Colors.black;
      textColor = Colors.white;
    }

    notifyListeners();
  }
}
