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