import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:skriftes_project_2/screens/screen_bar.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';
import 'package:skriftes_project_2/services/firebase_service.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';
import 'package:skriftes_project_2/screens/settings/location_picker.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key, required this.controller});

  final SettingsController controller;
  final FirebaseService _firebaseService = FirebaseService();

  static const double toolbarHeight = kTextTabBarHeight;

  @override
  Widget build(BuildContext context) {
    final theme = controller.themeMode;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(toolbarHeight),
        child: ScriftesScreenBar(
          toolbarHeight: toolbarHeight,
          controller: controller,
          title: "Perfil de Usuario",
        ),
      ),
      backgroundColor: ColorRepository.getColor(ColorName.primaryColor, theme),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '¡Bienvenido, ${controller.userName}!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ColorRepository.getColor(
                              ColorName.textColor,
                              theme,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gestiona tus datos personales fácilmente.',
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorRepository.getColor(
                              ColorName.textColor,
                              theme,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Datos personales',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorRepository.getColor(
                          ColorName.textColor,
                          theme,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildOptionTile(
                    icon: Icons.account_circle_outlined,
                    title: 'Nombre de usuario',
                    onTap: () => _showEditNameDialog(context),
                    theme: theme,
                  ),
                  buildOptionTile(
                    icon: Icons.password_outlined,
                    title: 'Contraseña',
                    onTap: () => _showChangePasswordDialog(context),
                    theme: theme,
                  ),
                  buildOptionTile(
                    icon: Icons.my_location_outlined,
                    title: 'Ubicación',
                    onTap: () async {
                      final LatLng? position = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              LocationPickerPage(controller: controller),
                        ),
                      );
                      if (position != null) {
                        print(
                            'Ubicación seleccionada: ${position.latitude}, ${position.longitude}');
                      }
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeMode theme,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: ColorRepository.getColor(ColorName.white, theme),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: ColorRepository.getColor(
            ColorName.transpSpecialColor,
            theme,
          ),
          child: Icon(
            icon,
            color: ColorRepository.getColor(ColorName.specialColor, theme),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: ColorRepository.getColor(ColorName.textColor, theme),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: ColorRepository.getColor(
            ColorName.secondaryTextColor,
            theme,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final nameController = TextEditingController(text: controller.userName);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Editar nombre de usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Nuevo nombre'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                final newUserName = nameController.text.trim();
                if (newUserName.isNotEmpty) {
                  try {
                    final userId = await _firebaseService.getCurrentUserId();
                    await _firebaseService.updateUserName(userId, newUserName);
                    Navigator.of(context).pop();
                    controller.updateUserName(newUserName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nombre actualizado')),
                    );
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red.shade700,
                        content: const Text('Error al actualizar nombre'),
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
      builder: (_) {
        return AlertDialog(
          title: const Text('Cambiar contraseña'),
          content: SingleChildScrollView(
            child: Column(
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
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Guardar'),
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
                      const SnackBar(content: Text('Contraseña actualizada')),
                    );
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red.shade700,
                        content: const Text('Error al actualizar contraseña'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.orange.shade700,
                      content: const Text('Las contraseñas no coinciden'),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(hintText: hintText),
      ),
    );
  }
}
