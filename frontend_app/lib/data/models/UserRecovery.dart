class UserRecovery {

  final String emailRecovery;


  UserRecovery({
    required this.emailRecovery,
  });

  String getEmailRecovery() => emailRecovery;

  Map<String, dynamic> toJson() {
    return {
      'emailRecoveryRq': emailRecovery,
    };
  }
}