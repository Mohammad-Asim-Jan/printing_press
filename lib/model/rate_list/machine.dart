import 'package:printing_press/model/rate_list/size.dart';

class Machine {
  int machineId;
  String name;
  Size size;
  int plateRate;
  int printingRate;

  Machine({
    required this.machineId,
    required this.name,
    required this.size,
    required this.plateRate,
    required this.printingRate,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      machineId: json['machineId'],
      name: json['name'],
      size: Size.fromJson(json['size']),
      plateRate: json['plateRate'],
      printingRate: json['printingRate'],
    );
  }
}
