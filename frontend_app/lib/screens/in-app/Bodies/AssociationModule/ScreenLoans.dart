import 'package:flutter/material.dart';
import 'package:frontend_app/Styles/buttons_styles.dart';
import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/data/models/Loan.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/CollectionProvider.dart';
import 'package:frontend_app/data/providers/LoanProvider.dart';
import 'package:frontend_app/data/providers/LoanStateProvider.dart';
import 'package:frontend_app/data/providers/StockProvider.dart';
import 'package:frontend_app/data/providers/UserAssociateProvider.dart';
import 'package:frontend_app/widgets/DropdownButtonFormField.dart';
import 'package:frontend_app/widgets/TextFormField.dart';
import 'package:frontend_app/widgets/elements/DatePicker.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenLoans extends StatefulWidget {
  const ScreenLoans({super.key, required this.user});

  final User user;

  @override
  State<ScreenLoans> createState() => _ScreenLoansState();
}

class _ScreenLoansState extends State<ScreenLoans> {
  final Map<int, GlobalKey<FormState>> _formUpdateKeys = {};
  final Map<int, TextEditingController> _updateControllers = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showForm = false;
  final TextEditingController _gameSearchController = TextEditingController();
  final TextEditingController _userSearchController = TextEditingController();
  String _gameSearchTerm = '';
  String _userSearchTerm = '';
  String? _selectedFilterLoanState;
  final FocusNode _focusNode = FocusNode();
  bool get isFocused => _focusNode.hasFocus;
  String? _formBoardgameName;
  String? _formLoanStateName;
  String? _formUpdateLoanStateName;
  String _borrower = '';
  DateTime? _selectedDate;
  late DateTime _expirationLoanDate;
  bool _showReturnDateSelector = false;
  final Map<int, int> _newLoans = {};
  Map<int, String?> _selectedLoanStates = {};

  void _toggleForm() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    // Validar fecha seleccionada, debe ser hoy o posterior
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_showReturnDateSelector) {
      final selectedDateOnly = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );

      if (selectedDateOnly.isBefore(today)) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: const Text(
                  'La fecha debe ser hoy o posterior',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        );
        return;
      }
    }

    final boardgame = Provider.of<CollectionProvider>(context, listen: false)
        .collections
        .firstWhere(
          (b) => b.boardgameName == _formBoardgameName,
          orElse: () => throw Exception('Juego no encontrado'),
        );

    final user = Provider.of<UserAssociateProvider>(context, listen: false)
        .associates
        .firstWhere(
          (u) =>
              u.fkAssociatedUser.userName.toLowerCase().trim() ==
              _borrower.toLowerCase().trim(),
        );

    final loanState = Provider.of<LoanStateProvider>(context, listen: false)
        .loanStates
        .firstWhere(
          (ls) => ls.loanStateName == _formLoanStateName,
          orElse: () => throw Exception('Estado de prestamo no encontrado'),
        );
    final stock =
        Provider.of<StockProvider>(context, listen: false).stocks.firstWhere(
              (s) =>
                  s.fkUser.userId == widget.user.userId &&
                  s.fkBoardgame.boardgameId == boardgame.boardgameId,
              orElse: () => throw Exception('Stock no encontrado'),
            );
    final newLoan = Loan(
        loanId: 0,
        fkUser: user.fkAssociatedUser,
        fkStock: stock,
        loanDate: today,
        expirationDate: _showReturnDateSelector ? _selectedDate! : today,
        fkLoanState: loanState);

    final loanProvider = Provider.of<LoanProvider>(context, listen: false);
    await loanProvider.addLoan(widget.user.userId, newLoan);

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        content: const Text(
          'Préstamo registrado exitosamente',
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
      _showReturnDateSelector = false;
      _formBoardgameName = null;
      _borrower = '';
      _formLoanStateName = null;
    });

    // setState(() {
    //   _showForm = false;
    //   _formBoardgameName = null;
    //   _stock = 0;
    // });
  }

  @override
  void dispose() {
    _updateControllers.forEach((key, controller) => controller.dispose());
    _gameSearchController.dispose();
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
    Provider.of<UserAssociateProvider>(context, listen: false)
        .fetchAssociates(widget.user.userId);
    Provider.of<LoanStateProvider>(context, listen: false).getAllLoanStates();

    _gameSearchController.addListener(() {
      setState(() {
        _gameSearchTerm = _gameSearchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer5<StockProvider, LoanProvider, CollectionProvider,
        UserAssociateProvider, LoanStateProvider>(
      builder: (context, stockProvider, loanProvider, collectionProvider,
          associateProvider, loanStateProvider, child) {
        final loanStates = loanStateProvider.loanStates;
        final filteredStockGames = stockProvider.stocks.where((stock) {
          final availableUnits =
              stock.units - loanProvider.countLoansByStockId(stock.stockId);
          return availableUnits != 0;
        }).toList();

        final filteredLoans = loanProvider.loans.where((loan) {
          final gameName = loan.fkStock.fkBoardgame.boardgameName.toLowerCase();
          final userName = loan.fkUser.userName.toLowerCase();
          final loanState = loan.fkLoanState.loanStateName;

          final gameMatches = gameName.contains(_gameSearchTerm.toLowerCase());
          final userMatches = userName.contains(_userSearchTerm.toLowerCase());
          final stateMatches = _selectedFilterLoanState == null ||
              loanState == _selectedFilterLoanState;

          return gameMatches && userMatches && stateMatches;
        }).toList();

        return Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Préstamos Asociación",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              standardButton(
                  _showForm ? 'Minimizar' : 'Nuevo Préstamo', _toggleForm),
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
                            value: filteredStockGames.any((g) =>
                                    g.fkBoardgame.boardgameName ==
                                    _formBoardgameName)
                                ? _formBoardgameName
                                : null,
                            onChanged: (String? newValue) {
                              setState(() {
                                _formBoardgameName = newValue;
                              });
                            },
                            items: filteredStockGames.isEmpty
                                ? [
                                    const DropdownMenuItem<String>(
                                      value: null,
                                      child: Text(
                                          'TNo hay juegos disponibles para préstamos'),
                                    )
                                  ]
                                : filteredStockGames.map((boardgame) {
                                    return DropdownMenuItem<String>(
                                      value:
                                          boardgame.fkBoardgame.boardgameName,
                                      child: Text(
                                          boardgame.fkBoardgame.boardgameName),
                                    );
                                  }).toList(),
                          ),
                          const SizedBox(height: 12),
                          StandardTextFormField(
                            labelText: 'Prestatario *',
                            hintText: 'Introduce un prestatario...',
                            obscureText: false,
                            onSaved: (newValue) => _borrower = newValue!,
                            onlyNumbers: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }

                              final exists = associateProvider.associates.any(
                                  (associate) =>
                                      associate.fkAssociatedUser.userName
                                          .toLowerCase() ==
                                      value.toLowerCase());

                              if (!exists) {
                                return 'El prestatario no es un asociado registrado';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          StandardDropdownButtonFormField(
                            labelText: "Tipo de préstamo",
                            value: loanStates.any((g) =>
                                    g.loanStateName == _formLoanStateName)
                                ? _formLoanStateName
                                : null,
                            onChanged: (String? newValue) {
                              setState(() {
                                _formLoanStateName = newValue;
                                _showReturnDateSelector =
                                    newValue?.toLowerCase() ==
                                        'pendiente de devolución';
                              });
                            },
                            items: loanStates.isEmpty
                                ? [
                                    const DropdownMenuItem<String>(
                                      value: null,
                                      child: Text(
                                          'ERROR AL CARGAR ESTADOS DE PRESTAMO, recarga la pagina'),
                                    )
                                  ]
                                : loanStates.where((loanState) {
                                    final name =
                                        loanState.loanStateName.toLowerCase();
                                    return name != 'devuelto' &&
                                        name != 'retraso';
                                  }).map((loanState) {
                                    return DropdownMenuItem<String>(
                                      value: loanState.loanStateName,
                                      child: Text(loanState.loanStateName),
                                    );
                                  }).toList(),
                          ),
                          const SizedBox(height: 12),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState: _showReturnDateSelector
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: DateSelectorDropdown(
                              onDateChanged: (date) {
                                _selectedDate = date;
                              },
                              initialDate: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                              ),
                            ),
                            secondChild: const SizedBox.shrink(),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isSmallScreen = constraints.maxWidth < 1000;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        // Buscador por juego
                        SizedBox(
                            width: isSmallScreen ? constraints.maxWidth : 250,
                            child: TextField(
                              controller: _gameSearchController,
                              // focusNode: _focusNode,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "Buscar Juego...",
                                labelText: "Nombre del juego",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(179, 255, 255, 255),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search,
                                      color: Colors.white),
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
                            )),

                        SizedBox(
                            width: isSmallScreen ? constraints.maxWidth : 250,
                            child: TextField(
                              controller: _userSearchController,
                              // focusNode: _focusNode,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "Buscar Usuario...",
                                labelText: "Nombre del usuario",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(179, 255, 255, 255),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search,
                                      color: Colors.white),
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
                            )),

                        // Dropdown de estado de préstamo
                        SizedBox(
                          width: isSmallScreen ? constraints.maxWidth : 400,
                          child: StandardDropdownButtonFormField(
                            labelText: "Estado del préstamo",
                            value: _selectedFilterLoanState,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedFilterLoanState = newValue;
                              });
                            },
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Todos los estados'),
                              ),
                              ...loanStates.map((state) {
                                return DropdownMenuItem<String>(
                                  value: state.loanStateName,
                                  child: Text(state.loanStateName),
                                );
                              }).toList()
                            ],
                          ),
                        ),
                        standardButton(
                          'Mostrar Todo',
                          () {
                            setState(() {
                              _gameSearchController.clear();
                              _userSearchController.clear();
                              _selectedFilterLoanState = null;

                              // Limpia también los términos usados para el filtro
                              _gameSearchTerm = '';
                              _userSearchTerm = '';

                              _focusNode.unfocus();
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredLoans.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay stock en la asociación",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredLoans.length,
                        itemBuilder: (context, index) {
                          final loan = filteredLoans[index];

                          if (!_updateControllers.containsKey(loan.loanId)) {
                            _updateControllers[loan.loanId] =
                                TextEditingController();
                          }

                          if (!_formUpdateKeys.containsKey(loan.loanId)) {
                            _formUpdateKeys[loan.loanId] =
                                GlobalKey<FormState>();
                          }

                          if (!_newLoans.containsKey(loan.loanId)) {
                            _newLoans[loan.loanId] = 0;
                          }

                          if (!_selectedLoanStates.containsKey(loan.loanId)) {
                            _selectedLoanStates[loan.loanId] =
                                loan.fkLoanState.loanStateName;
                          }

                          return Card(
                            color: const Color.fromARGB(255, 60, 43, 148),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Prestamo: ${loan.fkStock.fkBoardgame.boardgameName}",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Prestatario: ${loan.fkUser.userName}",
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 18),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Fecha Inicio: ${DateFormat('dd/MM/yyyy').format(loan.loanDate.toLocal())}",
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 18),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Fecha Fin: ${DateFormat('dd/MM/yyyy').format(loan.expirationDate.toLocal())}",
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 18),
                                  ),
                                  const SizedBox(height: 8),
                                  Form(
                                    key: _formUpdateKeys[loan.loanId],
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child:
                                              StandardDropdownButtonFormField(
                                            labelText: "Tipo de préstamo",
                                            value: _selectedLoanStates[
                                                loan.loanId],
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedLoanStates[
                                                    loan.loanId] = newValue;
                                              });

                                              // Actualizar loan en el provider o base de datos
                                              final selectedState =
                                                  loanStates.firstWhere(
                                                (ls) =>
                                                    ls.loanStateName ==
                                                    newValue,
                                              );

                                              Provider.of<LoanProvider>(context,
                                                      listen: false)
                                                  .updateLoan(
                                                widget.user.userId,
                                                Loan(
                                                  loanId: loan.loanId,
                                                  loanDate: loan.loanDate,
                                                  expirationDate:
                                                      loan.expirationDate,
                                                  fkUser: loan.fkUser,
                                                  fkStock: loan.fkStock,
                                                  fkLoanState: selectedState,
                                                ),
                                              );
                                            },
                                            items: loanStates.map((loanState) {
                                              return DropdownMenuItem<String>(
                                                value: loanState.loanStateName,
                                                child: Text(
                                                    loanState.loanStateName),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            Provider.of<LoanProvider>(context,
                                                    listen: false)
                                                .deleteLoan(widget.user.userId,
                                                    loan.loanId);
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
