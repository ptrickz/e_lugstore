// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'dart:ui';

//COLORS

//System Color
Color accent = const Color.fromRGBO(108, 99, 255, 1.0);
Color accentHover = const Color.fromRGBO(76, 65, 255, 0.8);

//Text Color
Color textPrimary = const Color(0x000000);
Color textSecondary = const Color(0x545454);
Color textTertiary = const Color(0x868686);
Color textWhite = const Color(0xFFFFFF);

//Background Color
Color backgroundPrimary = const Color(0xFFFFFF);
Color backgroundSecondary = const Color(0xD9D9D9);
Color backgroundTertiary = const Color(0xC2C2C2);

//TEXT STYLES

//Headings
TextStyle? heading1 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
);

TextStyle? heading2 = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

TextStyle? heading3 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
);

//Labels
TextStyle? labelMedium = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

TextStyle? labelSmall = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

//Captions
TextStyle? captionNormal = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: textSecondary,
);

TextStyle captionItalic = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.italic,
  color: textSecondary,
);
