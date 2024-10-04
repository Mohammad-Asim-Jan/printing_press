class Numbering {
  int numberingId;
  String name;
  int rate;

  Numbering({
    required this.numberingId,
    required this.name,
    required this.rate,
  });

  factory Numbering.fromJson(Map<String, dynamic> json) {
    return Numbering(
      numberingId: json['numberingId'],
      name: json['name'],
      rate: json['rate'],
    );
  }
}
