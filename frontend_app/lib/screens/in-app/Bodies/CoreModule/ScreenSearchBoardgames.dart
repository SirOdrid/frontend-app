import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/BoardgameProvider.dart';
import 'package:frontend_app/widgets/resources/BoardgameCard.dart';
import 'package:provider/provider.dart';

class ScreenSearchBoardgames extends StatefulWidget {
  const ScreenSearchBoardgames({super.key, required this.user});

  final User user;

  @override
  State<ScreenSearchBoardgames> createState() => _ScreenSearchBoardgamesState();
}

class _ScreenSearchBoardgamesState extends State<ScreenSearchBoardgames> {
  @override
  void initState() {
    super.initState();
    Provider.of<BoardgameProvider>(context, listen: false)
        .fetchBoardgamesBGG("nemesis");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardgameProvider>(
        builder: (context, boardgameProvider, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Verificar si hay productos
            boardgameProvider.boardgames.isEmpty
                ? const Center(
                    child: Text("No se ha encontrado ningún pedido."))
                : Expanded(
                    child: ListView.builder(
                      itemCount: boardgameProvider.boardgames.length,
                      itemBuilder: (context, index) {
                        return boardgameCard(boardgameProvider.boardgames[index]);
                      },
                    ),
                  ),
          ],
        ),
      );
    });
  }
}
