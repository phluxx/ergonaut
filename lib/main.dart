import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for checking saved networks
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  // Check if there are any saved networks
  final hasNetworks = await _hasSavedNetworks();

  runApp(Ergonaut(hasNetworks: hasNetworks));
}

Future<bool> _hasSavedNetworks() async {
  // Implement logic to check if any networks are saved (e.g., using shared preferences)
  // For now, assume no networks are saved
  return false;
}

class Ergonaut extends StatelessWidget {
  final bool hasNetworks;

  Ergonaut({Key? key, required this.hasNetworks}) : super(key: key);

  // Define default and dark themes
  final ThemeData _darkTheme = ThemeData.dark();
  final ThemeData _lightTheme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ergonaut',
      theme: _getTheme(context),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.7 / ( 1024 / 1080),
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  semanticsLabel: 'Ergonaut logo',
                )
              ),
              SizedBox(height: 20),
              hasNetworks
                  ? Text('Your IRC Networks') // Replace with actual UI for networks
                  : ElevatedButton(
                      onPressed: () {
                        // Handle "Add Network" button press
                      },
                      child: const Text('Add Network'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  ThemeData _getTheme(BuildContext context) {
    if (kIsWeb) {
      // Apply dark theme by default on web
      return _darkTheme;
    } else {
      final brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) {
        return _darkTheme;
      } else {
        return _lightTheme;
      }
    }
  }
}