import 'dart:ui';

import 'package:flutter/material.dart';

abstract class Presentation {

  static Color primaryColorApp = Colors.teal;
  static Color secondaryColorApp = Colors.white;
  static Color tertiaryColorApp = Colors.deepOrange;

  static double fontSizeTitle = 20;
  static double fontSizeSubTitle = 14;
  static double fontSizeText = 11;

  static TextStyle textStyleTitle = TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizeTitle);

  static const double standarMaxWidthBody = 800;
  static const double smallMaxWidthBody = 500;

}