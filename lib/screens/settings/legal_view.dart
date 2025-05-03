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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(toolbarHeight),
        child: ScriftesScreenBar(
          toolbarHeight: toolbarHeight,
          controller: controller,
          title: "Información legal",
        ),
      ),
      backgroundColor: ColorRepository.getColor(
        ColorName.primaryColor,
        controller.themeMode,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Términos y Condiciones'),
              onTap: () {
                _showTermsAndConditions(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Política de Privacidad'),
              onTap: () {
                _showPrivacyPolicy(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Mostrar los términos y condiciones en un modal
  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorRepository.getColor(
            ColorName.secondaryColor,
            controller.themeMode,
          ),
          title: Text(
            "Términos y Condiciones",
            style: TextStyle(
              color: ColorRepository.getColor(
                ColorName.textColor,
                controller.themeMode,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  '''TÉRMINOS Y CONDICIONES DE USO DE SKRIFTE’S

Fecha de entrada en vigor: 03-05-2025

Por favor, lea detenidamente estos Términos y Condiciones antes de utilizar la aplicación móvil Skrifte’s (en adelante, “la App”).

Al utilizar la App, usted acepta cumplir con estos Términos. Si no está de acuerdo con alguna parte de ellos, no debe utilizar la App.

1. Objeto
Skrifte’s es una aplicación de envío de cartas digitales entre amigos, que simula el envío tradicional, respetando el tiempo estimado según la distancia entre usuarios.

2. Uso aceptable
El usuario se compromete a utilizar la App de manera respetuosa, legal y adecuada. Está prohibido:
- Usar la App para fines ilegales o no autorizados.
- Enviar contenido que infrinja derechos de autor o propiedad intelectual.
- Suplantar a otra persona o proporcionar información falsa.
- Publicar o intercambiar contenido ofensivo, ilegal o que viole derechos de terceros.

3. Registro y datos del usuario
Para usar la App, es necesario registrarse con una dirección de correo electrónico, un nombre y una dirección postal (que puede ser ficticia o simbólica a elección del usuario), así como una contraseña. La información proporcionada es responsabilidad exclusiva del usuario.

4. Responsabilidad del contenido
El contenido de las cartas enviadas es responsabilidad exclusiva de los usuarios. El desarrollador de Skrifte’s no se responsabiliza del contenido compartido entre usuarios ni realiza supervisión de dicho contenido.

5. Limitación de responsabilidad
Skrifte’s se proporciona “tal cual”, sin garantías de funcionamiento ininterrumpido o sin errores. El desarrollador no se hace responsable de posibles daños derivados del uso de la App.

6. Modificaciones
El desarrollador se reserva el derecho de modificar estos Términos en cualquier momento. Los cambios serán comunicados a través de la App. El uso continuado de la App tras las modificaciones implica la aceptación de los nuevos Términos.

7. Legislación aplicable
Estos Términos se rigen por la legislación española. En caso de conflicto, las partes se someterán a los Juzgados y Tribunales del domicilio del usuario.

8. Exoneración de responsabilidad por fuerza mayor
El desarrollador no será responsable de ningún daño o perjuicio que resulte de causas fuera de su control, tales como fallos de servidor, interrupciones en la red, actos de terceros o circunstancias de fuerza mayor.

9. Edad mínima
La App está destinada a usuarios mayores de 14 años. Los menores de edad deben contar con el consentimiento de sus tutores legales para utilizar la App.

10. Terminación de cuenta
El desarrollador se reserva el derecho de suspender o eliminar la cuenta de cualquier usuario que viole estos Términos o que realice actividades ilegales o no autorizadas.

11. Resolución de disputas
En caso de disputa, las partes intentarán resolver la controversia de manera amigable mediante mediación. Si no se alcanza un acuerdo, se someterán a los Juzgados y Tribunales del domicilio del usuario.''',
                  style: TextStyle(
                    color: ColorRepository.getColor(
                      ColorName.textColor,
                      controller.themeMode,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cerrar",
                style: TextStyle(
                  color: ColorRepository.getColor(
                    ColorName.specialColor,
                    controller.themeMode,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Mostrar la política de privacidad en un modal
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorRepository.getColor(
            ColorName.secondaryColor,
            controller.themeMode,
          ),
          title: Text(
            "Política de Privacidad",
            style: TextStyle(
              color: ColorRepository.getColor(
                ColorName.textColor,
                controller.themeMode,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  '''POLÍTICA DE PRIVACIDAD DE SKRIFTE’S

Fecha de entrada en vigor: 03-05-2025

Esta Política de Privacidad describe cómo se recopila, utiliza y protege la información personal de los usuarios de la App Skrifte’s conforme al Reglamento General de Protección de Datos (RGPD) y la legislación española vigente.

1. Responsable del tratamiento
El responsable del tratamiento de sus datos es el desarrollador de la App Skrifte’s. Para cualquier consulta, puede contactar mediante el correo facilitado en la aplicación o la plataforma de publicación.

2. Datos recopilados
La App recopila los siguientes datos personales:
- Nombre (introducido libremente por el usuario)
- Dirección (puede ser ficticia o simbólica, a elección del usuario)
- Correo electrónico
- Contraseña (almacenada de forma cifrada)

No se recopilan datos de localización real, ni acceso a cámara, micrófono u otros datos sensibles.

3. Finalidad del tratamiento
Los datos se recopilan con las siguientes finalidades:
- Permitir el registro e identificación del usuario.
- Simular la entrega de cartas digitales de forma personalizada.
- Garantizar el funcionamiento básico y seguro de la App.

No se realiza perfilado ni se utilizan los datos con fines publicitarios.

4. Base legal
La base legal para el tratamiento de los datos es el consentimiento del usuario al registrarse y utilizar la App.

5. Destinatarios
Los datos no se comparten con terceros, salvo obligación legal.

6. Conservación de los datos
Los datos se conservarán mientras el usuario mantenga su cuenta activa. Si el usuario solicita la eliminación de su cuenta, los datos se eliminarán permanentemente.

7. Derechos del usuario
Como usuario, usted tiene derecho a:
- Acceder a sus datos personales.
- Solicitar la rectificación o supresión.
- Limitar u oponerse al tratamiento.
- Solicitar la portabilidad de sus datos.

Puede ejercer sus derechos contactando al desarrollador.

8. Seguridad
Se aplican medidas técnicas y organizativas adecuadas para proteger los datos personales frente a accesos no autorizados o pérdida accidental.

9. Transferencia internacional de datos
En caso de que los datos se transfieran a servidores ubicados fuera de la UE, el desarrollador garantizará que se adopten las medidas adecuadas para proteger los datos de acuerdo con la legislación vigente.

10. Cambios en la política
Esta política puede actualizarse en cualquier momento. Cualquier cambio será informado oportunamente a través de la App.''',
                  style: TextStyle(
                    color: ColorRepository.getColor(
                      ColorName.textColor,
                      controller.themeMode,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cerrar",
                style: TextStyle(
                  color: ColorRepository.getColor(
                    ColorName.specialColor,
                    controller.themeMode,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
