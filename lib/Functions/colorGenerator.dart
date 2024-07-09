import 'dart:math';

import 'package:flutter/material.dart';

class ColorSchemeGenerator {
  final Color primaryColor;
  Random random = Random();

  ColorSchemeGenerator(this.primaryColor);

  Color getComplementaryColor() {
    return Color(0xFFFFFF - primaryColor.value);
  }

  Color getSimilarColor() {
    Color complementaryColor = getComplementaryColor();

    //RandomSeed will be int 20 ~ 80
    // 배경색의 명도를 계산합니다.
    double luminance = complementaryColor.computeLuminance();
    Random random = Random();
    int randomSeed1 = random.nextInt(20) + 70;
    int randomSeed2 = random.nextInt(20) + 70;
    int randomSeed3 = random.nextInt(20) + 70;
    // 명도가 0.5보다 크면, 즉 배경색이 밝으면 사용자 정의 "blackish" 색상을 생성합니다.
    if (luminance > 0.5) {
      // 배경색을 기반으로 사용자 정의 검은색을 생성합니다.
      // 여기서는 배경색의 RGB 값을 사용하여 약간 어두운 색상을 생성합니다.
      int r = (complementaryColor.red * 100 / randomSeed1).toInt();
      int g = (complementaryColor.green * 100 / randomSeed2).toInt();
      int b = (complementaryColor.blue * 100 / randomSeed3).toInt();
      return Color.fromRGBO(r, g, b, 1.0);
    } else {
      // 배경색이 어둡다면, 사용자 정의 "whitish" 색상을 생성합니다.
      // 배경색의 RGB 값을 사용하여 약간 밝은 색상을 생성합니다.
      int r = min(255, (complementaryColor.red + randomSeed1).toInt());
      int g = min(255, (complementaryColor.green + randomSeed2).toInt());
      int b = min(255, (complementaryColor.blue + randomSeed3).toInt());
      return Color.fromRGBO(r, g, b, 1.0);
    }
  }

  Color getStandingOutColor() {
    //RandomSeed will be int 20 ~ 80
    // 배경색의 명도를 계산합니다.
    double luminance = primaryColor.computeLuminance();
    Random random = Random();
    int randomSeed1 = random.nextInt(20) + 70;
    int randomSeed2 = random.nextInt(20) + 70;
    int randomSeed3 = random.nextInt(20) + 70;
    // 명도가 0.5보다 크면, 즉 배경색이 밝으면 사용자 정의 "blackish" 색상을 생성합니다.
    if (luminance > 0.5) {
      // 배경색을 기반으로 사용자 정의 검은색을 생성합니다.
      // 여기서는 배경색의 RGB 값을 사용하여 약간 어두운 색상을 생성합니다.
      int r = (primaryColor.red * 100 / randomSeed1).toInt();
      int g = (primaryColor.green * 100 / randomSeed2).toInt();
      int b = (primaryColor.blue * 100 / randomSeed3).toInt();
      return Color.fromRGBO(r, g, b, 1.0);
    } else {
      // 배경색이 어둡다면, 사용자 정의 "whitish" 색상을 생성합니다.
      // 배경색의 RGB 값을 사용하여 약간 밝은 색상을 생성합니다.
      int r = min(255, (primaryColor.red + randomSeed1).toInt());
      int g = min(255, (primaryColor.green + randomSeed2).toInt());
      int b = min(255, (primaryColor.blue + randomSeed3).toInt());
      return Color.fromRGBO(r, g, b, 1.0);
    }
  }
}

ColorScheme deepCopyColorScheme(ColorScheme original) {
  return ColorScheme(
    brightness: original.brightness,
    primary: original.primary,
    onPrimary: original.onPrimary,
    primaryContainer: original.primaryContainer,
    onPrimaryContainer: original.onPrimaryContainer,
    secondary: original.secondary,
    onSecondary: original.onSecondary,
    secondaryContainer: original.secondaryContainer,
    onSecondaryContainer: original.onSecondaryContainer,
    tertiary: original.tertiary,
    onTertiary: original.onTertiary,
    tertiaryContainer: original.tertiaryContainer,
    onTertiaryContainer: original.onTertiaryContainer,
    error: original.error,
    onError: original.onError,
    errorContainer: original.errorContainer,
    onErrorContainer: original.onErrorContainer,
    background: original.background,
    onBackground: original.onBackground,
    surface: original.surface,
    onSurface: original.onSurface,
    surfaceVariant: original.surfaceVariant,
    onSurfaceVariant: original.onSurfaceVariant,
    outline: original.outline,
    onInverseSurface: original.onInverseSurface,
    inverseSurface: original.inverseSurface,
    inversePrimary: original.inversePrimary,
    shadow: original.shadow,
    surfaceTint: original.surfaceTint,
  );
}
