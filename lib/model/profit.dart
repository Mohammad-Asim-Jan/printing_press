class Profit {
  int profitId;
  String name;
  int percentage;

  Profit({
    required this.profitId,
    required this.name,
    required this.percentage,
  });

  factory Profit.fromJson(Map<String, dynamic> json) {
    return Profit(
      profitId: json['profitId'],
      name: json['name'],
      percentage: json['percentage'],
    );
  }
}
