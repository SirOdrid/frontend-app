import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Analytics/UnplayedPoupularBoardgame.dart';
import 'package:frontend_app/data/models/Analytics/UsageBoardgame.dart';
import 'package:frontend_app/data/providers/AnalyticsProvider.dart';
import 'package:provider/provider.dart';

import 'package:frontend_app/data/models/User.dart';

import 'package:frontend_app/screens/in-app/Bodies/CoreModule/Analytics/ActivityTable.dart';
import 'package:frontend_app/screens/in-app/Bodies/CoreModule/Analytics/GenresTable.dart';
import 'package:frontend_app/widgets/DropdownButtonFormField.dart';

class ScreenCollectionAnalytics extends StatefulWidget {
  const ScreenCollectionAnalytics({super.key, required this.user});
  final User user;

  @override
  State<ScreenCollectionAnalytics> createState() =>
      _ScreenCollectionAnalyticsState();
}

class _ScreenCollectionAnalyticsState extends State<ScreenCollectionAnalytics> {
  String _selectedTable = 'Actividad';

  final List<String> _tableOptions = [
    'Actividad',
    'Colección',
  ];

  bool _expandBuy = false;
  bool _expandSell = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final analyticsProvider =
          Provider.of<AnalyticsProvider>(context, listen: false);
      analyticsProvider.getLowUsageBoardgames(widget.user.userId);
      analyticsProvider.getUnplayedPopularBoardgames(widget.user.userId);
    });
  }

Widget _buildRecommendationCard<T>({
  required String title,
  required List<T> boardgames,
  required bool isExpanded,
  required VoidCallback onToggleExpand,
}) {
  int basePlayCount = 0;
  if (boardgames.isNotEmpty && boardgames[0] is UnplayedPopularBoardgame) {
    basePlayCount = (boardgames[0] as UnplayedPopularBoardgame).globalPlayCount;
    if (basePlayCount == 0) basePlayCount = 1;
  }

  return Card(
    color: const Color.fromARGB(255, 60, 43, 148),
    child: Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
          subtitle: Text(
            'Total de Juegos: ${boardgames.length}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          trailing: IconButton(
            icon: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.green,
            ),
            onPressed: onToggleExpand,
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: boardgames.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "No hay juegos recomendados.",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Container(
                  color: const Color.fromARGB(255, 90, 64, 216),
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: boardgames.length,
                    itemBuilder: (context, idx) {
                      final game = boardgames[idx];

                      if (game is UnplayedPopularBoardgame) {
                        final double popularityIndex = (game.globalPlayCount / basePlayCount) * 100;
                        return ListTile(
                          title: Text(
                            game.boardgameName,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'Índice de popularidad: ${popularityIndex.toStringAsFixed(1)}%',
                            style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else if (game is UsageBoardgame) {
                        final double estimatedDaysPerPlay =
                            game.usageRate > 0 ? (1 / game.usageRate) : double.infinity;

                        final String usageEstimate = estimatedDaysPerPlay.isFinite
                            ? '1 partida cada ${estimatedDaysPerPlay.toStringAsFixed(1)} días'
                            : 'Uso desconocido';

                        return ListTile(
                          title: Text(
                            game.boardgameName,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            usageEstimate,
                            style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final analyticsProvider = Provider.of<AnalyticsProvider>(context);
    final recommendedToBuy = analyticsProvider.unplayedPopularBoardgames;
    final recommendedToSell = analyticsProvider.lowUsageBoardgames;

    Widget content;
    switch (_selectedTable) {
      case 'Actividad':
        content = ActivityTable(user: widget.user);
        break;
      case 'Colección':
        content = GenresTable(user: widget.user);
        break;
      default:
        content = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Mis Estadisticas y Recomendaciones",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),

          _buildRecommendationCard<UsageBoardgame>(
            title: '¿Qué juegos me recomiendas vender?',
            boardgames: recommendedToSell,
            isExpanded: _expandSell,
            onToggleExpand: () {
              setState(() {
                _expandSell = !_expandSell;
              });
            },
          ),
          const SizedBox(height: 16),

          _buildRecommendationCard<UnplayedPopularBoardgame>(
            title: '¿Qué juegos me recomiendas comprar?',
            boardgames: recommendedToBuy,
            isExpanded: _expandBuy,
            onToggleExpand: () {
              setState(() {
                _expandBuy = !_expandBuy;
              });
            },
          ),
          const SizedBox(height: 20),

          StandardDropdownButtonFormField(
            labelText: "Selecciona tabla",
            value: _tableOptions.contains(_selectedTable) ? _selectedTable : null,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTable = newValue!;
              });
            },
            items: _tableOptions.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          Expanded(child: content),
        ],
      ),
    );
  }
}
