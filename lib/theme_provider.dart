import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;
  late SharedPreferences _prefs;
  final ThemeData darkTheme;
  final ThemeData lightTheme;

  ThemeProvider({required this.darkTheme, required this.lightTheme}) {
    _themeData = darkTheme;
    _loadTheme();
  }

  ThemeData getTheme() => _themeData;

  void toggleTheme() {
    _themeData = _themeData == lightTheme ? darkTheme : lightTheme;
    _saveTheme();
    notifyListeners();
  }

  void setLightTheme() {
    _themeData = lightTheme;
    _saveTheme();
    notifyListeners();
  }

  void setDarkTheme() {
    _themeData = darkTheme;
    _saveTheme();
    notifyListeners();
  }

  void _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final isDark = _prefs.getBool('isDark') ?? false;
    _themeData = isDark ? darkTheme : lightTheme;
    notifyListeners();
  }

  void _saveTheme() {
    _prefs.setBool('isDark', _themeData == darkTheme);
  }
}
