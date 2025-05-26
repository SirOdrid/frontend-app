import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/BoardgameProvider.dart';
import 'package:frontend_app/data/providers/CollectionProvider.dart';
import 'package:frontend_app/widgets/resources/BoardgameCard.dart';
import 'package:provider/provider.dart';

class ScreenSearchBoardgames extends StatefulWidget {
  const ScreenSearchBoardgames({super.key, required this.user});

  final User user;

  @override
  State<ScreenSearchBoardgames> createState() => _ScreenSearchBoardgamesState();
}

class _ScreenSearchBoardgamesState extends State<ScreenSearchBoardgames> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool get isFocused => _focusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    Provider.of<BoardgameProvider>(context, listen: false)
        .fetchBoardgamesBGG("a");
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Provider.of<BoardgameProvider>(context, listen: false)
          .fetchBoardgamesBGG(query);
    }
  }

  @override
Widget build(BuildContext context) {
  return Consumer2<BoardgameProvider, CollectionProvider>(
    builder: (context, boardgameProvider, collectionProvider, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Buscador de juegos",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 120.0, right: 120.0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: "Busca un juego...",
                    labelText: "Nombre del juego",
                    labelStyle: const TextStyle(color: Colors.white),
                    hintStyle: const TextStyle(color: Color.fromARGB(179, 255, 255, 255)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _search,
                    ),
                    filled: true,
                    fillColor: isFocused
                        ? const Color.fromARGB(255, 60, 43, 148)
                        : const Color.fromARGB(255, 43, 31, 105),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 21, 15, 51),
                        width: 3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF6236FF),
                        width: 3,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _search(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            boardgameProvider.boardgames.isEmpty
                ? const Center(
                    child: Text(
                      "Busca más juegos",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: boardgameProvider.boardgames.length,
                      itemBuilder: (context, index) {
                        final boardgame = boardgameProvider.boardgames[index];
                        final isInCollection = collectionProvider.isInCollection(boardgame.boardgameId);
                        
                        return isInCollection
                            ? boardgameCollectionCard(boardgame, widget.user.userId, context)
                            : boardgameCard(boardgame, widget.user.userId, context);
                      },
                    ),
                  ),
          ],
        ),
      );
    },
  );
}

}
