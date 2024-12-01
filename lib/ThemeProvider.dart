import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _preferences;
  bool _darkMode = false;
  bool get darkMode => _darkMode;
  late Color labelColor;
  late Color unselectedLabelColor;
 late Color dividerColor;
 late Color appBarColor;
 late Color btnColor;
 late Color boxColor;
 late Color iconColor;
 late Color textColor;
 late Color textColor2;
 late Color borderColor;
 late Color fillColor;
 late Color focusColor;
 late Color boxShadowColor;
 late Color cartButtonColor;
  ThemeProvider() {
    loadThemeData();
  }

  _savePreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
    _preferences!.setBool(key, _darkMode);
  }

  loadThemeData() async {
    _preferences ??= await SharedPreferences.getInstance();
    _darkMode = _preferences!.getBool(key) ?? true;
    labelColor = (_darkMode) ? const Color(0xffFFFFFF) : const Color(0xff212121); //DisableColor, appBarTextColor
    unselectedLabelColor = (_darkMode) ? const Color(0xffFFFFFF) : const Color(0xff212121);
    dividerColor = (_darkMode) ? Colors.white : Colors.black38;
    appBarColor = (_darkMode) ? const Color(0xff1A1D22) : Colors.white;
    btnColor = (_darkMode) ? const Color(0xffFFFFFF) : const Color(0xff212121);
    boxColor = (_darkMode) ? const Color(0xff31373E) : const Color(0xffFFFFFF);
    iconColor = (_darkMode) ? const Color(0xffFFFFFF) : const Color(0xff212121);
    textColor = (_darkMode) ? const Color(0xffFFFFFF) : const Color(0xff212121);
    textColor2 = (_darkMode) ? const Color(0xffFED931) : const Color(0xff212121);
    borderColor = (_darkMode) ? const Color(0xffFFFFFF) : Colors.grey;
    fillColor = (_darkMode) ? const Color(0xff1A1D22) : Colors.white;
    focusColor = (_darkMode) ? const Color(0xff1A1D22) : Colors.white;
    boxShadowColor = (_darkMode) ? Colors.transparent : Colors.grey;
    cartButtonColor= (_darkMode) ?const Color(0xffFFA500):const Color(0xffFFA500);
    notifyListeners();
  }

  void toggleTheme(bool isOn) {
    darkMode==isOn ? _darkMode: _darkMode = !_darkMode;
    _savePreferences();
    notifyListeners();
  }
}