import 'package:flutter/material.dart';
import 'package:frontend_app/Styles/buttons_styles.dart';
import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/data/providers/CollectionProvider.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:provider/provider.dart';

Widget boardgameCard(Boardgame boardgame,int idUser, BuildContext context) {
  String imageUrl = boardgame.boardgameImageUrl;
  String encodedUrl = Uri.encodeComponent(imageUrl);
  String proxyUrl = 'http://localhost:8080/proxy?url=$encodedUrl';

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del juego con fallback
              SizedBox(
                height: 200,
                width: 200,
                child: Image.network(
                  proxyUrl,
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
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'images/notimage.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Contenido textual
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boardgame.boardgameName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Jugadores: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  '${boardgame.minPlayers} - ${boardgame.maxPlayers}'),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Año: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${boardgame.releaseYear}'),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Género: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  boardgame.fkBoardgameGender.boardgameGenderName),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Botones
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              standardButtonWithIcon(
                "ADD COLLECTION",
                () async {
                  Provider.of<CollectionProvider>(context, listen: false)
                      .addBoardgameToCollection(idUser, boardgame.boardgameId);
                },
                Icons.add_box_sharp,
              ),
              const SizedBox(width: 12),
              Container(
                decoration: DecorationBoxButton(8),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    print("Add to pack: $value");
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'Pack 1', child: Text('Pack 1')),
                    const PopupMenuItem(value: 'Pack 2', child: Text('Pack 2')),
                    const PopupMenuItem(value: 'Pack 3', child: Text('Pack 3')),
                  ],
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.playlist_add,
                        color: Colors.white, size: 16),
                    label: const Text("ADD PACK",
                        style: TextStyle(color: Colors.white)),
                    onPressed: null,
                    style: styleButton(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget boardgameCollectionCard(Boardgame boardgame,int idUser, BuildContext context) {
  String imageUrl = boardgame.boardgameImageUrl;
  String encodedUrl = Uri.encodeComponent(imageUrl);
  String proxyUrl = 'http://localhost:8080/proxy?url=$encodedUrl';

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del juego con fallback
              SizedBox(
                height: 200,
                width: 200,
                child: Image.network(
                  proxyUrl,
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
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'images/notimage.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Contenido textual
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boardgame.boardgameName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Jugadores: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  '${boardgame.minPlayers} - ${boardgame.maxPlayers}'),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Año: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${boardgame.releaseYear}'),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Género: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  boardgame.fkBoardgameGender.boardgameGenderName),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Botones
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              standardButton(
                "ELIMNAR",
                () {
                  Provider.of<CollectionProvider>(context, listen: false)
                      .deleteBoardgameToCollection(idUser,boardgame.boardgameId);
                },
              ),
              const SizedBox(width: 12),
              Container(
                decoration: DecorationBoxButton(8),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    print("Add to pack: $value");
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'Pack 1', child: Text('Pack 1')),
                    const PopupMenuItem(value: 'Pack 2', child: Text('Pack 2')),
                    const PopupMenuItem(value: 'Pack 3', child: Text('Pack 3')),
                  ],
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.playlist_add,
                        color: Colors.white, size: 16),
                    label: const Text("ADD PACK",
                        style: TextStyle(color: Colors.white)),
                    onPressed: null,
                    style: styleButton(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


