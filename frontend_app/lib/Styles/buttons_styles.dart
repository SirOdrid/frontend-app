import 'package:flutter/material.dart';
import 'package:frontend_app/Presentation.dart';
import 'package:frontend_app/Styles/texts_styles.dart';



ButtonStyle styleButton() {
  return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Presentation.secondaryColorApp,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: styleStandardText(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minimumSize: const Size(180, 50),
    );
}

BoxDecoration DecorationBoxButton(double radio) {
  return BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color.fromARGB(255, 18, 58, 0), Color.fromARGB(255, 44, 138, 0)], // Verde claro a oscuro
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(radio),
    boxShadow: const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 4,
        offset: Offset(2, 2),
      ),
    ],
  );
}

ButtonStyle styleButtonRojo() {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    textStyle: styleStandardText(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    minimumSize: const Size(180, 50),
  );
}

BoxDecoration DecorationBoxButtonRojo(double radio) {
  return BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color.fromARGB(255, 138, 0, 0), Color.fromARGB(255, 73, 0, 0)], // Rojo claro a oscuro
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(radio),
    boxShadow: const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 4,
        offset: Offset(2, 2),
      ),
    ],
  );
}