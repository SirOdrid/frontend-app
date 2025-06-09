import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/providers/AnalyticsProvider.dart';
import 'package:frontend_app/screens/in-app/Bodies/AssociationModule/Analytics/LoanStatsTable.dart';
import 'package:frontend_app/screens/in-app/Bodies/AssociationModule/Analytics/OwnershipStatsTable.dart';
import 'package:frontend_app/screens/in-app/Bodies/AssociationModule/Analytics/RecommendedTable.dart';
import 'package:frontend_app/widgets/DropdownButtonFormField.dart';
import 'package:provider/provider.dart';


class ScreenComunityAnalytics extends StatefulWidget {
  const ScreenComunityAnalytics({super.key, required this.user});
  final User user;

  @override
  State<ScreenComunityAnalytics> createState() =>
      _ScreenComunityAnalyticsState();
}

class _ScreenComunityAnalyticsState extends State<ScreenComunityAnalytics> {
  String _selectedTable = 'Actividad de la Comunidad';

  final List<String> _tableOptions = [
    'Actividad de la Comunidad',
    'Préstamos',
    'Composición de Colecciones',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final analyticsProvider =
          Provider.of<AnalyticsProvider>(context, listen: false);
      analyticsProvider.getBoardgamePlayStatsByUser(widget.user.userId);
      analyticsProvider.getBoardgameOwnershipStatsByUser(widget.user.userId);
      analyticsProvider.getBoardgameLoanStatsByUser(widget.user.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_selectedTable) {
      case 'Actividad de la Comunidad':
        content = RecommendedTable(user: widget.user);
        break;
      case 'Préstamos':
        content = LoanStatsTable(user: widget.user);
        break;
      case 'Composición de Colecciones':
        content = OwnershipStatsTable(user: widget.user);
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
              "Motor de Análisis de Asociados",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),

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
