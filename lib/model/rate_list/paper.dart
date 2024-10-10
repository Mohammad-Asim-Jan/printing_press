import 'package:printing_press/model/rate_list/size.dart';

class Paper {
  int paperId;
  String name;
  int quality;
  Size size;
  int rate;

  Paper({
    required this.paperId,
    required this.name,
    required this.quality,
    required this.size,
    required this.rate,
  });

  factory Paper.fromJson(Map<String, dynamic> json) {
    return Paper(
      paperId: json['paperId'],
      name: json['name'],
      quality: json['quality'],
      size: Size.fromJson(json['size']),
      rate: json['rate'],
    );
  }
}
