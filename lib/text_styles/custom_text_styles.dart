import 'package:flutter/material.dart';
import '../colors/color_palette.dart';

final TextStyle kDescriptionTextStyle = TextStyle(
  color: kNew9a,
  fontFamily: 'Iowan',
);

final TextStyle kTitle2TextStyle = TextStyle(
    color: kPrimeColor,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    fontFamily: 'Urbanist');

Text kTitleText(String text, [double? size, Color? color, int? maxLines]) {
  return Text(
    text,
    maxLines: maxLines??1,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontFamily: 'Iowan',
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
      color: color ?? kThirdColor,
      fontSize: size ?? 16,
      fontWeight: FontWeight.bold,
    ),
  );
}

Text kDescriptionText(String text) {
  return Text(
    text,
    maxLines: 1,
    style: TextStyle(
      color: kOne,
      overflow: TextOverflow.ellipsis,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
}

Text kDescription2Text(String text) {
  return Text(
    text,
    maxLines: 1,
    style: TextStyle(
      color: kNew7,
      overflow: TextOverflow.ellipsis,
      fontSize: 16,
    ),
  );
}

Text kDescription3Text(String text,
    [Color? color, int? maxLines, double? fontSize, double? height]) {
  return Text(
    text,
    maxLines: maxLines ?? 1,
    style: TextStyle(
        height: height ?? 1,
        fontFamily: 'Iowan',
        fontSize: fontSize ?? 15,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
        color: color ?? kNew9a),
  );
}
