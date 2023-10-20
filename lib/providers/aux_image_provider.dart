import 'package:flutter/material.dart';

class AuxImageProvider extends ChangeNotifier {
  ImageProvider? auxImage;

  void setErrorImage() {
    auxImage = const AssetImage("lib/assets/desconto.png");
    notifyListeners();
  }

  void setUserImage(String img) {
    auxImage = NetworkImage(img);
    notifyListeners();
  }
}
