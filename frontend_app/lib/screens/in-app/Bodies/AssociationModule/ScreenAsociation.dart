import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';

class ScreenAsociation extends StatefulWidget {
  const ScreenAsociation({super.key, required this.user});

  final User user;

  @override
  State<ScreenAsociation> createState() => _ScreenAsociationState();
}

class _ScreenAsociationState extends State<ScreenAsociation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              "MI COMUNIDAD",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}