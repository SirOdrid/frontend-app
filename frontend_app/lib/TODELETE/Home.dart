import 'package:flutter/material.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BGG Clone',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            const TopBar(),
            const BannerImage(),
            const TabBar(
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.orange,
              tabs: [
                Tab(text: 'Explorar'),
                Tab(text: 'Panel'),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  ContentList(),
                  Center(child: Text("Panel vacío")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF342C5C),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Logo
            Image.asset(
              'assets/images/bgg_logo.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 8),
            _menuItem('Navegar'),
            _menuItem('Foros'),
            _menuItem('Listas de geeks'),
            _menuItem('Compras'),
            _menuItem('Comunidad'),
            _menuItem('Ayuda'),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Únete (¡es gratis!)', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 160,
              height: 36,
              child: TextField(
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: 'Buscar',
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
          const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}

class BannerImage extends StatelessWidget {
  const BannerImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/banner.png',
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

class ContentList extends StatelessWidget {
  const ContentList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        PostItem(
          title: 'Stalk Exchange - ¡Noche de juegos!',
          author: 'porheccubus',
          imagePath: 'assets/images/game_night.png',
        ),
        SizedBox(height: 12),
        PostItem(
          title:
              '19.ª edición anual de los premios Golden Geek: ¡Vote ahora!',
          author: 'porelife',
          imagePath: 'assets/images/golden_geek.png',
        ),
      ],
    );
  }
}

class PostItem extends StatelessWidget {
  final String title;
  final String author;
  final String imagePath;

  const PostItem({
    super.key,
    required this.title,
    required this.author,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(author, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
