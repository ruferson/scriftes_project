import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/translations.dart';
import 'package:skriftes_project_2/screens/home/home_view.dart';
import 'package:skriftes_project_2/screens/my_letters/my_letter_view.dart';
import 'package:skriftes_project_2/screens/login/login_view.dart';
import 'package:skriftes_project_2/screens/writing/writing_view.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key, // Added a key parameter
    required this.settingsController,
  }); // Added super constructor

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

  Widget _getBodyWidget(
      int selectedIndex, SettingsController settingsController) {
    switch (selectedIndex) {
      case 0:
        return HomeView(controller: settingsController);
      case 1:
        return MyLettersView(controller: settingsController);
      case 2:
        return WritingView(controller: settingsController);
      case 3:
        return SettingsView(controller: settingsController);
      default:
        return const SizedBox(); // Return an empty SizedBox for unknown index
    }
  }

  @override
  Widget build(BuildContext context) {
    const double toolbarHeight = kToolbarHeight;
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return inApp(toolbarHeight);
        } else {
          if (snapshot.hasData) {
            return inApp(toolbarHeight);
          } else {
            return loginPage(
                toolbarHeight); // Usuario no autenticado, muestra la página de inicio de sesión
          }
        }
      },
    );
  }

  MaterialApp loginPage(double toolbarHeight) {
    return MaterialApp(
      restorationScopeId: 'app',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      theme: ThemeData(), // No explicit theme defined, relying on default theme
      darkTheme: ThemeData.dark(),
      themeMode: widget.settingsController.themeMode,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(toolbarHeight),
          child: ScriftesAppBar(toolbarHeight: toolbarHeight, widget: widget),
        ),
        body: LoginView(controller: widget.settingsController),
      ),
    );
  }

  ListenableBuilder inApp(double toolbarHeight) {
    return ListenableBuilder(
      // Utilized ListenableBuilder for dynamic updates
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
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
              preferredSize: Size.fromHeight(toolbarHeight),
              child:
                  ScriftesAppBar(toolbarHeight: toolbarHeight, widget: widget),
            ),
            body: _getBodyWidget(_selectedIndex, widget.settingsController),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mail_outline),
                  activeIcon: Icon(Icons.mail),
                  label: 'Mis Cartas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit_outlined),
                  activeIcon: Icon(Icons.edit),
                  label: 'Escribir',
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
                  ColorName.barColor, widget.settingsController.themeMode),
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

class ScriftesAppBar extends StatelessWidget {
  const ScriftesAppBar({
    super.key,
    required this.toolbarHeight,
    required this.widget,
  });

  final double toolbarHeight;
  final MyApp widget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      primary: true,
      centerTitle: true,
      toolbarHeight: toolbarHeight,
      backgroundColor: ColorRepository.getColor(
          ColorName.barColor, widget.settingsController.themeMode),
      title: Image.asset(
        widget.settingsController.themeMode == ThemeMode.light
            ? 'assets/images/logo.png'
            : widget.settingsController.themeMode == ThemeMode.dark
                ? 'assets/images/dark_logo.png'
                : 'assets/images/logo.png',
        width: 180,
        semanticLabel: 'Scrifte\'s logo',
      ),
      leading: _getLeadingIcon(context),
    );
  }

  Widget _getLeadingIcon(BuildContext context) {
    // Verificar si el navegador tiene una pantalla anterior
    if (Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(); // Regresar a la pantalla anterior
        },
      );
    } else {
      return SizedBox(); // No mostrar el botón si no hay pantallas anteriores
    }
  }
}
