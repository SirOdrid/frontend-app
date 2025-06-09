import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/AnalyticsProvider.dart';
import 'package:frontend_app/widgets/TextFormField.dart';
import 'package:provider/provider.dart';

class LoanStatsTable extends StatefulWidget {
  const LoanStatsTable({super.key, required this.user});
  final User user;

  @override
  State<LoanStatsTable> createState() => _LoanStatsTableState();
}

class _LoanStatsTableState extends State<LoanStatsTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  String _searchText = '';

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _recommendes = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AnalyticsProvider>(context, listen: false);
    provider.getBoardgameLoanStatsByUser(widget.user.userId).then((_) {
      setState(() {
        _recommendes = List.of(provider.boardgameLoanStats);
      });
    });

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _sort<T>(Comparable<T> Function(dynamic d) getField, int columnIndex,
      bool ascending) {
    setState(() {
      _recommendes.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);

        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return ascending ? -1 : 1;
        if (bValue == null) return ascending ? 1 : -1;

        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });

      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredStats = _recommendes.where((e) {
      final nameLower = e.boardgameName.toLowerCase();
      final searchLower = _searchText.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    return Center(
      child: Container(
        height: 800,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: StandardTextFormField(
                      controller: _searchController,
                      labelText: 'Buscar por nombre del juego',
                      hintText: 'Buscar...',
                      obscureText: false,
                      onlyNumbers: false,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    headingRowColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 60, 43, 148)),
                    dataRowColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 85, 61, 204)),
                    columnSpacing: 20,
                    columns: [
                      DataColumn(
                        label: const Text(
                          'Nombre del juego',
                          style: TextStyle(
                            color: Color.fromARGB(255, 34, 214, 10),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onSort: (columnIndex, ascending) {
                          _sort<String>(
                            (d) => d.boardgameName.toLowerCase(),
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: const Text(
                          'Histórico Préstamos',
                          style: TextStyle(
                            color: Color.fromARGB(255, 34, 214, 10),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          _sort<num>(
                            (d) => d.totalLoans ?? 0,
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: const Text(
                          'Uds Totales',
                          style: TextStyle(
                            color: Color.fromARGB(255, 34, 214, 10),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          _sort<num>(
                            (d) => d.totalStock ?? 0,
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: const Text(
                          'Prom. duración (días)',
                          style: TextStyle(
                            color: Color.fromARGB(255, 34, 214, 10),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          _sort<num>(
                            (d) => d.averageDurationDays ?? 0.0,
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: const Text(
                          'Préstamos/mes',
                          style: TextStyle(
                            color: Color.fromARGB(255, 34, 214, 10),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          _sort<num>(
                            (d) => d.averageLoansPerMonth ?? 0.0,
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                    ],
                    rows: filteredStats.map((game) {
                      return DataRow(
                        cells: [
                          DataCell(Text(
                            game.boardgameName,
                            style: const TextStyle(color: Colors.white),
                          )),
                          DataCell(Text(
                            game.totalLoans.toString(),
                            style: const TextStyle(color: Colors.white),
                          )),
                          DataCell(Text(
                            game.totalStock.toString(),
                            style: const TextStyle(color: Colors.white),
                          )),
                          DataCell(Text(
                            game.averageDurationDays.toStringAsFixed(2),
                            style: const TextStyle(color: Colors.white),
                          )),
                          DataCell(Text(
                            game.averageLoansPerMonth.toStringAsFixed(2),
                            style: const TextStyle(color: Colors.white),
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
