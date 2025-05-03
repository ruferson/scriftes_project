import 'package:flutter/material.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;
  
  late ThemeMode _themeMode;
  late String _userName;
  late String _userAddress;
  late String _userEmail;
  
  ThemeMode get themeMode => _themeMode;
  String get userName => _userName;
  String get userAddress => _userAddress;
  String get userEmail => _userEmail;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _userName = await _settingsService.getUserName();
    _userAddress = await _settingsService.getUserAddress();
    _userEmail = await _settingsService.getUserEmail();
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

  Future<void> updateUserAddress(String newAddress) async {
    _userAddress = newAddress;
    notifyListeners();
    await _settingsService.updateUserAddress(newAddress);
  }

  Future<void> updateUserEmail(String newEmail) async {
    _userEmail = newEmail;
    notifyListeners();
    await _settingsService.updateUserEmail(newEmail);
  }
}
