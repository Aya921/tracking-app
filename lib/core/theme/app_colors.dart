import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color gray=Color(0xFF535353);
  static const Color red=Color(0xFFCC1010);
  static const Color green=Color(0xFF11CE19);
  static const Color lightPink=Color(0xFFF9ECF0);
  static const Color lightGray=Color(0xFFA6A6A6);
  static const Color lightGray30 = Color(0x4DD3D3D3); 
  static const Color midGray=Color(0xFF878787);
  static const Color midgreen=Color(0xffE0FDE1);

  static const MaterialColor pink=MaterialColor
    (0xFFD21E6A, <int , Color>{
    10: Color(0xFFf6d2e1),
    20: Color(0xFFf0b4cd),
    30: Color(0xFFe98fb5),
    40: Color(0xFFe1699c),
    50: Color(0xFFda4483),
    0: Color(0xFFD21E6A),
    60: Color(0xFFaf1958),
    70: Color(0xFF8c1447),
    80: Color(0xFF690f35),
    90: Color(0xFF460a23),
    100: Color(0xFF2a0615),
  });

static const MaterialColor black = MaterialColor(
  0xFF000000,
  <int, Color>{
    10: Color(0xFFCECFD0),
    20: Color(0xFFAEAFB1),
    30: Color(0xFF86888A),
    40: Color(0xFF5D6063),
    50: Color(0xFF34383C),
    55: Color(0xFF1D1B20),
    0:  Color(0xFF0C1015),
    60: Color(0xFF0A0D12),
    70: Color(0xFF080B0E),
    80: Color(0xFF06080B),
    90: Color(0xFF040507),
    100: Color(0xFF020304),
  },
);



  static const  MaterialColor white=MaterialColor(0xFFF9F9F9, <int , Color>{
    10: Color(0xFFfefefe),
    20: Color(0xFFfdfdfd),
    30: Color(0xFFfcfcfc),
    40: Color(0xFFfbfbfb),
    50: Color(0xFFfafafa),
    0: Color(0xFFF9F9F9),
    60: Color(0xFFd0d0d0),
    70: Color(0xFFa6a6a6),
    80: Color(0xFF7d7d7d),
    90: Color(0xFF535353),
    100: Color(0xFF323232),
  });
}