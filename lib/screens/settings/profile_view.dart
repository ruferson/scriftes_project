import 'package:flutter/material.dart';
import 'package:skriftes_project_2/screens/screen_bar.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';
import 'package:skriftes_project_2/services/firebase_service.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key, required this.controller});

  final SettingsController controller;
  final FirebaseService _firebaseService = FirebaseService();

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
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorRepository.getColor(
                        ColorName.textColor,
                        controller.themeMode,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: ColorRepository.getColor(
                        ColorName.textColor,
                        controller.themeMode,
                      ),
                    ),
                    onPressed: () {
                      _showEditNameDialog(context);
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: Text(
                    'Cambiar contraseña',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorRepository.getColor(
                        ColorName.textColor,
                        controller.themeMode,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: ColorRepository.getColor(
                        ColorName.textColor,
                        controller.themeMode,
                      ),
                    ),
                    onPressed: () {
                      _showChangePasswordDialog(context);
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

  void _showEditNameDialog(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: controller.userName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Editar nombre de usuario',
          ),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Nuevo nombre',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Guardar',
                style: TextStyle(
                  color: ColorRepository.getColor(
                    ColorName.brownTextColor,
                    controller.themeMode,
                  ),
                ),
              ),
              onPressed: () async {
                final newUserName = nameController.text.trim();
                if (newUserName.isNotEmpty) {
                  try {
                    final userId = await _firebaseService.getCurrentUserId();
                    await _firebaseService.updateUserName(userId, newUserName);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nombre actualizado'),
                      ),
                    );
                    controller.updateUserName(newUserName);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al actualizar nombre'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Cambiar contraseña',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPasswordTextField(
                controller: oldPasswordController,
                hintText: 'Contraseña actual',
              ),
              _buildPasswordTextField(
                controller: newPasswordController,
                hintText: 'Nueva contraseña',
              ),
              _buildPasswordTextField(
                controller: confirmPasswordController,
                hintText: 'Confirmar nueva contraseña',
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
              ),
            ),
            TextButton(
              child: Text(
                'Guardar',
                style: TextStyle(
                  color: ColorRepository.getColor(
                    ColorName.brownTextColor,
                    controller.themeMode,
                  ),
                ),
              ),
              onPressed: () async {
                final oldPassword = oldPasswordController.text.trim();
                final newPassword = newPasswordController.text.trim();
                final confirmPassword = confirmPasswordController.text.trim();

                if (newPassword == confirmPassword && newPassword.isNotEmpty) {
                  try {
                    await _firebaseService.updateUserPassword(
                        oldPassword, newPassword);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contraseña actualizada'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al actualizar contraseña'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Las contraseñas no coinciden'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
