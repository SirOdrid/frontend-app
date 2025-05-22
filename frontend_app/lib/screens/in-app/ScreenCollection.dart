import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';

class ScreenCollection extends StatefulWidget {
  const ScreenCollection({super.key, required this.user});

  final User user;
  
  @override
  State<ScreenCollection> createState() => _ScreenCollectionState();
}

class _ScreenCollectionState extends State<ScreenCollection> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}