import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:skriftes_project/src/palette/color_repository.dart';

import 'letter/letterView.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    Key? key, // Added a key parameter
    required this.settingsController,
  }) : super(key: key); // Added super constructor

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double toolbarHeight = kToolbarHeight;
    return ListenableBuilder(
      // Utilized ListenableBuilder for dynamic updates
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          theme:
              ThemeData(), // No explicit theme defined, relying on default theme
          darkTheme: ThemeData.dark(),
          themeMode: widget.settingsController.themeMode,
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(toolbarHeight),
              child: Container(
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(41, 0, 0, 0),
                    offset: Offset(0, 2.0),
                    blurRadius: 4.0,
                  )
                ]),
                child: AppBar(
                  centerTitle: true,
                  toolbarHeight: toolbarHeight,
                  backgroundColor: ColorRepository.getColor(
                  ColorName.primaryColor, widget.settingsController.themeMode),
                  title: Image.asset(
                    widget.settingsController.themeMode == ThemeMode.light
                        ? 'assets/images/logo.png'
                        : widget.settingsController.themeMode == ThemeMode.dark
                            ? 'assets/images/dark_logo.png'
                            : 'assets/images/logo.png',
                    width: 180,
                    semanticLabel: 'Scrifte\'s logo',
                  ),
                ),
              ),
            ),
            body: _selectedIndex ==
                    0 // Ternary operator for conditional rendering
                ? LetterView(controller: widget.settingsController)
                : SettingsView(controller: widget.settingsController),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Opciones',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: ColorRepository.getColor(
                  ColorName.primaryColor, widget.settingsController.themeMode),
              selectedItemColor: ColorRepository.getColor(
                  ColorName.specialColor, widget.settingsController.themeMode),
              unselectedItemColor: ColorRepository.getColor(
                  ColorName.textColor, widget.settingsController.themeMode),
              selectedLabelStyle: TextStyle(
                  color: ColorRepository.getColor(ColorName.specialColor,
                      widget.settingsController.themeMode)),
              unselectedLabelStyle: TextStyle(
                  color: ColorRepository.getColor(ColorName.secondaryTextColor,
                      widget.settingsController.themeMode)),
            ),
          ),
        );
      },
    );
  }
}
