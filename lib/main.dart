import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'themes.dart';
import 'theme_provider.dart';

void main() async {
  // Check if there are any saved networks
  final hasNetworks = await _hasSavedNetworks();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(
        darkTheme: darkErgonaut,
        lightTheme: lightErgonaut,
      ),
      child: Ergonaut(hasNetworks: hasNetworks),
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
class Ergonaut extends StatelessWidget {
  final bool hasNetworks;

  Ergonaut({Key? key, required this.hasNetworks}) : super(key: key);

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
                          Provider.of<ThemeProvider>(context, listen: false).setLightTheme();
                        } else if (value == ThemeOption.dark) {
                          Provider.of<ThemeProvider>(context, listen: false).setDarkTheme();
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeOption>>[
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
                        height: MediaQuery.of(context).size.height * 0.7 / ( 1024 / 1080),
                        child: SvgPicture.asset(
                          'assets/logo.svg',
                          semanticsLabel: 'Ergonaut logo',
                      ),
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
           ],
         ),
       ),
      ),
    );
  }
}