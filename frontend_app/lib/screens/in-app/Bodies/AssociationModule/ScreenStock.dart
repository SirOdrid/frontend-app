import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';

class ScreenStock extends StatefulWidget {
  const ScreenStock({super.key, required this.user});

  final User user;

  @override
  State<ScreenStock> createState() => _ScreenStockState();
}

class _ScreenStockState extends State<ScreenStock> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              "MI STOCK",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}