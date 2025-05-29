import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/PackProvider.dart';
import 'package:frontend_app/data/providers/UserProvider.dart';
import 'package:frontend_app/screens/in-app/Bodies/AssociationModule/ScreenAsociation.dart';
import 'package:frontend_app/screens/in-app/Bodies/AssociationModule/ScreenComunityAnalytics.dart';
import 'package:frontend_app/screens/in-app/Bodies/AssociationModule/ScreenLoans.dart';
import 'package:frontend_app/screens/in-app/Bodies/AssociationModule/ScreenStock.dart';
import 'package:frontend_app/screens/in-app/Bodies/CoreModule/ScreenCollection.dart';
import 'package:frontend_app/screens/in-app/Bodies/CoreModule/ScreenCollectionAnalytics.dart';
import 'package:frontend_app/screens/in-app/Bodies/CoreModule/ScreenMatches.dart';
import 'package:frontend_app/screens/in-app/Bodies/CoreModule/ScreenPacks.dart';
import 'package:frontend_app/screens/in-app/Bodies/CoreModule/ScreenProfile.dart';
import 'package:frontend_app/screens/in-app/Bodies/CoreModule/ScreenSearchBoardgames.dart';
import 'package:frontend_app/screens/in-app/Bodies/CoreModule/ScreenSessions.dart';
import 'package:frontend_app/screens/in-app/Bodies/CoreModule/ScreenSocial.dart';
import 'package:frontend_app/screens/out-app/ScreenLogin.dart';
import 'package:frontend_app/widgets/Navigation.dart';
import 'package:provider/provider.dart';

class ScreenMaster extends StatefulWidget {
  ScreenMaster({super.key, required this.user});

  User user;

  @override
  State<ScreenMaster> createState() => _ScreenMasterState();
}

class _ScreenMasterState extends State<ScreenMaster> {
  int selectedPage = 2;

  bool _shouldShowAssociationTile() {
    return widget.user.fkUserType.userTypeName.toLowerCase() != 'particular';
  }

  void _goToProfile(BuildContext context) {
    Navigator.pop(context); 
    setState(() {
      selectedPage = 11;
    });
  }

  void _logout(BuildContext context) {
    Navigator.pop(context);
    Navigation.GoToScreen(context, const ScreenLogin());
  }

  @override
  void initState() {
    super.initState();
    Provider.of<PackProvider>(context, listen: false)
        .getPacksByUser(widget.user.userId);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final List<Widget> pages = [
      // 0
      ScreenSearchBoardgames(user: widget.user),
      // 1
      ScreenSocial(user: widget.user),
      // 2
      ScreenCollection(
          user: widget.user,
          goToBoardgamesSearch: () {
            setState(() {
              selectedPage = 0;
            });
          }),
      // 3
      ScreenPacks(user: widget.user),
      // 4
      ScreenSessions(user: widget.user),
      // 5
      ScreenMatches(user: widget.user),
      // 6
      ScreenCollectionAnalytics(user: widget.user),
      // 7
      ScreenAsociation(user: widget.user),
      // 8
      ScreenStock(user: widget.user),
      // 9
      ScreenLoans(user: widget.user),
      // 10
      ScreenComunityAnalytics(user: widget.user),
      // 11
      ScreenProfile(user: widget.user),
    ];

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B22),
        title: Text("TRACKER CRAWLER"),
        titleTextStyle: const TextStyle(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          iconSize: 32,
          color: Colors.white,
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            iconSize: 32,
            color: Colors.white,
            onPressed: () {
              setState(() {
                selectedPage = 0;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset(
              'images/logo.png', // Ajusta si el path es distinto
              height: 128, // Cambia este valor para modificar el tamaño
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 85, 91, 95),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.user.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${widget.user.fkUserType.userTypeName} - ${widget.user.fkCountry.countryName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _goToProfile(context),
                        icon: const Icon(Icons.person, color: Colors.white),
                        label: const Text('Perfil',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => _logout(context),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text('Salir',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Parte scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.search),
                      title: const Text('BUSCAR JUEGO'),
                      onTap: () {
                        setState(() {
                          selectedPage = 0;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.people_alt),
                      title: const Text('SOCIAL'),
                      onTap: () {
                        setState(() {
                          selectedPage = 1;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.collections_bookmark),
                      title: const Text('MIS COLECCIONES'),
                      initiallyExpanded: true,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.library_books),
                          title: const Text('MI COLECCIÓN'),
                          onTap: () {
                            setState(() {
                              selectedPage = 2;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.all_inbox),
                          title: const Text('MIS PACKS'),
                          onTap: () {
                            setState(() {
                              selectedPage = 3;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.timeline),
                      title: const Text('MI ACTIVIDAD'),
                      initiallyExpanded: true,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.schedule),
                          title: const Text('MIS SESIONES'),
                          onTap: () {
                            setState(() {
                              selectedPage = 4;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.sports_esports),
                          title: const Text('MIS PARTIDAS'),
                          onTap: () {
                            setState(() {
                              selectedPage = 5;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.bar_chart),
                      title: const Text('MIS ESTADISTICAS'),
                      onTap: () {
                        setState(() {
                          selectedPage = 6;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    if (_shouldShowAssociationTile())
                      ExpansionTile(
                        leading: const Icon(Icons.groups),
                        title: const Text('MI ASOCIACIÓN'),
                        initiallyExpanded: true,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.group),
                            title: const Text('MIS ASOCIADOS'),
                            onTap: () {
                              setState(() {
                                selectedPage = 7;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.inventory),
                            title: const Text('MI STOCK'),
                            onTap: () {
                              setState(() {
                                selectedPage = 8;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.swap_horiz),
                            title: const Text('MIS PRESTAMOS'),
                            onTap: () {
                              setState(() {
                                selectedPage = 9;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.analytics),
                            title: const Text('MOTOR DE ANÁLISIS'),
                            onTap: () {
                              setState(() {
                                selectedPage = 10;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5), // Espacio antes del final
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('SETTINGS'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
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
        child: Center(child: pages[selectedPage]),
      ),
    );
  }

}
