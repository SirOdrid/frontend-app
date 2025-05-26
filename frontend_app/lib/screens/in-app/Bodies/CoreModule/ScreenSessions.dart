import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Session.dart';
import 'package:frontend_app/data/models/SessionPlayers.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/models/UserAssociate.dart';
import 'package:frontend_app/data/providers/MeetingProvider.dart';
import 'package:frontend_app/data/providers/SessionProvider.dart';
import 'package:frontend_app/data/providers/UserAssociateProvider.dart';
import 'package:frontend_app/widgets/TextFormField.dart';
import 'package:frontend_app/widgets/elements/DatePicker.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ScreenSessions extends StatefulWidget {
  const ScreenSessions({super.key, required this.user});
  final User user;

  @override
  State<ScreenSessions> createState() => _ScreenSessionsState();
}

class _ScreenSessionsState extends State<ScreenSessions> {
  bool _showForm = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _formSessionName = '';
  List<UserAssociate> _selectedUsers = [];
  DateTime? _selectedDate;
  late DateTime _sessionDate;

  void _toggleForm() {
    setState(() {
      _showForm = !_showForm;
    });
  }


void _submitForm() {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  // Validar fecha seleccionada: debe ser hoy o posterior
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
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
          backgroundColor: Colors.grey[900], // fondo gris oscuro
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
    return; // Salir para evitar seguir con el submit
  }

  _formKey.currentState!.save();

  _sessionDate = DateTime(
    _selectedDate!.year,
    _selectedDate!.month,
    _selectedDate!.day,
  );

  List<SessionPlayer> sessionPlayers = [];

  for (UserAssociate userAssoc in _selectedUsers) {
    sessionPlayers.add(SessionPlayer(
      sessionPlayerId: 0,
      fkUser: userAssoc.fkAssociatedUser,
    ));
  }

  final newSession = Session(
    sessionId: 0,
    sessionName: _formSessionName,
    sessionDate: _sessionDate,
    fkUser: widget.user,
    sessionPlayers: sessionPlayers,
  );

  Provider.of<SessionProvider>(context, listen: false).createSession(newSession);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Sesión creada exitosamente')),
  );

  setState(() {
    _showForm = false;
  });
}


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SessionProvider>(context, listen: false)
          .getSessionsByUser(widget.user.userId);
      Provider.of<MeetingProvider>(context, listen: false)
          .getMeetingsByUser(widget.user.userId);
      Provider.of<UserAssociateProvider>(context, listen: false)
          .fetchAssociates(widget.user.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAssociateProvider = Provider.of<UserAssociateProvider>(context);
    final associatedUsers = userAssociateProvider.associations;
    return Consumer2<SessionProvider, MeetingProvider>(
        builder: (context, sessionProvider, meetingProvider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Listado Sesiones",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            standardButton(
                _showForm ? 'Minimizar' : 'Nueva sesión', _toggleForm),
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
                        StandardTextFormField(
                          labelText: 'Nombre de la Sesión *',
                          hintText: 'Introduce un nombre...',
                          obscureText: false,
                          onSaved: (newValue) => _formSessionName = newValue!,
                          onlyNumbers: false,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Campo obligatorio'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        DateSelectorDropdown(
                          onDateChanged: (date) {
                            _selectedDate = date;
                          },
                          initialDate: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ),
                        ),
                        const SizedBox(height: 12),
                        MultiSelectDialogField<UserAssociate>(
                          items: associatedUsers
                              .map((user) => MultiSelectItem(
                                  user, user.fkAssociatedUser.userName))
                              .toList(),
                          title: const Text(
                            "Jugadores",
                            style: TextStyle(color: Colors.white),
                          ),
                          buttonIcon: const Icon(
                            Icons.people,
                            color: Colors.white,
                          ),
                          selectedColor: Colors.green,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 60, 43, 148),),
                          buttonText: const Text(
                            "Seleccionar jugadores",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                            ),
                          ),
                          dialogWidth: 300,
                          dialogHeight: 400,
                          backgroundColor: Colors.grey[900],
                          itemsTextStyle: const TextStyle(color: Colors.white),
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
                              _selectedUsers = values;
                            });
                          },
                          chipDisplay: MultiSelectChipDisplay(                  
                            chipColor: Colors.green,
                            textStyle: const TextStyle(color: Colors.white),
                            onTap: (value) {
                              setState(() {
                                _selectedUsers.remove(value);
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        standardButton('Crear sesión', _submitForm),
                      ],
                    ),
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: sessionProvider.sessions.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay sesiones registradas",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: sessionProvider.sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessionProvider.sessions[index];
                        return Card(
                          child: ListTile(
                            title: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                                children: [
                                  TextSpan(
                                    text: session.sessionName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(text: ' - '),
                                  TextSpan(
                                    text: DateFormat('dd/MM/yyyy')
                                        .format(session.sessionDate.toLocal()),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                children: [
                                  const TextSpan(
                                    text: 'Jugadores: Tú, ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: session.sessionPlayers
                                        .map((player) => player.fkUser.userName)
                                        .join(', '),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.green),
                                  onPressed: () {
                                    // Provider.of<SessionProvider>(context, listen: false)
                                    //   .deleteSession(sessionProvider.sessions[index].sessionId);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    Provider.of<SessionProvider>(context,
                                            listen: false)
                                        .deleteSession(
                                            sessionProvider
                                                .sessions[index].sessionId,
                                            widget.user.userId);
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
    });
  }
}
