import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';

Widget boardgameCard(Boardgame boardgame) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Imagen del juego
          SizedBox(
            height: 100, // Altura fija para la imagen
            width: 100,
            child: Image.network(
              boardgame.boardgameImageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre del juego
              Text(
                boardgame.boardgameName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Info del juego
              Text(
                  '${boardgame.minPlayers} - ${boardgame.maxPlayers} jugadores'),
              Text('${boardgame.releaseYear}'),

              const SizedBox(height: 16),

              // Botón ADD COLLECTION
              Align(
                alignment: Alignment.bottomRight,
                child: standardButtonWithIcon(
                    "ADD COLLECTION", 
                    () {
                      // Lógica para agregar el juego a la colección
                    }, 
                    Icons.add_box_sharp
                )
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
