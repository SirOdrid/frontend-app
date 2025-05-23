import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';

class ScreenSessions extends StatefulWidget {
  const ScreenSessions({super.key, required this.user});

  final User user;

  @override
  State<ScreenSessions> createState() => _ScreenSessionsState();
}

class _ScreenSessionsState extends State<ScreenSessions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              "MIS SESIONES",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}