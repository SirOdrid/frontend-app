import 'package:flutter/material.dart';
import 'package:frontend_app/Presentation.dart';
import 'package:frontend_app/Styles/buttons_styles.dart';
import 'package:frontend_app/data/providers/UserProvider.dart';
import 'package:frontend_app/screens/out-app/ScreenLogin.dart';
import 'package:frontend_app/widgets/Navigation.dart';
import 'package:provider/provider.dart';

Widget standardButton(String text, VoidCallback onPressed) {
  return Container(
    decoration: DecorationBoxButton(8),
    child: ElevatedButton(
      onPressed: onPressed,
      style: styleButton(),
      child: Text(text),
    ),
  );
}

Widget standardButtonWithIcon(String text, VoidCallback onPressed, IconData icon) {
  return Container(
    decoration: DecorationBoxButton(8),
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 16), 
      label: Text(text), 
      style: styleButton()
    )
  );
}

Widget serviceButton (String text, VoidCallback onPressed, IconData icon){
  return Container(
    decoration: DecorationBoxButton(20),
    child: OutlinedButton.icon(
      onPressed: () {
         onPressed;
      },
      icon: Icon(icon, color: Colors.white, size: 16),      
      label: Text(text), 
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Presentation.secondaryColorApp,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        
      ),
    ),
  );
}

Widget deleteButton(BuildContext context, int id) {
  return Container(
    decoration: DecorationBoxButtonRojo(8),
    child: ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirmar eliminación"),
            content: const Text("¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  final userProvider = Provider.of<UserProvider>(context, listen: false);
                  userProvider.accountDelete(id); 
                  Navigator.of(context).pop(); 
                  Navigation.GoToScreen(context, const ScreenLogin()); 
                },
                child: const Text(
                  "Eliminar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      style: styleButtonRojo(),
      child: const Text("Eliminar cuenta"),
    ),
  );
}