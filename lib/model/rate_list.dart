import 'dart:core';
///todo: from-json and to-json

class RateList {
  List<Standard> bending;
  List<Standard> numbering;
  List<int> profit;
  List<Standard> designs;
  List<Standard> paperCutting;
  List<Paper> paper;
  List<Machine> machines;

  RateList({
    required this.designs,
    required this.paper,
    required this.paperCutting,
    required this.machines,
    required this.bending,
    required this.numbering,
    required this.profit,
  });

  factory RateList.fromJson(Map<String, dynamic> json) {
    return RateList(
      designs:
          (json['designs'] as List).map((e) => Standard.fromJson(e)).toList(),
      paper: (json['paper'] as List).map((e) => Paper.fromJson(e)).toList(),
      paperCutting:
          (json['paperCutting'] as List).map((e) => Standard.fromJson(e)).toList(),
      machines: (json['machines'] as List).map((e) => Machine.fromJson(e)).toList(),
      bending: (json['bending'] as List).map((e) => Standard.fromJson(e)).toList(),
      numbering: (json['numbering'] as List).map((e) => Standard.fromJson(e)).toList(),
      profit: (json['profit'] as List).map((e) => e as int).toList(),
    );
  }
}

class Standard {
  String name;
  int rate;

  Standard({
    required this.name,
    required this.rate,
  });

  factory Standard.fromJson(Map<String, dynamic> json) {
    return Standard(
      name: json['name'],
      rate: json['rate'],
    );
  }
}

class Machine {
  String name;
  Size size;
  int plate;
  int printing;

  Machine({
    required this.name,
    required this.size,
    required this.plate,
    required this.printing,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      name: json['name'],
      size: Size.fromJson(json['size']),
      plate: json['plate'],
      printing: json['printing'],
    );
  }
}

class Size {
  int width;
  int height;

  Size({
    required this.width,
    required this.height,
  });

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      width: json['width'],
      height: json['height'],
    );
  }
}

class Paper {
  String name;
  int quality;
  Size size;
  int rate;

  Paper({
    required this.name,
    required this.quality,
    required this.size,
    required this.rate,
  });

  factory Paper.fromJson(Map<String, dynamic> json) {
    return Paper(
      name: json['name'],
      quality: json['quality'],
      size: Size.fromJson(json['size']),
      rate: json['rate'],
    );
  }
}


