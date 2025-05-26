import 'package:flutter/material.dart';
import 'package:frontend_app/Presentation.dart';
import 'package:frontend_app/Styles/buttons_styles.dart';

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