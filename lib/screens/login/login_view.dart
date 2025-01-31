import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key, // Añadido el parámetro de la clave
    required this.controller,
  }); // Utilizando la clave en el constructor

  final SettingsController controller;

  static const routeName = '/login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;
  String loginMsg = "";

  Future<bool> _signInWithEmailAndPassword() async {
    if (mounted) {
      setState(() {
        loading = true;
        loginMsg = "";
      });
      try {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        final User? user = userCredential.user;

        if (user != null) {
          setState(() {
            loading = false;
            loginMsg = "Redirigiendo...";
          });
          // Regresa true para indicar un inicio de sesión exitoso
          return true;
        } else {
          setState(() {
            loading = false;
            loginMsg = "Correo o contraseña incorrectas.";
          });
          // Regresa false para indicar un inicio de sesión fallido
          return false;
        }
      } catch (e) {
        print('Error durante el inicio de sesión: $e');
        // Maneja cualquier error que ocurra durante el inicio de sesión
        setState(() {
          loading = false;
          loginMsg = "Error en el inicio de sesión.";
        });
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorRepository.getColor(
          ColorName.primaryColor,
          widget.controller.themeMode,
        ),
        padding: const EdgeInsets.all(48.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          // Envuelve tu contenido en un SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Inicio de sesión",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: ColorRepository.getColor(
                    ColorName.textColor,
                    widget.controller.themeMode,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _emailController,
                cursorColor: ColorRepository.getColor(
                  ColorName.textColor,
                  widget.controller.themeMode,
                ),
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorRepository.getColor(
                        ColorName.specialColor,
                        widget.controller.themeMode,
                      ),
                      width: 2,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: ColorRepository.getColor(
                      ColorName.textColor,
                      widget.controller.themeMode,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: ColorRepository.getColor(
                    ColorName.textColor,
                    widget.controller.themeMode,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                cursorColor: ColorRepository.getColor(
                  ColorName.textColor,
                  widget.controller.themeMode,
                ),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorRepository.getColor(
                        ColorName.specialColor,
                        widget.controller.themeMode,
                      ),
                      width: 2,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: ColorRepository.getColor(
                      ColorName.textColor,
                      widget.controller.themeMode,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: ColorRepository.getColor(
                    ColorName.textColor,
                    widget.controller.themeMode,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                loginMsg,
                style: const TextStyle(color: Color.fromARGB(255, 143, 26, 26)),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _signInWithEmailAndPassword();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        ColorRepository.getColor(
                          ColorName.specialColor,
                          widget.controller.themeMode,
                        ),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorRepository.getColor(
                          ColorName.white,
                          widget.controller.themeMode,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              loading
                  ? Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          CircularProgressIndicator(
                            color: ColorRepository.getColor(
                              ColorName.specialColor,
                              widget.controller.themeMode,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
