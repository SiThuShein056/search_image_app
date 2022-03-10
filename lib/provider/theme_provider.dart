import 'package:flutter/material.dart';
import 'package:search_image_app/util/shp_pref.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode tm = ThemeMode.light;
  checkThemeData() {
    SharedPref.getData(key: "theme").then((theme) {
      if (theme != null) {
        if (theme == "dark") {
          tm = ThemeMode.dark;
        } else if (theme == "light") {
          tm = ThemeMode.light;
        }
        notifyListeners();
      }
    });
  }

  changeToDark() {
    tm = ThemeMode.dark;
    SharedPref.saveData(key: "theme", value: "dark");
    notifyListeners();
  }

  changeToLight() {
    tm = ThemeMode.light;
    SharedPref.saveData(key: "theme", value: "light");
    notifyListeners();
  }
}
