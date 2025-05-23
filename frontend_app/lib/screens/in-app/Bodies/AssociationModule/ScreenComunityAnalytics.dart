import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';

class ScreenComunityAnalytics extends StatefulWidget {
  const ScreenComunityAnalytics({super.key, required this.user});

  final User user;

  @override
  State<ScreenComunityAnalytics> createState() => _ScreenComunityAnalyticsState();
}

class _ScreenComunityAnalyticsState extends State<ScreenComunityAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              "MI MOTOR DE ANALISIS DE COMUNIDAD",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}