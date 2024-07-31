import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4281164427),
      surfaceTint: Color(4281164427),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4291683839),
      onPrimaryContainer: Color(4278197554),
      secondary: Color(4281033611),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291618303),
      onSecondaryContainer: Color(4278197809),
      tertiary: Color(4285223820),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4293778687),
      onTertiaryContainer: Color(4280684100),
      error: Color(4287646275),
      onError: Color(4294967295),
      errorContainer: Color(4294957781),
      onErrorContainer: Color(4282059015),
      surface: Color(4294441471),
      onSurface: Color(4279770144),
      onSurfaceVariant: Color(4282533710),
      outline: Color(4285692030),
      outlineVariant: Color(4290955215),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281151797),
      inversePrimary: Color(4288334842),
      primaryFixed: Color(4291683839),
      onPrimaryFixed: Color(4278197554),
      primaryFixedDim: Color(4288334842),
      onPrimaryFixedVariant: Color(4278864498),
      secondaryFixed: Color(4291618303),
      onSecondaryFixed: Color(4278197809),
      secondaryFixedDim: Color(4288204025),
      onSecondaryFixedVariant: Color(4278537074),
      tertiaryFixed: Color(4293778687),
      onTertiaryFixed: Color(4280684100),
      tertiaryFixedDim: Color(4292328187),
      onTertiaryFixedVariant: Color(4283645042),
      surfaceDim: Color(4292336351),
      surfaceBright: Color(4294441471),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294046969),
      surfaceContainer: Color(4293652211),
      surfaceContainerHigh: Color(4293322990),
      surfaceContainerHighest: Color(4292928232),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278273646),
      surfaceTint: Color(4281164427),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282808739),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278208365),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282677666),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4283381870),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4286736804),
      onTertiaryContainer: Color(4294967295),
      error: Color(4285411370),
      onError: Color(4294967295),
      errorContainer: Color(4289355863),
      onErrorContainer: Color(4294967295),
      surface: Color(4294441471),
      onSurface: Color(4279770144),
      onSurfaceVariant: Color(4282270538),
      outline: Color(4284112998),
      outlineVariant: Color(4285954946),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281151797),
      inversePrimary: Color(4288334842),
      primaryFixed: Color(4282808739),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4280967305),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282677666),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280836232),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4286736804),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4285092233),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292336351),
      surfaceBright: Color(4294441471),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294046969),
      surfaceContainer: Color(4293652211),
      surfaceContainerHigh: Color(4293322990),
      surfaceContainerHighest: Color(4292928232),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278199356),
      surfaceTint: Color(4281164427),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278273646),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278199611),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4278208365),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281144651),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4283381870),
      onTertiaryContainer: Color(4294967295),
      error: Color(4282650636),
      onError: Color(4294967295),
      errorContainer: Color(4285411370),
      onErrorContainer: Color(4294967295),
      surface: Color(4294441471),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280230954),
      outline: Color(4282270538),
      outlineVariant: Color(4282270538),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281151797),
      inversePrimary: Color(4292865791),
      primaryFixed: Color(4278273646),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278202188),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4278208365),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4278202443),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4283381870),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281868630),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292336351),
      surfaceBright: Color(4294441471),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294046969),
      surfaceContainer: Color(4293652211),
      surfaceContainerHigh: Color(4293322990),
      surfaceContainerHighest: Color(4292928232),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4288334842),
      surfaceTint: Color(4288334842),
      onPrimary: Color(4278203218),
      primaryContainer: Color(4278864498),
      onPrimaryContainer: Color(4291683839),
      secondary: Color(4288204025),
      onSecondary: Color(4278203217),
      secondaryContainer: Color(4278537074),
      onSecondaryContainer: Color(4291618303),
      tertiary: Color(4292328187),
      onTertiary: Color(4282131802),
      tertiaryContainer: Color(4283645042),
      onTertiaryContainer: Color(4293778687),
      error: Color(4294948011),
      onError: Color(4283833881),
      errorContainer: Color(4285740077),
      onErrorContainer: Color(4294957781),
      surface: Color(4279243800),
      onSurface: Color(4292928232),
      onSurfaceVariant: Color(4290955215),
      outline: Color(4287402392),
      outlineVariant: Color(4282533710),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928232),
      inversePrimary: Color(4281164427),
      primaryFixed: Color(4291683839),
      onPrimaryFixed: Color(4278197554),
      primaryFixedDim: Color(4288334842),
      onPrimaryFixedVariant: Color(4278864498),
      secondaryFixed: Color(4291618303),
      onSecondaryFixed: Color(4278197809),
      secondaryFixedDim: Color(4288204025),
      onSecondaryFixedVariant: Color(4278537074),
      tertiaryFixed: Color(4293778687),
      onTertiaryFixed: Color(4280684100),
      tertiaryFixedDim: Color(4292328187),
      onTertiaryFixedVariant: Color(4283645042),
      surfaceDim: Color(4279243800),
      surfaceBright: Color(4281743678),
      surfaceContainerLowest: Color(4278914834),
      surfaceContainerLow: Color(4279770144),
      surfaceContainer: Color(4280033316),
      surfaceContainerHigh: Color(4280756782),
      surfaceContainerHighest: Color(4281414969),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4288598270),
      surfaceTint: Color(4288334842),
      onPrimary: Color(4278196266),
      primaryContainer: Color(4284782017),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4288467198),
      onSecondary: Color(4278196265),
      secondaryContainer: Color(4284651200),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4292591615),
      onTertiary: Color(4280289087),
      tertiaryContainer: Color(4288644546),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281533443),
      errorContainer: Color(4291591026),
      onErrorContainer: Color(4278190080),
      surface: Color(4279243800),
      onSurface: Color(4294572799),
      onSurfaceVariant: Color(4291218387),
      outline: Color(4288586667),
      outlineVariant: Color(4286481547),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928232),
      inversePrimary: Color(4279061619),
      primaryFixed: Color(4291683839),
      onPrimaryFixed: Color(4278194722),
      primaryFixedDim: Color(4288334842),
      onPrimaryFixedVariant: Color(4278204763),
      secondaryFixed: Color(4291618303),
      onSecondaryFixed: Color(4278194977),
      secondaryFixedDim: Color(4288204025),
      onSecondaryFixedVariant: Color(4278204761),
      tertiaryFixed: Color(4293778687),
      onTertiaryFixed: Color(4279960121),
      tertiaryFixedDim: Color(4292328187),
      onTertiaryFixedVariant: Color(4282526560),
      surfaceDim: Color(4279243800),
      surfaceBright: Color(4281743678),
      surfaceContainerLowest: Color(4278914834),
      surfaceContainerLow: Color(4279770144),
      surfaceContainer: Color(4280033316),
      surfaceContainerHigh: Color(4280756782),
      surfaceContainerHighest: Color(4281414969),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294572799),
      surfaceTint: Color(4288334842),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4288598270),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294573055),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4288467198),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965757),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4292591615),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279243800),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294572799),
      outline: Color(4291218387),
      outlineVariant: Color(4291218387),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928232),
      inversePrimary: Color(4278201416),
      primaryFixed: Color(4292209151),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4288598270),
      onPrimaryFixedVariant: Color(4278196266),
      secondaryFixed: Color(4292143615),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4288467198),
      onSecondaryFixedVariant: Color(4278196265),
      tertiaryFixed: Color(4294042111),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4292591615),
      onTertiaryFixedVariant: Color(4280289087),
      surfaceDim: Color(4279243800),
      surfaceBright: Color(4281743678),
      surfaceContainerLowest: Color(4278914834),
      surfaceContainerLow: Color(4279770144),
      surfaceContainer: Color(4280033316),
      surfaceContainerHigh: Color(4280756782),
      surfaceContainerHighest: Color(4281414969),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
