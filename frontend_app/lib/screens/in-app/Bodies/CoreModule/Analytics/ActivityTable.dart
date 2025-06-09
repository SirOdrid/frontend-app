import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/AnalyticsProvider.dart';
import 'package:frontend_app/widgets/DropdownButtonFormField.dart';
import 'package:frontend_app/widgets/TextFormField.dart';
import 'package:provider/provider.dart';

class ActivityTable extends StatefulWidget {
  const ActivityTable({super.key, required this.user});
  final User user;

  @override
  State<ActivityTable> createState() => _ActivityTableState();
}

class _ActivityTableState extends State<ActivityTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  String _filterOption = 'Todos';
  String _searchText = '';

  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _stats = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AnalyticsProvider>(context, listen: false);
    provider.getBoardgameStatsByUser(widget.user.userId).then((_) {
      setState(() {
        _stats = List.of(provider.boardgameStats);
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

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void _sort<T>(Comparable<T> Function(dynamic d) getField, int columnIndex,
      bool ascending) {
    setState(() {
      _stats.sort((a, b) {
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
    final filteredByCollection = _filterOption == 'En colección'
        ? _stats.where((e) => e.inCollection).toList()
        : _filterOption == 'No está en tu colección'
            ? _stats.where((e) => !e.inCollection).toList()
            : _stats;

    final filteredStats = filteredByCollection.where((e) {
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
            // Row con Buscador y Filtro
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
                      )),
                  const SizedBox(width: 20),
                  Expanded(
                      flex: 1,
                      child: StandardDropdownButtonFormField(
                        labelText: 'Filtrar por',
                        value: _filterOption,
                        items: [
                          'Todos',
                          'En colección',
                          'No está en tu colección'
                        ]
                            .map((String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _filterOption = value!;
                          });
                        },
                      )),
                ],
              ),
            ),

            // Tabla (sin scroll horizontal, se adapta al ancho del container)
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
                          'Juego',
                          style: TextStyle(
                              color: Color.fromARGB(255, 34, 214, 10),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
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
                          'Partidas Totales',
                          style: TextStyle(
                              color: Color.fromARGB(255, 34, 214, 10),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          _sort<num>(
                            (d) => d.totalGames ?? 0,
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: const Text(
                          'Duración Media por Partida',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          _sort<int>(
                            (d) => d.averageDuration.inSeconds,
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'En colección',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: filteredStats
                        .map(
                          (index) => DataRow(
                            cells: [
                              DataCell(Text(index.boardgameName,
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(Text(index.totalGames.toString(),
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(Text(
                                  formatDuration(index.averageDuration),
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    index.inCollection
                                        ? 'En la colección'
                                        : 'No está en tu colección',
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
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
