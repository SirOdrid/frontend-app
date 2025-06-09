import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/models/UserLogin.dart';
import 'package:frontend_app/data/models/UserRecovery.dart';
import 'package:frontend_app/data/providers/UserProvider.dart';
import 'package:frontend_app/screens/in-app/ScreenMaster.dart';
import 'package:frontend_app/screens/out-app/ScreenRegistry.dart';
import 'package:frontend_app/widgets/Navigation.dart';
import 'package:frontend_app/widgets/TextFormField.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:provider/provider.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => ScreenLoginState();
}

class ScreenLoginState extends State<ScreenLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _formPassHash = '';
  String _formEmail = '';

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    UserLogin userLogin =
        UserLogin(userName: _formEmail, passHash: _formPassHash);

    final usuarioProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      User user = await usuarioProvider.loginUser(userLogin);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScreenMaster(user: user)),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error al iniciar sesión"),
          content: Text(e.toString().replaceAll("Exception: ", "")),
          actions: [
            TextButton(
              child: const Text("Cerrar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0B0B22),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color(0xFF0B0B22),
              Color(0xFF1B1B3A),
              Color(0xFF2A144B),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "TRACKER CRAWLER",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              const Image(image: AssetImage('assets/images/logo.png')),
              const SizedBox(height: 75),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    StandardTextFormField(
                      labelText: 'Email *',
                      hintText: 'Introduce tu email...',
                      obscureText: false,
                      onSaved: (newValue) => _formEmail = newValue!,
                      onlyNumbers: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obligatorio';
                        }
                        final emailRegExp =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegExp.hasMatch(value)) {
                          return 'Introduce un email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    StandardTextFormField(
                      labelText: 'Contraseña *',
                      hintText: 'Introduce tu contraseña...',
                      obscureText: true,
                      onSaved: (pass) => _formPassHash = pass!,
                      onlyNumbers: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    standardButton("Iniciar Sesión", _login),
                    const SizedBox(height: 20),
                    standardButton("Registrarse", () {
                      Navigation.GoToScreen(context, ScreenRegistry());
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  final GlobalKey<FormState> formKeyTwo =
                      GlobalKey<FormState>();
                  String email = '';
                  bool isLoading = false;

                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return StatefulBuilder(
                        builder: (context, setState) => AlertDialog(
                          title: const Text("Recuperar contraseña"),
                          content: isLoading
                              ? const SizedBox(
                                  height: 100,
                                  child: Center(child: CircularProgressIndicator()),
                                )
                              : Form(
                                  key: formKeyTwo,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'Introduce tu correo electrónico',
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Campo obligatorio';
                                      }
                                      final emailRegex = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Introduce un email válido';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) => email = newValue!,
                                  ),
                                ),
                          actions: isLoading
                              ? []
                              : [
                                  TextButton(
                                    child: const Text("Cancelar"),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text("Enviar solicitud"),
                                    onPressed: () async {
                                      if (formKeyTwo.currentState!.validate()) {
                                        formKeyTwo.currentState!.save();
                                        setState(() => isLoading = true);

                                        try {
                                          final usuarioProvider =
                                              Provider.of<UserProvider>(
                                                  context,
                                                  listen: false);

                                          await usuarioProvider.passwordRecovery(
                                            UserRecovery(emailRecovery: email),
                                          );

                                          Navigator.of(dialogContext).pop();

                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor: Colors.grey[850],
                                          
                                              title: const Text("Correo enviado", style: TextStyle(color: Colors.white)),
                                              content: Text(
                                                  "Se ha enviado un correo a $email con instrucciones para recuperar tu contraseña." ,
                                                  style: TextStyle(color: Colors.white)),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Aceptar"),
                                                ),
                                              ],
                                            ),
                                          );
                                        } catch (e) {
                                          Navigator.of(dialogContext).pop();
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Error"),
                                              content: const Text(
                                                  "Ocurrió un error. Intenta nuevamente."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Cerrar"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  '¿Olvidaste tu Contraseña?',
                  style: TextStyle(
                    color: Color.fromARGB(255, 44, 138, 0),
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

