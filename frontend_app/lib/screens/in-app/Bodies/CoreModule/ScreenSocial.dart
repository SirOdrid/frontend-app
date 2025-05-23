import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';

class ScreenSocial extends StatefulWidget {
  const ScreenSocial({super.key, required this.user});

  final User user;


  @override
  State<ScreenSocial> createState() => _ScreenSocialState();
}

class _ScreenSocialState extends State<ScreenSocial> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              "MI LISTA DE CONTACTOS",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}