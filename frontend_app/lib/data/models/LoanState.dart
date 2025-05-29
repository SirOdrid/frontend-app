class LoanState {

  final int loanStateId;
  final String loanStateName;

  LoanState({
    required this.loanStateId, 
    required this.loanStateName
  });

  factory LoanState.fromJson(Map<String, dynamic> json) {
    return LoanState(
      loanStateId: json['loanStateId'],
      loanStateName: json['loanStateName']
    );
  }

  Map<String, dynamic> toJson() => {
    'loanStateId': loanStateId, 
    'loanStateName': loanStateName
    };
}