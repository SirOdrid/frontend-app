import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';

class ScreenCollectionAnalytics extends StatefulWidget {
  const ScreenCollectionAnalytics({super.key, required this.user});

  final User user;

  @override
  State<ScreenCollectionAnalytics> createState() => _ScreenCollectionAnalyticsState();
}

class _ScreenCollectionAnalyticsState extends State<ScreenCollectionAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              "MIS ESTADISTICAS",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}