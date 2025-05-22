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

  //Gestiona el proceso de hacer login en la app
  void _login() async {
    if (!_formKey.currentState!.validate()) {
      // Si el formulario no es válido, no continuar
      return;
    }
    _formKey.currentState!.save();

    UserLogin userLogin =
        UserLogin(userName: _formEmail, passHash: _formPassHash);

    final usuarioProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      User user = await usuarioProvider.loginUser(userLogin);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenMaster(
            user: user,
          ),
        ),
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
                //TITULO
                const Text(
                  "TRACKER CRAWLER",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 252, 252, 252),
                  ),
                  textAlign: TextAlign.center,
                ),

                //Logotipo de la aplicacion
                const SizedBox(height: 60),
                Image(
                  image: AssetImage('assets/images/logo.png'),
                ),

                const SizedBox(height: 75),

                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                        width: 20,
                      ),
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
                          // Expresión regular para validar email
                          final emailRegExp =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                          if (!emailRegExp.hasMatch(value)) {
                            return 'Introduce un email válido';
                          }
                          return null; // todo bien
                        },
                      ),
                      const SizedBox(
                        height: 20,
                        width: 20,
                      ),
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
                      standardButton("Iniciar Sesión", () {
                        _login();
                      }),

                      //Boton de Registrarse
                      const SizedBox(height: 20),
                      standardButton("Registrarse", () {
                        Navigation.cambiarScreen(context, ScreenRegistry());
                      }),
                    ],
                  ),
                ),
                //Boton de iniciar sesion

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    final GlobalKey<FormState> formKeyTwo =
                        GlobalKey<FormState>();
                    String email = '';
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Recuperar contraseña"),
                          content: Form(
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
                                final emailRegex =
                                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Introduce un email válido';
                                }
                                return null;
                              },
                              onSaved: (newValue) => email = newValue!,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Cancelar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: const Text("Enviar solicitud"),
                              onPressed: () async {
                                if (formKeyTwo.currentState!.validate()) {
                                  formKeyTwo.currentState!.save();

                                  try {
                                    UserRecovery userRecovery =
                                        UserRecovery(emailRecovery: email); 
                                    final usuarioProvider =
                                        Provider.of<UserProvider>(context,
                                            listen: false);
                                    await usuarioProvider.passwordRecovery(
                                        userRecovery); // <- AWAIT AQUÍ
                                    Navigator.of(context).pop();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Se ha enviado un correo a $email")),
                                    );
                                  } catch (e) {
                                    // Mostramos el error si algo salió mal
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Error'),
                                        content: Text(e
                                            .toString()
                                            .replaceFirst('Exception: ', '')),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cerrar'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
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
                  },
                  child: Text(
                    '¿Olvidaste tu Contraseña?',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 44, 138, 0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ));
  }
}
