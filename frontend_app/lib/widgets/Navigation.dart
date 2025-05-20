import 'package:flutter/material.dart';

class Navigation {

  static void cambiarScreen (BuildContext context, StatefulWidget screen){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => screen));
  }
  
}