
class Design {
  int designId;
  String name;
  int rate;

  Design({
    required this.designId,
    required this.name,
    required this.rate,
  });

  factory Design.fromJson(Map<String, dynamic> json) {
    return Design(
      designId: json['designId'],
      name: json['name'],
      rate: json['rate'],
    );
  }
}