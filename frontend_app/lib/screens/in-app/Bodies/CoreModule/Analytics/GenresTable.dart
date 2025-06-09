import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/AnalyticsProvider.dart';
import 'package:frontend_app/widgets/DropdownButtonFormField.dart';
import 'package:frontend_app/widgets/TextFormField.dart';
import 'package:provider/provider.dart';

class GenresTable extends StatefulWidget {
  const GenresTable({super.key, required this.user});
  final User user;

  @override
  State<GenresTable> createState() => _GenresTableState();
}

class _GenresTableState extends State<GenresTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  String _searchText = '';

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _genres = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AnalyticsProvider>(context, listen: false);
    provider.getTopGenresByUser(widget.user.userId).then((_) {
      setState(() {
        _genres = List.of(provider.topGenres);
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
      _genres.sort((a, b) {
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
    final filteredGenres = _genres.where((e) {
      final nameLower = e.genreName.toLowerCase();
      final searchLower = _searchText.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    final int totalAllGenres = _genres.fold<int>(0, (sum, item) => sum + item.totalGames as int);


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
                      labelText: 'Buscar por género',
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
                          'Género',
                          style: TextStyle(
                            color: Color.fromARGB(255, 34, 214, 10),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onSort: (columnIndex, ascending) {
                          _sort<String>(
                            (d) => d.genreName.toLowerCase(),
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: const Text(
                          'Total de juegos',
                          style: TextStyle(
                            color: Color.fromARGB(255, 34, 214, 10),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
                          'Porcentaje del total',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        numeric: true,
                      ),
                    ],
                    rows: filteredGenres.map((genre) {
                      final percentage = totalAllGenres > 0
                          ? (genre.totalGames / totalAllGenres * 100)
                              .toStringAsFixed(1)
                          : '0.0';
                      return DataRow(
                        cells: [
                          DataCell(Text(
                            genre.genreName,
                            style: const TextStyle(color: Colors.white),
                          )),
                          DataCell(Text(
                            genre.totalGames.toString(),
                            style: const TextStyle(color: Colors.white),
                          )),
                          DataCell(Text(
                            '$percentage%',
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

