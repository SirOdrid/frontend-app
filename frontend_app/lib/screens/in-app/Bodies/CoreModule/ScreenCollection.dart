import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/CollectionProvider.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:frontend_app/widgets/resources/BoardgameCard.dart';
import 'package:provider/provider.dart';

class ScreenCollection extends StatefulWidget {
  const ScreenCollection({super.key, required this.user, required this.goToBoardgamesSearch});

  final User user;
  final VoidCallback goToBoardgamesSearch;
  
  @override
  State<ScreenCollection> createState() => _ScreenCollectionState();
}

class _ScreenCollectionState extends State<ScreenCollection> {

  @override
  void initState() {
    super.initState();
    Provider.of<CollectionProvider>(context, listen: false)
        .fetchCollectionByUser(widget.user.userId);
  }

  @override
Widget build(BuildContext context) {
  return Consumer<CollectionProvider>(
    builder: (context, provider, child) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "MI COLECCIÓN",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: provider.collections.isEmpty
                    ? const Center(
                        child: Text(
                          "Tu colección está vacía",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.collections.length,
                        itemBuilder: (context, index) {
                          return boardgameCollectionCard(
                              provider.collections[index],widget.user.userId, context);
                        },
                      ),
              ),
              const SizedBox(height: 10),
              standardButton("AGREGAR JUEGO", () {
                widget.goToBoardgamesSearch();
              }),
            ],
          ),
        );
    },
  );
}

}