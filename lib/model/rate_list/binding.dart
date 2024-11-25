class Binding {
  int bindingId;
  String name;
  int rate;

  Binding({
    required this.bindingId,
    required this.name,
    required this.rate,
  });

  factory Binding.fromJson(Map<String, dynamic> json) {
    return Binding(
      bindingId: json['bindingId'],
      name: json['name'],
      rate: json['rate'],
    );
  }
}