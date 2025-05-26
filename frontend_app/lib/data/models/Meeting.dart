import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/data/models/Session.dart';

class Meeting {
  final int meetingId;
  final Session fkSession;
  final Boardgame fkBoardgame;
  final Duration meetingDuration;

  Meeting({
    required this.meetingId,
    required this.fkSession,
    required this.fkBoardgame,
    required this.meetingDuration,
  });

  int getMeetingId() => meetingId;
  Session getFkSession() => fkSession;
  Boardgame getFkBoardgame() => fkBoardgame;
  Duration getMeetingDuration() => meetingDuration;

  factory Meeting.fromJson(Map<String, dynamic> json) {
    // Espera un formato tipo 'HH:mm:ss'
    final durationParts = (json['meetingDuration'] ?? '00:00:00').split(':');
    final duration = Duration(
      hours: int.parse(durationParts[0]),
      minutes: int.parse(durationParts[1]),
      seconds: int.parse(durationParts[2]),
    );

    return Meeting(
      meetingId: json['meetingId'] ?? 0,
      fkSession: Session.fromJson(json['fkSession'] ?? {}),
      fkBoardgame: Boardgame.fromJson(json['fkBoardgame'] ?? {}),
      meetingDuration: duration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FkSessionRq': fkSession.sessionId,
      'FkBoardgameRq': fkBoardgame.boardgameId,
      'meetingDurationRq': formatDuration(meetingDuration),
    };
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}
