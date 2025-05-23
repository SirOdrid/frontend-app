import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';

class ScreenPacks extends StatefulWidget {
  const ScreenPacks({super.key, required this.user});

  final User user;

  @override
  State<ScreenPacks> createState() => _ScreenPacksState();
}

class _ScreenPacksState extends State<ScreenPacks> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              "MI PACKS PERSONALIZADOS",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}