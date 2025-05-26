import 'package:frontend_app/data/models/User.dart';

class UserAssociate {
  final int userAssociateId;
  final User fkHostUser;
  final User fkAssociatedUser;
  final DateTime associationDate;

  UserAssociate({
    required this.userAssociateId,
    required this.fkHostUser,
    required this.fkAssociatedUser,
    required this.associationDate,
  });

  int getUserAssociateId() => userAssociateId;
  User getFkHostUser() => fkHostUser;
  User getFkAssociatedUser() => fkAssociatedUser;
  DateTime getAssociationDate() => associationDate;

  factory UserAssociate.fromJson(Map<String, dynamic> json) {
    return UserAssociate(
      userAssociateId: json['userAssociateId'] ?? 0,
      fkHostUser: User.fromJson(json['fkHostUser'] ?? {}),
      fkAssociatedUser: User.fromJson(json['fkAssociatedUser'] ?? {}),
      associationDate: DateTime.parse(json['associationDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userAssociateId': userAssociateId,
      'fkHostUserId': fkHostUser.getUserId(),
      'fkAssociatedUserId': fkAssociatedUser.getUserId(),
      'associationDate': associationDate.toIso8601String(),
    };
  }
}