import 'package:flutter/material.dart';
import 'package:frontend_app/Styles/buttons_styles.dart';
import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/data/models/Pack.dart';
import 'package:frontend_app/data/providers/CollectionProvider.dart';
import 'package:frontend_app/data/providers/PackProvider.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:provider/provider.dart';

Widget boardgameCard(Boardgame boardgame, int idUser, BuildContext context) {
  String imageUrl = boardgame.boardgameImageUrl;
  String encodedUrl = Uri.encodeComponent(imageUrl);
  String proxyUrl = 'http://localhost:8080/proxy?url=$encodedUrl';

  return Card(
    color: const Color.fromARGB(255, 60, 43, 148),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Jugadores: ',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                          TextSpan(
                              text:
                                  '${boardgame.minPlayers} - ${boardgame.maxPlayers}', style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Año: ',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                          TextSpan(text: '${boardgame.releaseYear}', style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Género: ',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                          TextSpan(
                              text: boardgame
                                  .fkBoardgameGender.boardgameGenderName, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
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
              Consumer<PackProvider>(
                builder: (context, packProvider, _) {
                  final userPacks = packProvider.packs;

                  return Container(
                    decoration: DecorationBoxButton(8),
                    child: PopupMenuButton<Pack>(
                      onSelected: (selectedPack) {
                        // Usa directamente el provider que ya tenemos en el builder
                        packProvider.addBoardgameToPack(
                            selectedPack.packId, boardgame.boardgameId, idUser);
                      },
                      itemBuilder: (BuildContext _) {
                        if (userPacks.isEmpty) {
                          return [
                            const PopupMenuItem<Pack>(
                              value: null,
                              child: Text("No tienes packs disponibles"),
                            )
                          ];
                        }

                        return userPacks.map((pack) {
                          return PopupMenuItem<Pack>(
                            value: pack,
                            child: Text(pack.packName),
                          );
                        }).toList();
                      },
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.playlist_add,
                            color: Colors.white, size: 16),
                        label: const Text("ADD PACK",
                            style: TextStyle(color: Colors.white)),
                        onPressed:
                            null, // está bien dejar esto en null, se activa por el menu
                        style: styleButton(),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ],
      ),
    ),
  );
}

Widget boardgameCollectionCard(Boardgame boardgame, int idUser, BuildContext context) {
  String imageUrl = boardgame.boardgameImageUrl;
  String encodedUrl = Uri.encodeComponent(imageUrl);
  String proxyUrl = 'http://localhost:8080/proxy?url=$encodedUrl';

  return Card(
    color: const Color.fromARGB(255, 60, 43, 148),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Jugadores: ',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                          TextSpan(
                              text:
                                  '${boardgame.minPlayers} - ${boardgame.maxPlayers}',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),),
                                  
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Año: ',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                          TextSpan(text: '${boardgame.releaseYear}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Género: ',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                          TextSpan(
                              text: boardgame
                                  .fkBoardgameGender.boardgameGenderName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
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
                      .deleteBoardgameToCollection(
                          idUser, boardgame.boardgameId);
                },
              ),
              const SizedBox(width: 12),
              Consumer<PackProvider>(
                builder: (context, packProvider, _) {
                  final userPacks = packProvider.packs;

                  return Container(
                    decoration: DecorationBoxButton(8),
                    child: PopupMenuButton<Pack>(
                      onSelected: (selectedPack) {
                        // Usa directamente el provider que ya tenemos en el builder
                        packProvider.addBoardgameToPack(
                            selectedPack.packId, boardgame.boardgameId, idUser);
                      },
                      itemBuilder: (BuildContext _) {
                        if (userPacks.isEmpty) {
                          return [
                            const PopupMenuItem<Pack>(
                              value: null,
                              child: Text("No tienes packs disponibles"),
                            )
                          ];
                        }

                        return userPacks.map((pack) {
                          return PopupMenuItem<Pack>(
                            value: pack,
                            child: Text(pack.packName),
                          );
                        }).toList();
                      },
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.playlist_add,
                            color: Colors.white, size: 16),
                        label: const Text("ADD PACK",
                            style: TextStyle(color: Colors.white)),
                        onPressed:
                            null, // está bien dejar esto en null, se activa por el menu
                        style: styleButton(),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ],
      ),
    ),
  );
}
