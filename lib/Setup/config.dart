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
  static List<String> fontFamilys = [MyFonts.gothicA1, MyFonts.notoSans, MyFonts.maruBuriRegular, MyFonts.spoqaHanSansNeoRegular];
  static List<String> borderType = ["테두리 없음", '밑줄', '네모 박스'];
  static List<String> colorStyles = ["색 설정0", "색 설정1", "색 설정2", "색 설정3", "색 설정4", "색 설정5", "색 설정6", "색 설정7", "색 설정8", "색 설정9"];

  //ORDER IN QUESTION, BODY, ANSWER
  static List<double> fontSizes = [];
  static List<FontWeight> fontWeights = [FontWeight.w500, FontWeight.w700, FontWeight.w300];

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
    AppConfig.fontSizes = [AppConfig.fontSize* 1.3, AppConfig.fontSize, AppConfig.fontSize];
  }
}


class MyFonts{
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


}