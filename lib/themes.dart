import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    secondary: Color(0xFF529F28),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF121212),
    secondary: Color(0xFFA9E34C),
  ),
);

class CustomButtonStyle {
  static ButtonStyle buttonStyle(BuildContext context) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            // Brighten the accent color when hovered over
            return Theme.of(context).colorScheme.secondary.withOpacity(0.8);
          }
          return Theme.of(context).colorScheme.secondary;
        },
      ),
    );
  }
}
