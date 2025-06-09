import 'package:flutter/material.dart';
import 'package:frontend_app/text_content/TextContent.dart';

class Dialogs {
  
  static void showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text(TextContent.acceptAction),
            ),
          ],
        );
      },
    );
  }

  static void showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: const Text('Términos y Condiciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Expanded(
                child: SingleChildScrollView(
                  
                  child: Text(
                    TextContent.termsAndConditions, style: TextStyle(color: Colors.white),)
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Aceptar', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }


}