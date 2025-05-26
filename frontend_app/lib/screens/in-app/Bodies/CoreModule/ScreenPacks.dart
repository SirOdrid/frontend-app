import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/data/models/Pack.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/BoardgameProvider.dart';
import 'package:frontend_app/data/providers/CollectionProvider.dart';
import 'package:frontend_app/data/providers/PackProvider.dart';
import 'package:frontend_app/widgets/DropdownButtonFormField.dart';
import 'package:frontend_app/widgets/TextFormField.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class ScreenPacks extends StatefulWidget {
  const ScreenPacks({super.key, required this.user});

  final User user;

  @override
  State<ScreenPacks> createState() => _ScreenPacksState();
}

class _ScreenPacksState extends State<ScreenPacks> {
  bool _showForm = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedPackFilter;
  String? _selectedBoardgameFilter;

  String _formPackName = '';
  List<Boardgame> _selectedBoardgame = [];
  final List<int> _expandedPackIds = [];

  void _toggleForm() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedBoardgame.isEmpty) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[850],
          content: const Text(
            'Selecciona al menos un juego para el pack',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    final packProvider = Provider.of<PackProvider>(context, listen: false);

    final newPack = await packProvider.createPack(
        widget.user.userId,
        Pack(
          packId: 0,
          packName: _formPackName,
          fkUser: widget.user,
          boardgames: [],
        ));

    for (final boardgame in _selectedBoardgame) {
      await packProvider.addBoardgameToPack(
          newPack.packId, boardgame.boardgameId, widget.user.userId);
    }

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        content: const Text(
          'Pack creado exitosamente',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;
    setState(() {
      _showForm = false;
      _selectedBoardgame = [];
      _formPackName = '';
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PackProvider>(context, listen: false)
          .getPacksByUser(widget.user.userId);
      Provider.of<CollectionProvider>(context, listen: false)
          .fetchCollectionByUser(widget.user.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final collectionProvider = Provider.of<CollectionProvider>(context);
    final packProvider = Provider.of<PackProvider>(context);

    final filteredPacks = _selectedBoardgameFilter == null
        ? packProvider.packs
        : packProvider.packs.where((pack) {
            return pack.boardgames
                .any((bg) => bg.boardgameName == _selectedBoardgameFilter);
          }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Listado Packs",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          standardButton(_showForm ? 'Minimizar' : 'Nuevo Pack', _toggleForm),
          const SizedBox(height: 16),
          if (packProvider.packs.isNotEmpty &&
              collectionProvider.collections.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _showForm
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          StandardTextFormField(
                            labelText: 'Nombre del Pack *',
                            hintText: 'Introduce un nombre...',
                            obscureText: false,
                            onSaved: (newValue) => _formPackName = newValue!,
                            onlyNumbers: false,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Campo obligatorio'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          MultiSelectDialogField<Boardgame>(
                            items: collectionProvider.collections
                                .map((boardgame) => MultiSelectItem(
                                    boardgame, boardgame.boardgameName))
                                .toList(),
                            title: const Text(
                              "Juegos de Mesa",
                              style: TextStyle(color: Colors.white),
                            ),
                            buttonIcon: const Icon(
                              Icons.people,
                              color: Colors.white,
                            ),
                            selectedColor: Colors.green,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 60, 43, 148),
                            ),
                            buttonText: const Text(
                              "Seleccionar juegos iniciales",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                            dialogWidth: 300,
                            dialogHeight: 400,
                            backgroundColor: Colors.grey[900],
                            itemsTextStyle:
                                const TextStyle(color: Colors.white),
                            selectedItemsTextStyle: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            confirmText: const Text(
                              "Aceptar",
                              style: TextStyle(color: Colors.green),
                            ),
                            cancelText: const Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.green),
                            ),
                            onConfirm: (values) {
                              setState(() {
                                _selectedBoardgame = values;
                              });
                            },
                            chipDisplay: MultiSelectChipDisplay(
                              chipColor: Colors.green,
                              textStyle: const TextStyle(color: Colors.white),
                              onTap: (value) {
                                setState(() {
                                  _selectedBoardgame.remove(value);
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          standardButton('Crear Pack', _submitForm),
                        ],
                      ),
                    ),
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),
            )
          else
            const Text(
              "No hay packs o juegos disponibles para asociar.",
              style: TextStyle(color: Colors.white),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: packProvider.packs.isEmpty
                ? const Center(
                    child: Text(
                      "No tienes ningún pack, crea uno.",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: packProvider.packs.length,
                    itemBuilder: (context, index) {
                      final pack = packProvider.packs[index];
                      final bool isExpanded =
                          _expandedPackIds.contains(pack.packId);

                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20),
                                  children: [
                                    TextSpan(
                                      text: pack.packName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    const TextSpan(text: 'Total de Juegos: '),
                                    TextSpan(
                                        text:
                                            pack.boardgames.length.toString()),
                                  ],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (isExpanded) {
                                          _expandedPackIds.remove(pack.packId);
                                        } else {
                                          _expandedPackIds.add(pack.packId);
                                        }
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      Provider.of<PackProvider>(context,
                                              listen: false)
                                          .deletePack(
                                              widget.user.userId, pack.packId);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: isExpanded
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: pack.boardgames.isEmpty
                                  ? const Center(
                                      child: Text(
                                        "No tienes ningún juego en este pack.",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors
                                                .white), // Cambiado a blanco
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey[850],
                                      constraints: const BoxConstraints(
                                        maxHeight: 200,
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: pack.boardgames.length,
                                        itemBuilder: (context, idx) {
                                          final boardgame =
                                              pack.boardgames[idx];
                                              print('Pack: ${pack.packName} tiene ${pack.boardgames.length} juegos.');
for (var bg in pack.boardgames) {
  print(' - Juego: ${bg.boardgameName}');
}
                                          return ListTile(
                                            title: Text(
                                              boardgame.boardgameName,
                                              style: const TextStyle(
                                                  color: Colors
                                                      .white), // Cambiado a blanco
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              secondChild: const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
