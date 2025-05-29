import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/data/models/Meeting.dart';
import 'package:frontend_app/data/models/Session.dart';
import 'package:frontend_app/data/models/SessionPlayers.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/models/UserAssociate.dart';
import 'package:frontend_app/data/providers/CollectionProvider.dart';
import 'package:frontend_app/data/providers/MeetingProvider.dart';
import 'package:frontend_app/data/providers/SessionProvider.dart';
import 'package:frontend_app/data/providers/UserAssociateProvider.dart';
import 'package:frontend_app/widgets/DropdownButtonFormField.dart';
import 'package:frontend_app/widgets/elements/DatePicker.dart';
import 'package:frontend_app/widgets/elements/DurationSelectorDropdown.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenMatches extends StatefulWidget {
  const ScreenMatches({super.key, required this.user});

  final User user;

  @override
  State<ScreenMatches> createState() => _ScreenMatchesState();
}

class _ScreenMatchesState extends State<ScreenMatches> {
  bool _showForm = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedSessionFilter;
  String? _selectedGameFilter;
  String? _formBoardgameName;
  String? _formSessionName;

  Duration _selectedDuration = Duration.zero;

  void _toggleForm() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final session = Provider.of<SessionProvider>(context, listen: false)
        .sessions
        .firstWhere(
          (s) => s.sessionName == _formSessionName,
          orElse: () => throw Exception('Sesión no encontrada'),
        );

    final boardgame = Provider.of<CollectionProvider>(context, listen: false)
        .collections
        .firstWhere(
          (b) => b.boardgameName == _formBoardgameName,
          orElse: () => throw Exception('Juego no encontrado'),
        );

    final newMeeting = Meeting(
      meetingId: 0,
      fkSession: session,
      fkBoardgame: boardgame,
      meetingDuration: _selectedDuration,
    );

    Provider.of<MeetingProvider>(context, listen: false)
        .createMeeting(widget.user.userId, newMeeting);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partida registrada exitosamente')),
    );

    setState(() {
      _showForm = false;
      _formBoardgameName = null;
      _formSessionName = null;
      _selectedDuration = Duration.zero;
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SessionProvider>(context, listen: false)
        .getSessionsByUser(widget.user.userId);
    Provider.of<MeetingProvider>(context, listen: false)
        .getMeetingsByUser(widget.user.userId);
    Provider.of<UserAssociateProvider>(context, listen: false)
        .fetchAssociates(widget.user.userId);
    Provider.of<CollectionProvider>(context, listen: false)
        .fetchCollectionByUser(widget.user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionProvider, MeetingProvider, CollectionProvider>(
      builder: (context, sessionProvider, meetingProvider, collectionProvider, child) {
        final sessions = sessionProvider.sessions;
        final collections = collectionProvider.collections;

        final filteredMeetings = meetingProvider.meetings.where((m) {
          final matchesSession = _selectedSessionFilter == null ||
              m.fkSession.sessionName == _selectedSessionFilter;
          final matchesGame = _selectedGameFilter == null ||
              m.fkBoardgame.boardgameName == _selectedGameFilter;
          return matchesSession && matchesGame;
        }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Listado Partidas",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              standardButton(_showForm ? 'Minimizar' : 'Nueva Partida', _toggleForm),
              const SizedBox(height: 16),

              if (sessions.isNotEmpty && collections.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _showForm
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              StandardDropdownButtonFormField(
                                labelText: "Sesión Asociada",
                                value: sessions.any((s) => s.sessionName == _formSessionName)
                                    ? _formSessionName
                                    : null,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _formSessionName = newValue;
                                  });
                                },
                                items: sessions.map((session) {
                                  return DropdownMenuItem<String>(
                                    value: session.sessionName,
                                    child: Text(session.sessionName),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              StandardDropdownButtonFormField(
                                labelText: "Juego",
                                value: collections.any((g) => g.boardgameName == _formBoardgameName)
                                    ? _formBoardgameName
                                    : null,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _formBoardgameName = newValue;
                                  });
                                },
                                items: collections.map((collection) {
                                  return DropdownMenuItem<String>(
                                    value: collection.boardgameName,
                                    child: Text(collection.boardgameName),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              DurationSelectorDropdown(
                                initialDuration: Duration(hours: 1),
                                onDurationChanged: (duration) {
                                  setState(() {
                                    _selectedDuration = duration;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              standardButton('Registrar Partida', _submitForm),
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
                  "No hay sesiones o juegos disponibles para asociar.",
                  style: TextStyle(color: Colors.white),
                ),

              const SizedBox(height: 16),

              // if (sessions.isNotEmpty && collections.isNotEmpty && filteredMeetings.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: StandardDropdownButtonFormField(
                        labelText: "Filtrar por sesión",
                        value: _selectedSessionFilter,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSessionFilter = newValue;
                          });
                        },
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text("Todas las sesiones"),
                          ),
                          ...sessions.map((session) => DropdownMenuItem<String>(
                                value: session.sessionName,
                                child: Text(session.sessionName),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StandardDropdownButtonFormField(
                        labelText: "Filtrar por juego",
                        value: _selectedGameFilter,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGameFilter = newValue;
                          });
                        },
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text("Todos los juegos"),
                          ),
                          ...collections.map((game) => DropdownMenuItem<String>(
                                value: game.boardgameName,
                                child: Text(game.boardgameName),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 16),
              Expanded(
                child: filteredMeetings.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay partidas registradas",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredMeetings.length,
                        itemBuilder: (context, index) {
                          final meeting = filteredMeetings[index];
                          return Card(
                            child: ListTile(
                              title: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black, fontSize: 20),
                                  children: [
                                    TextSpan(
                                      text: meeting.fkSession.sessionName,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const TextSpan(text: ' - '),
                                    TextSpan(
                                      text: DateFormat('dd/MM/yyyy').format(
                                          meeting.fkSession.sessionDate.toLocal()),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(color: Colors.black, fontSize: 16),
                                      children: [
                                        const TextSpan(
                                          text: 'Juego: ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: meeting.fkBoardgame.boardgameName),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(color: Colors.black, fontSize: 14),
                                      children: [
                                        const TextSpan(
                                          text: 'Duración: ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: meeting.formatDuration(meeting.meetingDuration)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      Provider.of<MeetingProvider>(context, listen: false)
                                          .deleteMeeting(widget.user.userId, meeting.meetingId);
                                    },
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
