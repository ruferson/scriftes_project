import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  late ThemeMode _themeMode;
  String? _userName;
  Object? _userLocation;
  String? _userEmail;

  ThemeMode get themeMode => _themeMode;
  String? get userName => _userName;
  Object? get userLocation => _userLocation;
  String? get userEmail => _userEmail;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();

    // Verifica si el usuario está logueado antes de cargar sus datos
    if (_settingsService.isUserLoggedIn()) {
      _userName = await _settingsService.getUserName();
      _userLocation = await _settingsService.getUserLocation();
    } else {
      print('[SettingsController] No user is logged in. User data skipped.');
      _userName = null;
      _userLocation = null;
    }

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateUserName(String newName) async {
    _userName = newName;
    notifyListeners();
    await _settingsService.updateUserName(newName);
  }

  Future<void> updateUserLocation(GeoPoint newLocation) async {
    _userLocation = newLocation;
    notifyListeners();
    await _settingsService.updateUserLocation(newLocation);
  }
}
