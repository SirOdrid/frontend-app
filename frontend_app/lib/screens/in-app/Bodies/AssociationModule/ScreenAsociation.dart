import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/UserAssociateProvider.dart';
import 'package:frontend_app/data/providers/UserProvider.dart';
import 'package:frontend_app/widgets/resources/userCard.dart';
import 'package:provider/provider.dart';

class ScreenAsociation extends StatefulWidget {
  const ScreenAsociation({super.key, required this.user});

  final User user;

  @override
  State<ScreenAsociation> createState() => _ScreenAsociationState();
}

class _ScreenAsociationState extends State<ScreenAsociation> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool get isFocused => _focusNode.hasFocus;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<UserAssociateProvider>(context, listen: false)
        .fetchAssociates(widget.user.userId);

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, UserAssociateProvider>(
      builder: (context, userProvider, associateProvider, child) {
        final associates = associateProvider.associates;

        // 🔍 Filtrar por nombre del usuario asociado
        final filteredAssociates = associates.where((associate) {
          final name = associate.fkAssociatedUser.userName.toLowerCase();
          return name.contains(_searchQuery);
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "MIS ASOCIADOS",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: Container(
                    width: double.infinity,
                    height: 170,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Wrap(
                      alignment: WrapAlignment.center, // Centrado horizontal
                      spacing: 80, // Más espacio horizontal entre textos
                      runSpacing: 20, // Espacio vertical entre filas
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            children: [
                              const TextSpan(
                                text: 'Asociados totales: ',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                              TextSpan(
                                text: associateProvider.associates.isEmpty
                                    ? '0'
                                    : '${associateProvider.associates.length}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            children: [
                              const TextSpan(
                                text: 'Particulares: ',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                              TextSpan(
                                text:
                                    '${associateProvider.getParticularAssociatesCount()}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            children: [
                              const TextSpan(
                                text: 'No particulares: ',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                              TextSpan(
                                text:
                                    '${associateProvider.getNonParticularAssociatesCount()}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            children: [
                              const TextSpan(
                                text: 'Registrados últimos 30 días: ',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                              TextSpan(
                                text:
                                    '${associateProvider.getRecentAssociatesCount()}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 🔍 Buscador
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "Buscar...",
                            labelText: "Nombre del usuario",
                            labelStyle: const TextStyle(color: Colors.white),
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(179, 255, 255, 255),
                            ),
                            suffixIcon: IconButton(
                              icon:
                                  const Icon(Icons.search, color: Colors.white),
                              onPressed: () {},
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
                          onSubmitted: (_) {},
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // 🧑‍🤝‍🧑 Lista de asociados filtrada
                Center(
                  child: filteredAssociates.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            "No tienes asociados",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredAssociates.length,
                          itemBuilder: (context, index) {
                            return userWithAsociationCard(
                              filteredAssociates[index],
                              widget.user,
                              context,
                              false,
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
