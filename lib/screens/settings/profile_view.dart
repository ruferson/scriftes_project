import 'package:flutter/material.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';
import 'settings_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text('Nombre: ${controller.userName}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Agregar lógica para editar el nombre
                },
              ),
            ),
            ListTile(
              title: Text('Dirección: ${controller.userAddress}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Agregar lógica para editar la dirección
                },
              ),
            ),
            ListTile(
              title: Text('Correo electrónico: ${controller.userEmail}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Agregar lógica para editar el correo electrónico
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
