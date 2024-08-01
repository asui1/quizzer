import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:quizzer/Functions/Logger.dart';

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
  static List<String> fontFamilys = [
    MyFonts.gothicA1,
    MyFonts.notoSans,
    MyFonts.maruBuriRegular,
    MyFonts.spoqaHanSansNeoRegular,
    MyFonts.diary,
    MyFonts.ongleYunu,
    MyFonts.ongleEuyen
  ];
  static List<String> borderType = [
    Intl.message("No_Borders"),
    Intl.message("Underline"),
    Intl.message("Box_Border")
  ];
  static List<String> colorStyles = [
    Intl.message("Color_Set") + "0",
    Intl.message("Color_Set") + "1",
    Intl.message("Color_Set") + "2",
    Intl.message("Color_Set") + "3",
    Intl.message("Color_Set") + "4",
    Intl.message("Color_Set") + "5",
    Intl.message("Color_Set") + "6",
    Intl.message("Color_Set") + "7",
    Intl.message("Color_Set") + "8",
    Intl.message("Color_Set") + "9"
  ];

  //ORDER IN QUESTION, BODY, ANSWER
  static List<double> fontSizes = [];
  static List<FontWeight> fontWeights = [
    FontWeight.w500,
    FontWeight.w700,
    FontWeight.w300
  ];

  static void setUp(BuildContext context) {
    Logger.log("Setting up AppConfig");
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    shortestSide = MediaQuery.of(context).size.shortestSide;
    double maxFontSize = 24.0; // 최대 폰트 크기 설정

    if (screenWidth > screenHeight) {
      AppConfig.fontSize = AppConfig.shortestSide / 20 /2;
      AppConfig.borderRadius = AppConfig.shortestSide / 20 /2;
      AppConfig.padding = AppConfig.shortestSide / 40 /2;
      AppConfig.smallPadding = AppConfig.padding / 2;
      AppConfig.smallerPadding = AppConfig.smallPadding / 2;
      AppConfig.largePadding = AppConfig.padding * 2;
      AppConfig.iconSize = AppConfig.fontSize * 2;
      AppConfig.fontSizes = [
        AppConfig.fontSize * 1.3,
        AppConfig.fontSize,
        AppConfig.fontSize
      ];
    } else {
      AppConfig.fontSize = min(shortestSide / 20, maxFontSize);
      AppConfig.borderRadius = AppConfig.shortestSide / 20;
      AppConfig.padding = AppConfig.shortestSide / 40;
      AppConfig.smallPadding = AppConfig.padding / 2;
      AppConfig.smallerPadding = AppConfig.smallPadding / 2;
      AppConfig.largePadding = AppConfig.padding * 2;
      AppConfig.iconSize = AppConfig.fontSize * 2;
      AppConfig.fontSizes = [
        AppConfig.fontSize * 1.3,
        AppConfig.fontSize,
        AppConfig.fontSize
      ];
    }
  }
}

class MyFonts {
  static const count = 13;
  static String getFontByIndex(int index) {
    switch (index) {
      case 0:
        return gothicA1;
      case 1:
        return gothicA1Bold;
      case 2:
        return gothicA1ExtraBold;
      case 3:
        return gothicA1Medium;
      case 4:
        return gothicA1SemiBold;
      case 5:
        return gothicA1Thin;
      case 6:
        return notoSans;
      case 7:
        return notoSansBold;
      case 8:
        return notoSansExtraBold;
      case 9:
        return notoSansLight;
      case 10:
        return notoSansMedium;
      case 11:
        return notoSansRegular;
      case 12:
        return notoSansThin;
      default:
        return '';
    }
  }

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

  static const maruBuriBold = 'MaruBuri-Bold';
  static const maruBuriExtraLight = 'MaruBuri-ExtraLight';
  static const maruBuriLight = 'MaruBuri-Light';
  static const maruBuriRegular = 'MaruBuri';
  static const maruBuriSemiBold = 'MaruBuri-SemiBold';

  static const spoqaHanSansNeoBold = 'SpoqaHanSansNeo-Bold';
  static const spoqaHanSansNeoLight = 'SpoqaHanSansNeo-Light';
  static const spoqaHanSansNeoMedium = 'SpoqaHanSansNeo-Medium';
  static const spoqaHanSansNeoRegular = 'SpoqaHanSansNeo';
  static const spoqaHanSansNeoThin = 'SpoqaHanSansNeo-Thin';

  static const diary = 'Diary';

  static const ongleYunu = 'OngleYunu';

  static const ongleEuyen = 'OngleEuyen';
}
