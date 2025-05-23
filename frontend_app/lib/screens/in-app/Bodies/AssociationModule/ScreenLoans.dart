import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';

class ScreenLoans extends StatefulWidget {
  const ScreenLoans({super.key, required this.user});

  final User user;
  
  @override
  State<ScreenLoans> createState() => _ScreenLoansState();
}

class _ScreenLoansState extends State<ScreenLoans> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              "MI GESTOR DE PRESTAMOS",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}