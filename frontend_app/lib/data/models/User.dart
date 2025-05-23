import 'package:frontend_app/data/models/country.dart';
import 'package:frontend_app/data/models/UserType.dart';

class User {
  final int userId;
  final String userName;
  final String passHash;
  final String email;
  final int birthdayDate;
  final String? profileImage;
  final int? phoneNumber;
  final bool emailNotifications;
  final Country fkCountry;
  final UserType fkUserType;

  User({
    required this.userId,
    required this.userName,
    required this.passHash,
    required this.email,
    required this.birthdayDate,
    this.profileImage,
    this.phoneNumber,
    required this.emailNotifications,
    required this.fkCountry,
    required this.fkUserType,
  });

  int getUserId() => userId;
  String getUserName() => userName;
  String getPassHash() => passHash;
  String getEmail() => email;
  int getBirthdayDate() => birthdayDate;
  String? getProfileImage() => profileImage;
  int? getPhoneNumber() => phoneNumber;
  bool getEmailNotifications() => emailNotifications;
  Country getFkCountry() => fkCountry;
  UserType getFkUserType() => fkUserType;

  // Convierte un JSON a un objeto User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      passHash: json['passHash'] ?? '',
      email: json['email'] ?? '',
      birthdayDate: json['birthdayDate'] ?? 0,
      profileImage: json['profileImage'] ?? '',
      phoneNumber: json['phoneNumber'] ?? 0,
      emailNotifications: json['emailNotifications'] ?? false,
      fkCountry: Country.fromJson(json['fkCountry'] ?? {}),
      fkUserType: UserType.fromJson(json['fkUserType'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userNameRq': userName,
      'passHashRq': passHash,
      'emailRq': email,
      'creationDateRq': birthdayDate,
      'profileImageRq': profileImage,
      'phoneNumberRq': phoneNumber,
      'emailNotificationsRq': emailNotifications,
      'fkCountryNameRq': fkCountry.countryName,
      'fkUserTypeNameRq': fkUserType.userTypeName,
    };
  }
}
