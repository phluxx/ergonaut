import 'package:flutter/material.dart';

final ThemeData lightErgonaut = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    secondary: Color(0xFF529F28),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return Color(0xFF529F28).withOpacity(0.8);
          }
          return Color(0xFF529F28);
        },
      ),
    ),
  ),
);

final ThemeData darkErgonaut = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF121212),
    secondary: Color(0xFFA9E34C),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return Color(0xFFA9E34C).withOpacity(0.8); // Brighter color on hover
          }
          return Color(0xFFA9E34C); // Normal color
        },
      ),
    ),
  ),
);