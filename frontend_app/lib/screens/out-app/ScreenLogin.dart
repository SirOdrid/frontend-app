import 'package:flutter/material.dart';
import 'package:frontend_app/screens/out-app/ScreenRegistry.dart';

import 'package:frontend_app/widgets/Navigation.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';

class ScreenLogin extends StatefulWidget {

  const ScreenLogin({super.key});

  @override
  State <ScreenLogin> createState() =>  ScreenLoginState();
}


class  ScreenLoginState extends State <ScreenLogin> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Gestiona el proceso de hacer login en la app
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // //Comprueba si los campos estan vacios y de si existen las credenciales en UsuariosDataBase, de ser asi entra a la app
    // if(_usernameController.text.isEmpty || _passwordController.text.isEmpty){
    //   RecursosUIs.mostrarMensajeInfo(context, "ERROR", "Los campos de usuario y contraseña no pueden estar vacios.");
    // }else{
    //   for (int i = 0; i <= LogicaUsuarios.numUsuarios(); i++) { 
    //   Usuario usuarioLogin = LogicaUsuarios.obtenerUsuario(i);
    //     if (usuarioLogin.nombre == username && usuarioLogin.password == password) {
    //       if(!usuarioLogin.bloqueado){
    //         Sesion.usuarioActual = usuarioLogin;
    //         if(usuarioLogin.admin){
    //           RecursosUIs.cambiarScreen(context, PantallaPrincipalAdmin(userLogin: usuarioLogin));
    //           break;
    //         }else{
    //           RecursosUIs.cambiarScreen(context, PantallaPrincipal(userLogin: usuarioLogin));
    //           break;
    //         }    
    //       }else{
    //         RecursosUIs.mostrarMensajeInfo(context, "ACCESO BLOQUEADO", "Su cuenta ha sido restringida, por favor contacta con un administrador.");
    //         break;
    //       }              
    //     }else{
    //       if(i == LogicaUsuarios.numUsuarios()-1){
    //         RecursosUIs.mostrarMensajeInfo(context, "ERROR", "El nombre o la contraseña son incorrectos.");
    //       }
    //     }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TrackerCrawler", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false, 
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // TITULO DE LOGIN FUERA DE LA APPBAR
            const SizedBox(height: 40),
            const Text( 
              "MOTORBIKERS",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
              textAlign: TextAlign.center,
            ),

            //Logotipo de la aplicacion
            const SizedBox(height: 60),
            // Image(
            //   image: AssetImage('assets/images/moto.png'),
            // ),
            


            //TextField de usuario para login
            const SizedBox(height: 75),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50), 
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            //TextField de password para login
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50), 
              child: SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            //Boton de iniciar sesion
            const SizedBox(height: 70),
            standardButton("Iniciar Sesión", () {
              _login;
            }),            

            //Boton de Registrarse
            const SizedBox(height: 10),
            standardButton("Registrarse", () {
              Navigation.cambiarScreen(context, ScreenRegistry());
            }),


            const SizedBox(height: 20),
            // TextButton(
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return RecuperarContrasenaDialog(); 
            //       },
            //     );
            //   }, 
            //   child: Text(
            //     '¿Olvidaste tu Contraseña?',
            //     style: TextStyle(color: Colors.blue),
            //   ),
            // ),
          ],
        ),
      )
    );
  }
}
