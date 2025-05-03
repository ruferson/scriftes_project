import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';
import 'settings_controller.dart';
import 'profile_view.dart';
import 'legal_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';
  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRepository.getColor(
        ColorName.primaryColor,
        controller.themeMode,
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child) {
          final isDark = controller.themeMode == ThemeMode.dark;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildSettingsTile(
                    context: context,
                    icon: Icons.person,
                    label: 'Perfil de usuario',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProfileView(controller: controller),
                      ),
                    ),
                  ),
                  buildSettingsTile(
                    context: context,
                    icon: isDark ? Icons.nightlight : Icons.wb_sunny,
                    label: 'Tema',
                    onTap: () {
                      final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
                      controller.updateThemeMode(newMode);
                    },
                  ),
                  buildSettingsTile(
                    context: context,
                    icon: Icons.gavel,
                    label: 'Legal',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LegalView(controller: controller),
                      ),
                    ),
                  ),
                  buildSettingsTile(
                    context: context,
                    icon: Icons.logout,
                    label: 'Cerrar sesión',
                    onTap: () async => await FirebaseAuth.instance.signOut(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

Widget buildSettingsTile({
  required BuildContext context,
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Directionality(
    textDirection: TextDirection.rtl, // Invertimos el orden: icono a la derecha
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Icon(
        icon,
        color: ColorRepository.getColor(
          ColorName.textColor,
          controller.themeMode,
        ),
      ),
      title: Text(
        label,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: ColorRepository.getColor(
            ColorName.textColor,
            controller.themeMode,
          ),
        ),
      ),
      onTap: onTap,
    ),
  );
}

}
