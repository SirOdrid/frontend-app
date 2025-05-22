class UserLogin {

  final String userName;
  final String passHash;

  UserLogin({
    required this.userName,
    required this.passHash,
  });

  String getUserName() => userName;
  String getPassHash() => passHash;

  Map<String, dynamic> toJson() {
    return {
      'userEmailRq': userName,
      'passHashRq': passHash,
    };
  }
}