import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/models/UserAssociate.dart';
import 'package:frontend_app/data/repositories/UserAssociateRepository.dart';

class UserAssociateProvider with ChangeNotifier {
  final UserAssociateRepository _userAssociateRepository =
      UserAssociateRepository();

  List<UserAssociate> _associations = [];
  List<UserAssociate> _associates = [];

  List<UserAssociate> get associations => _associations;
  List<UserAssociate> get associates => _associates;

  Future<List<UserAssociate>> fetchAssociations(int idActiveUser) async {
    _associations =
        await _userAssociateRepository.getAssociations(idActiveUser);
    notifyListeners();
    return _associations;
  }

  Future<List<UserAssociate>> fetchAssociates(int idActiveUser) async {
    _associates = await _userAssociateRepository.getAssociates(idActiveUser);
    notifyListeners();
    return _associates;
  }

  Future<void> addAssociation(User userHost, User activeUser) async {
    await _userAssociateRepository.addAssociation(userHost, activeUser);
    fetchAssociations(activeUser.userId);
    fetchAssociates(userHost.userId);
  }

  Future<void> deleteAssociation(int idAssociation, int idActiveUser) async {
    await _userAssociateRepository.deleteAssociation(idAssociation.toString());
    fetchAssociations(idActiveUser);
    fetchAssociates(idActiveUser);
  }

  int getParticularAssociatesCount() {
    return _associates
        .where((associate) =>
            associate.fkAssociatedUser.fkUserType.userTypeName == "Particular")
        .length;
  }

  int getNonParticularAssociatesCount() {
    return _associates
        .where((associate) =>
            associate.fkAssociatedUser.fkUserType.userTypeName != "Particular")
        .length;
  }

  int getRecentAssociatesCount() {
    final DateTime now = DateTime.now();
    final DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));

    return _associates.where((associate) {
      return associate.associationDate.isAfter(thirtyDaysAgo);
    }).length;
  }
}
