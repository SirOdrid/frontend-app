import 'package:flutter/material.dart';
import 'package:frontend_app/Styles/texts_styles.dart';

Widget baseBody(double maxWidth, Widget child) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [
            Color(0xFF0B0B22),
            Color(0xFF1B1B3A),
            Color(0xFF2A144B),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ),
          child: child,
        ),
      ),
    );
  }

  Widget baseAppBarOutApp (String title){
    return AppBar(
      backgroundColor: const Color(0xFF0B0B22),
      title: Text(title),
      titleTextStyle: styleStandardText(20),
      centerTitle: true,
    );
  }

  Widget baseAppBarInApp (String title){
    return AppBar(
      backgroundColor: const Color(0xFF0B0B22),
      title: Text(title),
      titleTextStyle: styleStandardText(20),
      centerTitle: true,
    );
  }