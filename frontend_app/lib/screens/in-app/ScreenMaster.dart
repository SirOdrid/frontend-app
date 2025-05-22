import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/screens/in-app/ScreenCollection.dart';

class ScreenMaster extends StatefulWidget {
  const ScreenMaster({super.key, required this.user});

  final User user;
  
  @override
  State<ScreenMaster> createState() => _ScreenMasterState();
}

class _ScreenMasterState extends State<ScreenMaster> {

   var selectedBar = 0; 

  @override
  Widget build(BuildContext context) {

    // Widget page;
    
    // switch (selectedBar) { //selectedIndex
    //   case 0:
    //     page = ScreenCollection (user: widget.user);
    //     break;
    //   case 1:
    //     // page = PantallaPedidos(nombreUsuario: widget.nombreUsuario,);
    //     break;
    //   case 2:
    //     // page = PantallaYo();
    //     break;
    //   default:
    //     throw UnimplementedError('no widget for $selectedBar');
    // }

    return const Placeholder();
  }
}