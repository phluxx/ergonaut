import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'themes.dart';
import 'theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure plugin services are initialized
  final prefs = await SharedPreferences
      .getInstance(); // Await the SharedPreferences instance

  final hasNetworks = await _hasSavedNetworks();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(
        darkTheme: darkErgonaut,
        lightTheme: lightErgonaut, prefs: prefs, // Use the awaited prefs
      ),
      child: Ergonaut(hasNetworks: hasNetworks, themeMode: ThemeMode.system),
    ),
  );
}

Future<bool> _hasSavedNetworks() async {
  // Implement logic to check if any networks are saved (e.g., using shared preferences)
  // For now, assume no networks are saved
  return false;
}

enum ThemeOption {
  light,
  dark,
}

class Ergonaut extends StatefulWidget {
  // Changed to StatefulWidget
  final bool hasNetworks;
  final ThemeMode themeMode; // Added

  Ergonaut(
      {Key? key, required this.hasNetworks, this.themeMode = ThemeMode.dark})
      : super(key: key); // Updated

  @override
  _ErgonautState createState() => _ErgonautState();
}

class _ErgonautState extends State<Ergonaut> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTheme();
    });
  }

  void _updateTheme() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (brightness == Brightness.dark) {
      Provider.of<ThemeProvider>(context, listen: false).setDarkTheme();
    } else {
      Provider.of<ThemeProvider>(context, listen: false).setLightTheme();
    }
  }

  @override
  void didChangePlatformBrightness() {
    _updateTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ergonaut',
      theme: Provider.of<ThemeProvider>(context).getTheme(),
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  PopupMenuButton<ThemeOption>(
                    onSelected: (ThemeOption value) {
                      if (value == ThemeOption.light) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .setLightTheme();
                      } else if (value == ThemeOption.dark) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .setDarkTheme();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<ThemeOption>>[
                      const PopupMenuItem<ThemeOption>(
                        value: ThemeOption.light,
                        child: Text('Light Theme'),
                      ),
                      const PopupMenuItem<ThemeOption>(
                        value: ThemeOption.dark,
                        child: Text('Dark Theme'),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height *
                          0.7 /
                          (1024 / 1080),
                      child: SvgPicture.asset(
                        'assets/logo.svg',
                        semanticsLabel: 'Ergonaut logo',
                      ),
                    ),
                    SizedBox(height: 20),
                    widget.hasNetworks
                        ? Text(
                            'Your IRC Networks') // Replace with actual UI for networks
                        : ElevatedButton(
                            onPressed: () {
                              // Handle "Add Network" button press
                            },
                            child: const Text('Add Network'),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
