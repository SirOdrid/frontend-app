import 'package:flutter/material.dart';

class Navigation {

  static void GoToScreen (BuildContext context, StatefulWidget screen){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => screen));
  }
  
}