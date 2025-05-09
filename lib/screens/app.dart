import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/translations.dart';

import 'package:skriftes_project_2/screens/home/home_view.dart';
import 'package:skriftes_project_2/screens/my_letters/my_letter_view.dart';
import 'package:skriftes_project_2/screens/login/login_view.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';
import 'package:skriftes_project_2/screens/settings/settings_view.dart';
import 'package:skriftes_project_2/screens/writing/writing_view.dart';
import 'package:skriftes_project_2/theme.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return ListenableBuilder(
          listenable: settingsController,
          builder: (context, _) {
            final themeMode = settingsController.themeMode;
            final theme = AppTheme.buildTheme(ThemeMode.light);
            final darkTheme = AppTheme.buildTheme(ThemeMode.dark);

            return MaterialApp(
              restorationScopeId: 'app',
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                FlutterQuillLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en', '')],
              theme: theme,
              darkTheme: darkTheme,
              themeMode: themeMode,
              home: snapshot.connectionState == ConnectionState.waiting
                  ? const SplashScreen()
                  : snapshot.hasData
                      ? MainAppShell(controller: settingsController)
                      : LoginScaffold(controller: settingsController),
            );
          },
        );
      },
    );
  }
}

class LoginScaffold extends StatelessWidget {
  const LoginScaffold({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final toolbarHeight = kToolbarHeight;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(toolbarHeight),
        child: ScriftesAppBar(
            toolbarHeight: toolbarHeight, themeMode: controller.themeMode),
      ),
      body: LoginView(controller: controller),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key, required this.controller});
  final SettingsController controller;

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _selectedIndex = 0;

  static const double toolbarHeight = kToolbarHeight;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return HomeView(controller: widget.controller);
      case 1:
        return MyLettersView(controller: widget.controller);
      case 2:
        return WritingView(controller: widget.controller);
      case 3:
        return SettingsView(controller: widget.controller);
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = widget.controller.themeMode;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(toolbarHeight),
        child:
            ScriftesAppBar(toolbarHeight: toolbarHeight, themeMode: themeMode),
      ),
      body: _getBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor:
            ColorRepository.getColor(ColorName.barColor, themeMode),
        selectedItemColor:
            ColorRepository.getColor(ColorName.specialColor, themeMode),
        unselectedItemColor:
            ColorRepository.getColor(ColorName.textColor, themeMode),
        selectedLabelStyle: TextStyle(
          color: ColorRepository.getColor(ColorName.specialColor, themeMode),
        ),
        unselectedLabelStyle: TextStyle(
          color:
              ColorRepository.getColor(ColorName.secondaryTextColor, themeMode),
        ),
        items: const [
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
      ),
    );
  }
}

class ScriftesAppBar extends StatelessWidget {
  const ScriftesAppBar(
      {super.key, required this.toolbarHeight, required this.themeMode});

  final double toolbarHeight;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    final logo = themeMode == ThemeMode.dark
        ? 'assets/images/dark_logo.png'
        : 'assets/images/logo.png';

    return AppBar(
      centerTitle: true,
      toolbarHeight: toolbarHeight,
      backgroundColor: ColorRepository.getColor(ColorName.barColor, themeMode),
      title: Image.asset(logo, width: 180, semanticLabel: 'Scrifte\'s logo'),
      leading: Navigator.of(context).canPop()
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : const SizedBox(),
    );
  }
}
