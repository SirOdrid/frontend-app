import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Session.dart';
import 'package:frontend_app/data/repositories/SessionRepository.dart';

class SessionProvider with ChangeNotifier {
  final SessionRepository _sessionRepository = SessionRepository();

  List<Session> _sessions = [];

  List<Session> get sessions => _sessions;

  Future<void> deleteSession(int idSession, int idHostUser) async {
    await _sessionRepository.deleteSession(idSession);
    getSessionsByUser(idHostUser);
  }

  Future<void> updateSession(Session session) async {
    await _sessionRepository.updateSession(session);
    getSessionsByUser(session.fkUser.userId);
  }

  Future<void> createSession(Session session) async {
    await _sessionRepository.createSession(session);
    getSessionsByUser(session.fkUser.userId);
  }

  Future<List<Session>> getSessionsByUser(int idUser) async {
    _sessions = await _sessionRepository.getSessionsByUser(idUser);
    notifyListeners();
    return sessions;
  }

}
