import 'package:frontend_app/data/models/SessionPlayers.dart';
import 'package:frontend_app/data/models/User.dart';

class Session {
  final int sessionId;
  final String sessionName;
  final DateTime sessionDate;
  final User fkUser;
  final List<SessionPlayer> sessionPlayers;

  Session({
    required this.sessionId,
    required this.sessionName,
    required this.sessionDate,
    required this.fkUser,
    required this.sessionPlayers,
  });

  int getSessionId() => sessionId;
  String getSessionName() => sessionName;
  DateTime getSessionDate() => sessionDate;
  User getFkUser() => fkUser;

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['sessionId'] ?? 0,
      sessionName: json['sessionName'] ?? '',
      sessionDate: DateTime.parse(json['sessionDate']),
      fkUser: User.fromJson(json['fkUser']),
      sessionPlayers: (json['sessionPlayers'] as List<dynamic>)
          .map((sp) => SessionPlayer.fromJson(sp as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionNameRq': sessionName,
      'sessionDateRq': sessionDate.toIso8601String(),
      'fkUserRq': fkUser.userId,
      'playerIdsRq': sessionPlayers.map((sp) => sp.fkUser.userId).toList(),
    };
  }
}
