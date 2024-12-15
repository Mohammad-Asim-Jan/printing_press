import 'package:flutter/material.dart';
import '../colors/color_palette.dart';

final TextStyle kDescriptionTextStyle = TextStyle(
  color: Colors.blueGrey.shade600,
  fontFamily: 'Iowan',
  fontSize: 12
);

final TextStyle kTitle2TextStyle = TextStyle(
    color: kPrimeColor,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    fontFamily: 'Urbanist');

Text kTitleText(String text, [double? size, Color? color, int? maxLines]) {
  return Text(
    text,
    maxLines: maxLines ?? 1,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontFamily: 'Urbanist',
      overflow: TextOverflow.ellipsis,
      textBaseline: TextBaseline.alphabetic,
      color: color ?? kPrimeColor,
      fontSize: size ?? 16,
      fontWeight:FontWeight.bold ,
    ),
  );
}

Text kDescriptionText(String text, [double? size, Color? color]) {
  return Text(
    text,
    maxLines: 1,
    style: TextStyle(
      color: color?? kPrimeColor,
      overflow: TextOverflow.ellipsis,
      fontSize: size ?? 16,
      fontWeight: FontWeight.w400,
    ),
  );
}

// Text kDescription2Text(String text, [double? fontSize]) {
//   return Text(
//     text,
//     maxLines: 1,
//     style: TextStyle(
//       color: kPrimeColor,
//       overflow: TextOverflow.ellipsis,
//       fontSize: fontSize ?? 16,
//     ),
//   );
// }

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
