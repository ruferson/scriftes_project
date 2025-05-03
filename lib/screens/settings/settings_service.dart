import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skriftes_project_2/services/firebase_service.dart';

class SettingsService {
  final FirebaseService _firebaseService = FirebaseService();

  // Obtener el tema actual desde SharedPreferences
  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final prefsTheme = prefs.getString('themeMode');
    return prefsTheme == 'ThemeMode.dark' ? ThemeMode.dark : ThemeMode.light;
  }

  // Guardar el tema en SharedPreferences
  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', theme.toString());
  }

  // Obtener el nombre desde FirebaseService
  Future<String> getUserName() async {
    final userData = await _firebaseService.getMyUserData();
    return userData.username;
  }

  // Obtener la dirección desde FirebaseService
  Future<Object> getUserLocation() async {
    final userData = await _firebaseService.getMyUserData();
    return userData.location;
  }

  // Actualizar el nombre en FirebaseService
  Future<void> updateUserName(String newName) async {
    final userID = await _firebaseService.getCurrentUserId();
    await _firebaseService.updateUserName(userID, newName);
  }

  // Actualizar la dirección en FirebaseService
  Future<void> updateUserLocation(GeoPoint newLocation) async {
    final userID = await _firebaseService.getCurrentUserId();
    await _firebaseService.updateUserLocation(userID, newLocation);
  }
}
