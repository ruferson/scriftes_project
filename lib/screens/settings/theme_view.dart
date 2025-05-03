import 'package:flutter/material.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';
import 'settings_controller.dart';

class ThemeView extends StatelessWidget {
  const ThemeView({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tema')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Seleccionar Tema'),
              trailing: DropdownButton<ThemeMode>(
                value: controller.themeMode,
                onChanged: controller.updateThemeMode,
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Tema Claro'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Tema Oscuro'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
