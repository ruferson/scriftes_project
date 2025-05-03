import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<ThemeMode> themeMode() async {
    final SharedPreferences prefs = await _prefs;
    String? prefsTheme = prefs.getString('themeMode');
    if (prefsTheme == "ThemeMode.dark") {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('themeMode', theme.toString());
  }

  Future<String> getUserName() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('userName') ?? 'Usuario';
  }

  Future<String> getUserAddress() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('userAddress') ?? 'Dirección no disponible';
  }

  Future<String> getUserEmail() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('userEmail') ?? 'correo@ejemplo.com';
  }

  Future<void> updateUserName(String newName) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('userName', newName);
  }

  Future<void> updateUserAddress(String newAddress) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('userAddress', newAddress);
  }

  Future<void> updateUserEmail(String newEmail) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('userEmail', newEmail);
  }
}
