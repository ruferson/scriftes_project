import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  
  Future<ThemeMode> themeMode() async {
    final SharedPreferences prefs = await _prefs;
    ThemeMode theme = ThemeMode.light;
    String? prefsTheme = prefs.getString('themeMode');

    switch (prefsTheme) {
      case "ThemeMode.dark":
        theme = ThemeMode.dark;
        break;
      case "ThemeMode.light":
        theme = ThemeMode.light;
        break;
      default:
        theme = ThemeMode.light;
        break;
    }

    return theme;
  } //=> ThemeMode.system;

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    final SharedPreferences prefs = await _prefs;
    prefs.setString('themeMode', theme.toString());

    String? prefsTheme = prefs.getString('themeMode');
    print(prefsTheme);
  }
}
