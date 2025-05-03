import 'package:flutter/material.dart';
import 'package:skriftes_project_2/screens/screen_bar.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';

class ThemeView extends StatelessWidget {
  const ThemeView({super.key, required this.controller});

  final SettingsController controller;

  static const double toolbarHeight = kTextTabBarHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(toolbarHeight),
        child: ScriftesScreenBar(
          toolbarHeight: toolbarHeight,
          controller: controller,
          title: "Tema",
        ),
      ),
      backgroundColor: ColorRepository.getColor(
        ColorName.primaryColor,
        controller.themeMode,
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: const Text(
                    'Seleccionar Tema',
                    style: TextStyle(fontSize: 16),
                  ),
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
          );
        },
      ),
    );
  }
}
