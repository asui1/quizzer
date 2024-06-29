import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

class AppConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double shortestSide = 0;
  static double fontSize = 0;
  static double borderRadius = 0;
  static double smallerPadding = 0;
  static double smallPadding = 0;
  static double padding = 0;
  static double largePadding = 0;
  static double largerPadding = 0;
  static double largestPadding = 0;
  static double iconSize = 0;

  static void setUp(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    shortestSide = MediaQuery.of(context).size.shortestSide;
    AppConfig.fontSize = AppConfig.shortestSide / 20;
    AppConfig.borderRadius = AppConfig.shortestSide / 20;
    AppConfig.padding = AppConfig.shortestSide / 40;
    AppConfig.smallPadding = AppConfig.padding / 2;
    AppConfig.largePadding = AppConfig.padding * 2;
    AppConfig.iconSize = AppConfig.fontSize * 2;
  }
}


class MyFonts{
  static const gothicA1 = 'GothicA1';
  static const gothicA1Bold = 'GothicA1Bold';
  static const gothicA1ExtraBold = 'GothicA1ExtraBold';
  static const gothicA1Medium = 'GothicA1Medium';
  static const gothicA1SemiBold = 'GothicA1SemiBold';
  static const gothicA1Thin = 'GothicA1Thin';

  static const notoSans = 'NotoSansKR';
  static const notoSansBold = 'NotoSansKR-Bold';
  static const notoSansExtraBold = 'NotoSansKR-ExtraBold';
  static const notoSansLight = 'NotoSansKR-Light';
  static const notoSansMedium = 'NotoSansKR-Medium';
  static const notoSansRegular = 'NotoSansKR-Regular';
  static const notoSansThin = 'NotoSansKR-Thin';
  
}