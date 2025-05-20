import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget checkBoxWithLink(
  bool value,
  final ValueChanged<bool?> onChanged,
  final String prefixText,
  final String linkText,
  final VoidCallback onLinkTap,
  final BuildContext context
) {
  return Padding(
    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
    child: Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: BorderSide(
            color: Color.fromARGB(255, 44, 138, 0), // Borde verde
            width: 2,
          ),
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Color.fromARGB(255, 44, 138, 0); // Fondo blanco cuando está seleccionado
            }
            return Colors.transparent; // Fondo transparente cuando no está seleccionado
          }),
          checkColor: WidgetStateProperty.all(
            Colors.white, // Color morado para el tick
          ),
        ),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        selectedTileColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: prefixText,
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 252, 252, 252),                                     
                ),
              ),
              TextSpan(
                text: linkText,
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 44, 138, 0),
                ),
                recognizer: TapGestureRecognizer()..onTap = onLinkTap,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
