class Country {
  final int countryId;
  final String countryName;

  Country({
    required this.countryId,
    required this.countryName,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryId: json['countryId'] ?? 0,
      countryName: json['countryName'] ?? '',
    );
  }
}