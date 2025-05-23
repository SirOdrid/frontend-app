import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';

class ScreenMatches extends StatefulWidget {
  const ScreenMatches({super.key, required this.user});

  final User user;

  @override
  State<ScreenMatches> createState() => _ScreenMatchesState();
}

class _ScreenMatchesState extends State<ScreenMatches> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              "MIS PARTIDAS",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}