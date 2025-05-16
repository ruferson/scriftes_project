import 'package:flutter/material.dart';
import 'package:skriftes_project_2/screens/screen_bar.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';

class LegalView extends StatelessWidget {
  const LegalView({super.key, required this.controller});

  final SettingsController controller;

  static const double toolbarHeight = kTextTabBarHeight;

  @override
  Widget build(BuildContext context) {
    final theme = controller.themeMode;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(toolbarHeight),
        child: ScriftesScreenBar(
          toolbarHeight: toolbarHeight,
          controller: controller,
          title: "Información legal",
        ),
      ),
      backgroundColor: ColorRepository.getColor(ColorName.primaryColor, theme),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 11),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text(
                'Consulta las condiciones de uso y cómo protegemos tus datos.',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorRepository.getColor(ColorName.textColor, theme),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                buildLegalCard(
                  icon: Icons.description,
                  label: 'Términos y Condiciones',
                  onTap: () => _showTermsAndConditions(context),
                  theme: theme,
                ),
                buildLegalCard(
                  icon: Icons.privacy_tip,
                  label: 'Política de Privacidad',
                  onTap: () => _showPrivacyPolicy(context),
                  theme: theme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLegalCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeMode theme,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: ColorRepository.getColor(ColorName.white, theme),
      elevation: 0,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor:
              ColorRepository.getColor(ColorName.transpSpecialColor, theme),
          child: Icon(
            icon,
            color: ColorRepository.getColor(ColorName.specialColor, theme),
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ColorRepository.getColor(ColorName.textColor, theme),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: ColorRepository.getColor(ColorName.secondaryTextColor, theme),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showTermsAndConditions(BuildContext context) {
    final theme = controller.themeMode;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorRepository.getColor(ColorName.white, theme),
          title: Text(
            "Términos y Condiciones",
            style: TextStyle(
              color: ColorRepository.getColor(ColorName.textColor, theme),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              '''
Términos y Condiciones de Uso de Skrifte’s

Fecha de entrada en vigor: 03-05-2025

Por favor, lea atentamente estos Términos y Condiciones antes de utilizar la aplicación móvil Skrifte’s (“la App”).

Al utilizar la App, usted acepta estos términos. Si no está de acuerdo con alguno, le recomendamos no usar la App.

1. Objeto
Skrifte’s permite el envío de cartas digitales entre usuarios, simulando la experiencia del correo tradicional respetando tiempos basados en la distancia.

2. Uso adecuado
Se prohíbe usar la App para actividades ilegales, enviar contenido protegido por derechos de autor sin permiso, suplantar identidades o compartir contenido ofensivo o ilegal.

3. Registro y datos
Para acceder a la App es necesario registrarse con datos personales como nombre, dirección (puede ser ficticia) y correo electrónico. Usted es responsable de la veracidad de estos datos.

4. Responsabilidad sobre contenido
Los usuarios son responsables del contenido que envían mediante la App. El desarrollador no supervisa ni garantiza el contenido compartido.

5. Limitación de responsabilidad
La App se ofrece "tal cual" sin garantías adicionales. No se responsabiliza por daños derivados de su uso o interrupciones.

6. Cambios en términos
El desarrollador puede modificar estos términos en cualquier momento, notificando dichos cambios a través de la App. El uso continuado implica aceptación.

7. Legislación y jurisdicción
Estos términos se rigen por la legislación española. Cualquier disputa se resolverá ante los tribunales del domicilio del usuario.

8. Edad mínima
La App está destinada a usuarios mayores de 14 años. Los menores requieren autorización de sus tutores.

Gracias por usar Skrifte’s.
              ''',
              style: TextStyle(
                color: ColorRepository.getColor(ColorName.textColor, theme),
                fontSize: 14,
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cerrar",
                style: TextStyle(
                  color:
                      ColorRepository.getColor(ColorName.specialColor, theme),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    final theme = controller.themeMode;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorRepository.getColor(ColorName.white, theme),
          title: Text(
            "Política de Privacidad",
            style: TextStyle(
              color: ColorRepository.getColor(ColorName.textColor, theme),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              '''
Política de Privacidad de Skrifte’s

Fecha de entrada en vigor: 03-05-2025

Esta Política explica cómo recogemos, usamos y protegemos sus datos personales conforme al RGPD y la legislación española vigente.

1. Responsable
El responsable del tratamiento de sus datos es el desarrollador de Skrifte’s. Puede contactarnos mediante el correo disponible en la App.

2. Datos que recogemos
- Nombre de usuario (libremente introducido).
- Dirección (ficticia o simbólica, elegida por el usuario).
- Correo electrónico.
- Contraseña cifrada.

No recogemos datos sensibles, ubicación real, acceso a cámara o micrófono.

3. Finalidad del tratamiento
Los datos se usan para permitir el registro, identificar usuarios y garantizar la funcionalidad y seguridad de la App. No se utilizan para publicidad ni perfilado.

4. Base legal
El tratamiento se basa en el consentimiento otorgado al registrarse y usar la App.

5. Destinatarios
No compartimos datos con terceros, salvo obligación legal.

6. Conservación
Los datos se mantienen mientras la cuenta esté activa. A solicitud, se eliminarán permanentemente.

7. Derechos del usuario
Puede solicitar acceso, rectificación, supresión, limitación u oposición al tratamiento y portabilidad de sus datos contactando con el desarrollador.

8. Seguridad
Adoptamos medidas técnicas y organizativas para proteger sus datos contra accesos no autorizados o pérdida accidental.

9. Transferencias internacionales
Si se transfieren datos fuera de la UE, garantizamos medidas adecuadas para su protección.

10. Cambios
La política puede actualizarse. Se notificará cualquier cambio en la App.

Gracias por confiar en Skrifte’s.
              ''',
              style: TextStyle(
                color: ColorRepository.getColor(ColorName.textColor, theme),
                fontSize: 14,
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cerrar",
                style: TextStyle(
                  color:
                      ColorRepository.getColor(ColorName.specialColor, theme),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}
