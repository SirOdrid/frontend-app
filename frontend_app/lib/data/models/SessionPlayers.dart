
import 'package:frontend_app/data/models/User.dart';

class SessionPlayer {
  final int sessionPlayerId;
  final User fkUser;

  SessionPlayer({
    required this.sessionPlayerId,
    required this.fkUser,
  });

  factory SessionPlayer.fromJson(Map<String, dynamic> json) {
    return SessionPlayer(
      sessionPlayerId: json['sessionPlayerId'] ?? 0,
      fkUser: User.fromJson(json['fkUser'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionPlayerId': sessionPlayerId,
      'fkUser': fkUser.toJson(),
    };
  }
}
