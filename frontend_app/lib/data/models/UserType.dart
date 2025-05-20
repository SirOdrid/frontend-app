class UserType {
  final int userTypeId;
  final String userTypeName;

  UserType({
    required this.userTypeId,
    required this.userTypeName,
  });

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(
      userTypeId: json['userTypeId'] ?? 0,
      userTypeName: json['userTypeName'] ?? '',
    );
  }
}