
import 'package:flutter/material.dart';

class MyColors {
  Color red = Color.fromARGB(255, 247, 52, 52);
  Color green = Color.fromARGB(255, 76, 175, 80);
  Color orange = Color.fromARGB(255, 255, 127, 0);

  Color color1 = Color(0xff9FA5BF);
  Color color2 = Color(0xff9FBABF);
  Color color3 = Color(0xff94CBFF);
  Color color4 = Color(0xff221E40);
  Color color5 = Color(0xff1E403A);
  Color color6 = Color(0xff1E2540);
  Color color7 = Color(0xff1E3A40);
  Color color8 = Color(0xff9ED0FF);
  Color color9 = Color(0xff1605C80);
  Color color10 = Color(0xff5C807A);
  Color color11 = Color(0xff5C6380);
  Color color12 = Color(0xff5C7A80);
  Color color13 = Color(0xffD1E9FF);
  Color color14 = Color(0xffA39FBF);
  Color color15 = Color(0xff9FBFBA);
  Color color16 = Color(0xff94EDFF);
  Color color17 = Color(0xff94A9FF);
  Color color18 = Color(0xff94FFEE);
  Color color19 = Color(0xffA194FF);
  Color color20 = Color(0xffC7E4FF);
  
}

ColorScheme MyLightColorScheme = ColorScheme.light(
  primary: Color(0xff2d628b),
  onPrimary: Color(0xffffffff),
  secondary: Color(0xff51606f),
  onSecondary: Color(0xffffffff),
  tertiary: Color(0xff67587a),
  onTertiary: Color(0xffffffff),
  error: Color(0xffba1a1a),
  onError: Color(0xffffffff),
  primaryContainer: Color(0xffcde5ff),
  onPrimaryContainer: Color(0xff001d32),
  secondaryContainer: Color(0xffd4e4f6),
  onSecondaryContainer: Color(0xff0d1d2a),
  tertiaryContainer: Color(0xffeddcff),
  onTertiaryContainer: Color(0xff221533),
  errorContainer: Color(0xffffdad6),
  onErrorContainer: Color(0xff410002),
  surfaceDim: Color(0xffd7dadf),
  surface: Color(0xfff7f9ff),
  surfaceBright: Color(0xfff7f9ff),
  surfaceContainerLowest: Color(0xffffffff),
  surfaceContainerLow: Color(0xfff1f4f9),
  surfaceContainer: Color(0xffebeef3),
  surfaceContainerHigh: Color(0xffe6e8ee),
  surfaceContainerHighest: Color(0xffe0e2e8),
  onSurface: Color(0xff181c20),
  onSurfaceVariant: Color(0xff42474e),
  outline: Color(0xff72787e),
  outlineVariant: Color(0xffc2c7ce),
  inverseSurface: Color(0xff2d3135),
  onInverseSurface: Color(0xffeef1f6),
  inversePrimary: Color(0xff99ccfa),
  scrim: Color(0xff000000),
  shadow: Color(0xff000000),
);

ColorScheme MyDarkColorScheme = ColorScheme.dark(
  primary: Color(0xff99ccfa),
  onPrimary: Color(0xff003352),
  secondary: Color(0xffb8c8da),
  onSecondary: Color(0xff233240),
  tertiary: Color(0xffd2bfe7),
  onTertiary: Color(0xff382a4a),
  error: Color(0xffffb4ab),
  onError: Color(0xff690005),
  primaryContainer: Color(0xff094a72),
  onPrimaryContainer: Color(0xffcde5ff),
  secondaryContainer: Color(0xff394857),
  onSecondaryContainer: Color(0xffd4e4f6),
  tertiaryContainer: Color(0xff4f4061),
  onTertiaryContainer: Color(0xffeddcff),
  errorContainer: Color(0xff93000a),
  onErrorContainer: Color(0xffffdad6),
  surfaceDim: Color(0xff101418),
  surface: Color(0xff101418),
  surfaceBright: Color(0xff36393e),
  surfaceContainerLowest: Color(0xff0b0f12),
  surfaceContainerLow: Color(0xff181c20),
  surfaceContainer: Color(0xff1c2024),
  surfaceContainerHigh: Color(0xff272a2e),
  surfaceContainerHighest: Color(0xff313539),
  onSurface: Color(0xffe0e2e8),
  onSurfaceVariant: Color(0xffc2c7ce),
  outline: Color(0xff8c9198),
  outlineVariant: Color(0xff42474e),
  inverseSurface: Color(0xffe0e2e8),
  onInverseSurface: Color(0xff2d3135),
  inversePrimary: Color(0xff2d628b),
  scrim: Color(0xff000000),
  shadow: Color(0xff000000),

);

ColorScheme updatePrimaryColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  // 기존 ColorScheme 객체의 속성을 유지하면서 primary 색상만 변경
  return scheme.copyWith(primary: newColor);
}

ColorScheme updateSecondaryColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(secondary: newColor);
}

ColorScheme updateTertiaryColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(tertiary: newColor);
}

ColorScheme updateOnPrimaryColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(onPrimary: newColor);
}

ColorScheme updateOnSecondaryColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(onSecondary: newColor);
}

ColorScheme updateOnTertiaryColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(onTertiary: newColor);
}

ColorScheme updatePrimaryContainerColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(primaryContainer: newColor);
}

ColorScheme updateOnPrimaryContainerColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(onPrimaryContainer: newColor);
}

ColorScheme updateSecondaryContainerColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(secondaryContainer: newColor);
}

ColorScheme updateOnSecondaryContainerColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(onSecondaryContainer: newColor);
}

ColorScheme updateTertiaryContainerColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(tertiaryContainer: newColor);
}

ColorScheme updateOnTertiaryContainerColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(onTertiaryContainer: newColor);
}

ColorScheme updateErrorColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(error: newColor);
}

ColorScheme updateOnErrorColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(onError: newColor);
}

ColorScheme updateErrorContainerColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(errorContainer: newColor);
}

ColorScheme updateOnErrorContainerColorUsingCopyWith(ColorScheme scheme, Color newColor) {
  return scheme.copyWith(onErrorContainer: newColor);
}

// Step 1: Convert Color to String
String colorToString(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0')}';
}

// Step 3: Deserialize Color from String
Color stringToColor(String colorString) {
  int value = int.parse(colorString.substring(1, 9), radix: 16);
  return Color(value);
}

// Step 4: Deserialize ColorScheme from JSON
ColorScheme jsonToColorScheme(Map<String, dynamic> json) {
  return ColorScheme(
    brightness: json['brightness'] == 'Brightness.dark' ? Brightness.dark : Brightness.light,
    primary: stringToColor(json['primary']),
    onPrimary: stringToColor(json['onPrimary']),
    primaryContainer: stringToColor(json['primaryContainer']),
    onPrimaryContainer: stringToColor(json['onPrimaryContainer']),
    primaryFixed: stringToColor(json['primaryFixed']),
    primaryFixedDim: stringToColor(json['primaryFixedDim']),
    onPrimaryFixed: stringToColor(json['onPrimaryFixed']),
    onPrimaryFixedVariant: stringToColor(json['onPrimaryFixedVariant']),
    secondary: stringToColor(json['secondary']),
    onSecondary: stringToColor(json['onSecondary']),
    secondaryContainer: stringToColor(json['secondaryContainer']),
    onSecondaryContainer: stringToColor(json['onSecondaryContainer']),
    secondaryFixed: stringToColor(json['secondaryFixed']),
    secondaryFixedDim: stringToColor(json['secondaryFixedDim']),
    onSecondaryFixed: stringToColor(json['onSecondaryFixed']),
    onSecondaryFixedVariant: stringToColor(json['onSecondaryFixedVariant']),
    tertiary: stringToColor(json['tertiary']),
    onTertiary: stringToColor(json['onTertiary']),
    tertiaryContainer: stringToColor(json['tertiaryContainer']),
    onTertiaryContainer: stringToColor(json['onTertiaryContainer']),
    tertiaryFixed: stringToColor(json['tertiaryFixed']),
    tertiaryFixedDim: stringToColor(json['tertiaryFixedDim']),
    onTertiaryFixed: stringToColor(json['onTertiaryFixed']),
    onTertiaryFixedVariant: stringToColor(json['onTertiaryFixedVariant']),
    error: stringToColor(json['error']),
    onError: stringToColor(json['onError']),
    errorContainer: stringToColor(json['errorContainer']),
    onErrorContainer: stringToColor(json['onErrorContainer']),
    surfaceDim: stringToColor(json['surfaceDim']),
    surface: stringToColor(json['surface']),
    onSurface: stringToColor(json['onSurface']),
    surfaceBright: stringToColor(json['surfaceBright']),
    surfaceContainerLowest: stringToColor(json['surfaceContainerLowest']),
    surfaceContainerLow: stringToColor(json['surfaceContainerLow']),
    surfaceContainer: stringToColor(json['surfaceContainer']),
    surfaceContainerHigh: stringToColor(json['surfaceContainerHigh']),
    surfaceContainerHighest: stringToColor(json['surfaceContainerHighest']),
    onSurfaceVariant: stringToColor(json['onSurfaceVariant']),
    outline: stringToColor(json['outline']),
    outlineVariant: stringToColor(json['outlineVariant']),
    shadow: stringToColor(json['shadow']),
    scrim: stringToColor(json['scrim']),
    inverseSurface: stringToColor(json['inverseSurface']),
    onInverseSurface: stringToColor(json['onInverseSurface']),
    inversePrimary: stringToColor(json['inversePrimary']),
    surfaceTint: stringToColor(json['surfaceTint']),
  );
}

// Step 2: Serialize ColorScheme
Map<String, dynamic> colorSchemeToJson(ColorScheme colorScheme) {
  return {
    'brightness': colorScheme.brightness.toString(),
    'primary': colorToString(colorScheme.primary),
    'onPrimary': colorToString(colorScheme.onPrimary),
    'primaryContainer': colorToString(colorScheme.primaryContainer),
    'onPrimaryContainer': colorToString(colorScheme.onPrimaryContainer),
    'primaryFixed': colorToString(colorScheme.primaryFixed),
    'primaryFixedDim': colorToString(colorScheme.primaryFixedDim),
    'onPrimaryFixed': colorToString(colorScheme.onPrimaryFixed),
    'onPrimaryFixedVariant': colorToString(colorScheme.onPrimaryFixedVariant),
    'secondary': colorToString(colorScheme.secondary),
    'onSecondary': colorToString(colorScheme.onSecondary),
    'secondaryContainer': colorToString(colorScheme.secondaryContainer),
    'onSecondaryContainer': colorToString(colorScheme.onSecondaryContainer),
    'secondaryFixed': colorToString(colorScheme.secondaryFixed),
    'secondaryFixedDim': colorToString(colorScheme.secondaryFixedDim),
    'onSecondaryFixed': colorToString(colorScheme.onSecondaryFixed),
    'onSecondaryFixedVariant': colorToString(colorScheme.onSecondaryFixedVariant),
    'tertiary': colorToString(colorScheme.tertiary),
    'onTertiary': colorToString(colorScheme.onTertiary),
    'tertiaryContainer': colorToString(colorScheme.tertiaryContainer),
    'onTertiaryContainer': colorToString(colorScheme.onTertiaryContainer),
    'tertiaryFixed': colorToString(colorScheme.tertiaryFixed),
    'tertiaryFixedDim': colorToString(colorScheme.tertiaryFixedDim),
    'onTertiaryFixed': colorToString(colorScheme.onTertiaryFixed),
    'onTertiaryFixedVariant': colorToString(colorScheme.onTertiaryFixedVariant),
    'error': colorToString(colorScheme.error),
    'onError': colorToString(colorScheme.onError),
    'errorContainer': colorToString(colorScheme.errorContainer),
    'onErrorContainer': colorToString(colorScheme.onErrorContainer),
    'surfaceDim': colorToString(colorScheme.surfaceDim),
    'surface': colorToString(colorScheme.surface),
    'onSurface': colorToString(colorScheme.onSurface),
    'surfaceBright': colorToString(colorScheme.surfaceBright),
    'surfaceContainerLowest': colorToString(colorScheme.surfaceContainerLowest),
    'surfaceContainerLow': colorToString(colorScheme.surfaceContainerLow),
    'surfaceContainer': colorToString(colorScheme.surfaceContainer),
    'surfaceContainerHigh': colorToString(colorScheme.surfaceContainerHigh),
    'surfaceContainerHighest': colorToString(colorScheme.surfaceContainerHighest),
    'onSurfaceVariant': colorToString(colorScheme.onSurfaceVariant),
    'outline': colorToString(colorScheme.outline),
    'outlineVariant': colorToString(colorScheme.outlineVariant),
    'shadow': colorToString(colorScheme.shadow),
    'scrim': colorToString(colorScheme.scrim),
    'inverseSurface': colorToString(colorScheme.inverseSurface),
    'onInverseSurface': colorToString(colorScheme.onInverseSurface),
    'inversePrimary': colorToString(colorScheme.inversePrimary),
    'surfaceTint': colorToString(colorScheme.surfaceTint),
  };
}
