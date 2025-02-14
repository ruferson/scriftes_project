import 'package:flutter/material.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';

class ScriftesScreenBar extends StatelessWidget {
  const ScriftesScreenBar({
    super.key,
    required this.toolbarHeight,
    required this.controller,
    required this.title,
  });

  final double toolbarHeight;
  final SettingsController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: toolbarHeight,
      backgroundColor:
          ColorRepository.getColor(ColorName.barColor, controller.themeMode),
      title: Text(title),
      automaticallyImplyLeading: true,
    );
  }
}
