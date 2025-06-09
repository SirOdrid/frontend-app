import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/AnalyticsProvider.dart';
import 'package:frontend_app/widgets/TextFormField.dart';
import 'package:provider/provider.dart';

class OwnershipStatsTable extends StatefulWidget {
  const OwnershipStatsTable({super.key, required this.user});
  final User user;

  @override
  State<OwnershipStatsTable> createState() => _OwnershipStatsTableState();
}

class _OwnershipStatsTableState extends State<OwnershipStatsTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  String _searchText = '';

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _rows = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AnalyticsProvider>(context, listen: false);
    provider.getBoardgameOwnershipStatsByUser(widget.user.userId).then((_) {
      setState(() {
        _rows = List.of(provider.boardgameOwnershipStats);
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

  void _sort<T>(Comparable<T> Function(dynamic d) getField, int columnIndex, bool ascending) {
    setState(() {
      _rows.sort((a, b) {
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
    final filteredStats = _rows.where((e) {
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                    headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 60, 43, 148)),
                    dataRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 85, 61, 204)),
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
                          'Asociados con el juego',
                          style: TextStyle(
                            color: Color.fromARGB(255, 34, 214, 10),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          _sort<num>(
                            (d) => d.totalAssociatesWithGame ?? 0,
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: const Text(
                          '% de propiedad',
                          style: TextStyle(
                            color: Color.fromARGB(255, 34, 214, 10),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          _sort<num>(
                            (d) => d.ownershipPercentage ?? 0.0,
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: const Text(
                          'En colección',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                            game.totalAssociatesWithGame.toString(),
                            style: const TextStyle(color: Colors.white),
                          )),
                          DataCell(Text(
                            '${game.ownershipPercentage.toStringAsFixed(2)}%',
                            style: const TextStyle(color: Colors.white),
                          )),
                          DataCell(
                            Icon(
                              game.inUserCollection
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: game.inUserCollection ? Colors.green : Colors.red,
                            ),
                          ),
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
