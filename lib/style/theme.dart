import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static const Color loginGradientStart = const Color(0xFF2962ff);
  static const Color loginGradientEnd = const Color(0xFF05e9ff);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static Shader primaryTextGradient = LinearGradient(
    colors: <Color>[loginGradientStart, loginGradientEnd],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


}
