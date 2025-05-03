import 'package:flutter/material.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_controller.dart';
import 'profile_view.dart';
import 'theme_view.dart';
import 'legal_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRepository.getColor(ColorName.primaryColor, controller.themeMode),
      body: ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de Configuración
                  Text(
                    "Configuración",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ColorRepository.getColor(ColorName.textColor, controller.themeMode),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Perfil de Usuario'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileView(controller: controller),
                      ));
                    },
                  ),
                  ListTile(
                    title: const Text('Tema'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ThemeView(controller: controller),
                      ));
                    },
                  ),
                  ListTile(
                    title: const Text('Legal'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LegalView(),
                      ));
                    },
                  ),
                  ListTile(
                    title: const Text('Cerrar sesión'),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
