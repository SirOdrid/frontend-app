import 'package:flutter/material.dart';
import 'package:frontend_app/Styles/buttons_styles.dart';
import 'package:frontend_app/data/models/Stock.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/CollectionProvider.dart';
import 'package:frontend_app/data/providers/LoanProvider.dart';
import 'package:frontend_app/data/providers/StockProvider.dart';
import 'package:frontend_app/widgets/DropdownButtonFormField.dart';
import 'package:frontend_app/widgets/TextFormField.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:provider/provider.dart';

class ScreenStock extends StatefulWidget {
  const ScreenStock({super.key, required this.user});

  final User user;

  @override
  State<ScreenStock> createState() => _ScreenStockState();
}

class _ScreenStockState extends State<ScreenStock> {
  bool _showForm = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showOnlyWithAvailableUnits = false;
  final Map<int, GlobalKey<FormState>> _formUpdateKeys = {};
  final Map<int, TextEditingController> _updateControllers = {};
  final Map<int, int> _newStocks = {};

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool get isFocused => _focusNode.hasFocus;

  String _searchQuery = '';
  String? _formBoardgameName;
  int _stock = 0;

  void _toggleForm() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  Future<void> _submitUpdateForm(Stock stock, bool sum) async {
    final formKey = _formUpdateKeys[stock.stockId];
    if (formKey == null || !formKey.currentState!.validate()) {
      return;
    }

    formKey.currentState!.save();

    final delta = _newStocks[stock.stockId] ?? 0;

    final updatedStock = Stock(
      stockId: stock.stockId,
      units: sum ? stock.units + delta : stock.units - delta,
      fkUser: stock.fkUser,
      fkBoardgame: stock.fkBoardgame,
    );

    if (updatedStock.units <= 0) {
      await Provider.of<StockProvider>(context, listen: false)
          .deleteStock(stock.stockId, widget.user.userId);
    } else {
      await Provider.of<StockProvider>(context, listen: false)
          .updateStock(updatedStock);
      _updateControllers[stock.stockId]?.clear();
      _newStocks[stock.stockId] = 0;
      formKey.currentState!.reset();
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    final boardgame = Provider.of<CollectionProvider>(context, listen: false)
        .collections
        .firstWhere(
          (b) => b.boardgameName == _formBoardgameName,
          orElse: () => throw Exception('Juego no encontrado'),
        );
    final stockProvider = Provider.of<StockProvider>(context, listen: false);

    final newStock = Stock(
      stockId: 0,
      fkUser: widget.user,
      fkBoardgame: boardgame,
      units: _stock,
    );

    await stockProvider.addStock(widget.user.userId, newStock);

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        content: const Text(
          'Juego añadido al stock exitosamente',
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

    setState(() {
      _showForm = false;
      _formBoardgameName = null;
      _stock = 0;
    });
  }

  @override
  void dispose() {
    _updateControllers.forEach((key, controller) => controller.dispose());
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<StockProvider>(context, listen: false)
        .getStockByUser(widget.user.userId);
    Provider.of<LoanProvider>(context, listen: false)
        .getLoansByUser(widget.user.userId);
    Provider.of<CollectionProvider>(context, listen: false)
        .fetchCollectionByUser(widget.user.userId);

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<StockProvider, LoanProvider, CollectionProvider>(
      builder:
          (context, stockProvider, loanProvider, collectionProvider, child) {
        final collections = collectionProvider.getBoardgamesInStock(
            stockProvider.stocks, false);

        // final filteredStock = stockProvider.stocks.where((stock) {
        //   final name = stock.fkBoardgame.boardgameName.toLowerCase();
        //   return name.contains(_searchQuery);
        // }).toList();
        final filteredStock = stockProvider.stocks.where((stock) {
          final name = stock.fkBoardgame.boardgameName.toLowerCase();
          final matchesSearch = name.contains(_searchQuery);

          if (!_showOnlyWithAvailableUnits) return matchesSearch;

          final loanCount = loanProvider.countLoansByStockId(stock.stockId);
          final availableUnits = stock.units - loanCount;

          return matchesSearch && availableUnits == 0;
        }).toList();

        return Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Stock Asociación",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              standardButton(
                  _showForm ? 'Minimizar' : 'Nuevo Juego', _toggleForm),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _showForm
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          StandardDropdownButtonFormField(
                            labelText: "Juego",
                            value: collections.any((g) =>
                                    g.boardgameName == _formBoardgameName)
                                ? _formBoardgameName
                                : null,
                            onChanged: (String? newValue) {
                              setState(() {
                                _formBoardgameName = newValue;
                              });
                            },
                            items: collections.isEmpty
                                ? [
                                    const DropdownMenuItem<String>(
                                      value: null,
                                      child: Text(
                                          'Todos los juegos ya están en stock'),
                                    )
                                  ]
                                : collections.map((collection) {
                                    return DropdownMenuItem<String>(
                                      value: collection.boardgameName,
                                      child: Text(collection.boardgameName),
                                    );
                                  }).toList(),
                          ),
                          const SizedBox(height: 12),
                          StandardTextFormField(
                            labelText: 'Cantidad Stock *',
                            hintText: 'Introduce una cantidad...',
                            obscureText: false,
                            onSaved: (newValue) =>
                                _stock = int.tryParse(newValue ?? '0') ?? 0,
                            onlyNumbers: true,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Campo obligatorio'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          standardButton('Añadir Juego', _submitForm),
                        ],
                      ),
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 8),
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
                          labelText: "Nombre del Juego de Mesa",
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(179, 255, 255, 255),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
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
                    const SizedBox(width: 4),
                    standardButton(
                      'Limpiar',
                      () {
                        setState(() {
                          _searchController.clear();
                          _focusNode.unfocus();
                        });
                      },
                    ),
                    const SizedBox(width: 15),
                    standardButton(
                        _showOnlyWithAvailableUnits
                            ? "Mostrar todos"
                            : "Mostrar no disponibles", () {
                      setState(() {
                        _showOnlyWithAvailableUnits =
                            !_showOnlyWithAvailableUnits;
                      });
                    })
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredStock.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay stock en la asociación",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredStock.length,
                        itemBuilder: (context, index) {
                          final stock = filteredStock[index];

                          if (!_updateControllers.containsKey(stock.stockId)) {
                            _updateControllers[stock.stockId] =
                                TextEditingController();
                          }

                          if (!_formUpdateKeys.containsKey(stock.stockId)) {
                            _formUpdateKeys[stock.stockId] =
                                GlobalKey<FormState>();
                          }

                          if (!_newStocks.containsKey(stock.stockId)) {
                            _newStocks[stock.stockId] = 0;
                          }

                          return Card(
                            color: const Color.fromARGB(255, 60, 43, 148),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stock.fkBoardgame.boardgameName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Stock: ${stock.units}",
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 18),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Unidades en Préstamo: ${loanProvider.countLoansByStockId(stock.stockId)}",
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 18),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Unidades Disponibles: ${stock.units - loanProvider.countLoansByStockId(stock.stockId)}",
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 18),
                                  ),
                                  const SizedBox(height: 8),
                                  Form(
                                    key: _formUpdateKeys[stock.stockId],
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: StandardTextFormField(
                                            controller: _updateControllers[
                                                stock.stockId],
                                            labelText: 'Cantidad Stock *',
                                            hintText:
                                                'Añade cantidad al stock...',
                                            obscureText: false,
                                            onlyNumbers: true,
                                            validator: (value) =>
                                                value == null || value.isEmpty
                                                    ? 'Campo obligatorio'
                                                    : null,
                                            onSaved: (newValue) {
                                              _newStocks[stock.stockId] =
                                                  int.tryParse(
                                                          newValue ?? '0') ??
                                                      0;
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          decoration: DecorationBoxButton(8),
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              cardColor: Colors.grey[850],
                                              textTheme:
                                                  const TextTheme().copyWith(
                                                bodyMedium: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            child: PopupMenuButton<bool>(
                                              onSelected: (bool sum) =>
                                                  _submitUpdateForm(stock, sum),
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      const [
                                                PopupMenuItem<bool>(
                                                  value: true,
                                                  child: Text("Sumar"),
                                                ),
                                                PopupMenuItem<bool>(
                                                  value: false,
                                                  child: Text("Restar"),
                                                ),
                                              ],
                                              child: ElevatedButton.icon(
                                                icon: const Icon(Icons.sync_alt,
                                                    color: Colors.white,
                                                    size: 16),
                                                label: const Text(
                                                  "Actualizar",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: null,
                                                style: styleButton(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            Provider.of<StockProvider>(context,
                                                    listen: false)
                                                .deleteStock(stock.stockId,
                                                    widget.user.userId);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
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
