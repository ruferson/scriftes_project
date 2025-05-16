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
    final theme = controller.themeMode;
    final isDark = theme == ThemeMode.dark;

    return Scaffold(
      backgroundColor: ColorRepository.getColor(ColorName.primaryColor, theme),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSettingsCard(
                  icon: Icons.person,
                  label: 'Perfil de usuario',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfileView(controller: controller),
                    ),
                  ),
                  theme: theme,
                ),
                buildSettingsCard(
                  icon: isDark ? Icons.nightlight_round : Icons.wb_sunny,
                  label: 'Tema',
                  onTap: () {
                    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
                    controller.updateThemeMode(newMode);
                  },
                  theme: theme,
                  showChevron: false, // Sin chevron para Tema
                ),
                buildSettingsCard(
                  icon: Icons.gavel,
                  label: 'Legal',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LegalView(controller: controller),
                    ),
                  ),
                  theme: theme,
                ),
                buildSettingsCard(
                  icon: Icons.logout,
                  label: 'Cerrar sesión',
                  onTap: () => _confirmSignOut(context),
                  theme: theme,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSettingsCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeMode theme,
    bool showChevron = true, // Por defecto true
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: ColorRepository.getColor(ColorName.white, theme),
      elevation: 0,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // el radio que quieras
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          leading: CircleAvatar(
            radius: 20,
            backgroundColor:
                ColorRepository.getColor(ColorName.transpSpecialColor, theme),
            child: Icon(icon,
                color: ColorRepository.getColor(ColorName.specialColor, theme)),
          ),
          title: Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorRepository.getColor(ColorName.textColor, theme),
            ),
          ),
          trailing: showChevron
              ? Icon(
                  Icons.chevron_left,
                  color: ColorRepository.getColor(
                      ColorName.secondaryTextColor, theme),
                )
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}

void _confirmSignOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      );
    },
  );
}
