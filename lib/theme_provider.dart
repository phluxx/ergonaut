import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  late SharedPreferences _prefs;
  final ThemeData darkTheme;
  final ThemeData lightTheme;

  ThemeProvider(
      {required this.darkTheme,
      required this.lightTheme,
      required SharedPreferences prefs})
      : _prefs = prefs,
        _themeData = darkTheme {
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
    final isDark = _prefs.getBool('isDark') ?? _isSystemDarkTheme();
    _themeData = isDark ? darkTheme : lightTheme;
    notifyListeners();
  }

  bool _isSystemDarkTheme() {
    if (Platform.isAndroid || Platform.isIOS) {
      // Use MediaQuery.of(context).platformBrightness for Android & iOS in main.dart
      return false; // Placeholder, actual check is done in main.dart
    } else if (Platform.isWindows) {
      final hKey = calloc<IntPtr>();
      const subKey =
          'Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize';
      var result = RegOpenKeyEx(HKEY_CURRENT_USER,
          subKey.toNativeUtf16().cast<Utf16>(), 0, KEY_READ, hKey);
      if (result == ERROR_SUCCESS) {
        final pvData = calloc<Uint32>();
        final lpcbData = calloc<Uint32>()
          ..value = 4; // Assuming DWORD (4 bytes)
        result = RegQueryValueEx(hKey.value, TEXT('AppsUseLightTheme'), nullptr,
            nullptr, pvData as Pointer<Uint8>, lpcbData);
        if (result == ERROR_SUCCESS) {
          final isLightTheme = pvData.value != 0;
          RegCloseKey(hKey.value);
          calloc.free(hKey);
          calloc.free(pvData);
          calloc.free(lpcbData);
          return !isLightTheme; // Inverts isLightTheme to match _isSystemDarkTheme logic
        }
      }
    } else if (Platform.isLinux || Platform.isMacOS) {
      // Assuming dark theme by default for Linux and macOS, adjust as needed
      return true;
    }
    return true; // Default to dark theme
  }

  void _saveTheme() {
    _prefs.setBool('isDark', _themeData == darkTheme);
  }
}
