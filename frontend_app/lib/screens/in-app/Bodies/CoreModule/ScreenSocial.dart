import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/UserAssociateProvider.dart';
import 'package:frontend_app/data/providers/UserProvider.dart';
import 'package:frontend_app/widgets/resources/userCard.dart';
import 'package:provider/provider.dart';

class ScreenSocial extends StatefulWidget {
  const ScreenSocial({super.key, required this.user});

  final User user;

  @override
  State<ScreenSocial> createState() => _ScreenSocialState();
}

class _ScreenSocialState extends State<ScreenSocial> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool get isFocused => _focusNode.hasFocus;

  @override
  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await Provider.of<UserAssociateProvider>(context, listen: false)
        .fetchAssociations(widget.user.userId);
  });

  _focusNode.addListener(() {
    setState(() {});
  });
}


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Provider.of<UserProvider>(context, listen: false)
          .searchUsers(query);
    }
  }


@override
Widget build(BuildContext context) {
  return Consumer2<UserProvider, UserAssociateProvider>(
    builder: (context, userProvider, associateProvider, child) {
      final filteredUsers = userProvider
          .filterSearchResultsExcludingUserAndAssociates(
              widget.user, associateProvider.associations);

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟦 Título
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "BUSCAR USUARIOS",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),

              // 🔍 Campo de búsqueda
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
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // 📄 Resultados de búsqueda
              if (filteredUsers.isNotEmpty) ...[
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "RESULTADOS DE BÚSQUEDA",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return userWithoutAsociationCard(
                      user,
                      widget.user,
                      context,
                    );
                  },
                ),
              ] else if (_searchController.text.isNotEmpty) ...[
                const Center(
                  child: Text(
                    "No se encontraron usuarios",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],

              const SizedBox(height: 35),

              // 🤝 Asociaciones del usuario
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "MIS ASOCIACIONES",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              associateProvider.associations.isEmpty
                  ? const Center(
                      child: Text(
                        "No tienes asociaciones",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: associateProvider.associations.length,
                      itemBuilder: (context, index) {
                        return userWithAsociationCard(
                          associateProvider.associations[index],
                          widget.user,
                          context,
                          true,
                        );
                      },
                    ),
            ],
          ),
        ),
      );
    },
  );
}


}
