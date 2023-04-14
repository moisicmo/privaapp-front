import 'package:flutter/material.dart';
import 'package:privaap/models/user_model.dart';

class UserData with ChangeNotifier {
  UserModel? userData;
  updateUserData(UserModel value) async {
    await Future.delayed(const Duration(milliseconds: 50), () {});
    userData = value;
    notifyListeners();
  }

  updateImage(String value) async {
    await Future.delayed(const Duration(milliseconds: 50), () {});
    UserModel user = userData!.copyWith(avatar: value);
    userData = user;
    notifyListeners();
  }
}

class SizeScreenModal with ChangeNotifier {
  double sizeScreen = 2.0;
  updateSizeScreen(double value) {
    sizeScreen = value;
    notifyListeners();
  }
}

class StateTutorial with ChangeNotifier {
  bool stateTutorial = false;
  updateStateTutorial(bool data) {
    stateTutorial = data;
    notifyListeners();
  }
}
