
class PaperCutting {
  int paperCuttingId;
  String name;
  int rate;

  PaperCutting({
    required this.paperCuttingId,
    required this.name,
    required this.rate,
  });

  factory PaperCutting.fromJson(Map<String, dynamic> json) {
    return PaperCutting(
      paperCuttingId: json['paperCuttingId'],
      name: json['name'],
      rate: json['rate'],
    );
  }
}