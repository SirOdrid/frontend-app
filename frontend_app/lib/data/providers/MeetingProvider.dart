import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Meeting.dart';
import 'package:frontend_app/data/repositories/MeetingRepository.dart';


class MeetingProvider with ChangeNotifier {
  final MeetingRepository _meetingRepository = MeetingRepository();

  List<Meeting> _meetings = [];

  List<Meeting> get meetings => _meetings;

  Future<void> deleteMeeting(int idHostUser, int idMeeting) async {
    await _meetingRepository.deleteMeeting(idMeeting);
    getMeetingsByUser(idHostUser);
  }

  Future<void> createMeeting(int idHostUser, Meeting meeting) async {
    await _meetingRepository.createMeeting(meeting);
    getMeetingsByUser(idHostUser);
  }

  Future<List<Meeting>> getMeetingsByUser(int idUser) async {
    _meetings = await _meetingRepository.getMeetingsByUser(idUser);
    notifyListeners();
    return _meetings;
  }

}