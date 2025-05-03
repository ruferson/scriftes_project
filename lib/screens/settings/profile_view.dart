import 'package:flutter/material.dart';
import 'package:skriftes_project_2/screens/screen_bar.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.controller});

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
          title: "Perfil de Usuario",
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
                  leading: const Icon(Icons.person),
                  title: Text(
                    'Nombre: ${controller.userName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Lógica para editar el nombre
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(
                    'Dirección: ${controller.userAddress}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Lógica para editar la dirección
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(
                    'Correo: ${controller.userEmail}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Lógica para editar el correo
                    },
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
