import 'package:flutter/material.dart';

class LegalView extends StatelessWidget {
  const LegalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Términos y Condiciones')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Términos y Condiciones'),
              onTap: () {
                // Aquí puedes agregar la navegación a los términos y condiciones
              },
            ),
            ListTile(
              title: const Text('Política de Privacidad'),
              onTap: () {
                // Aquí puedes agregar la navegación a la política de privacidad
              },
            ),
          ],
        ),
      ),
    );
  }
}
