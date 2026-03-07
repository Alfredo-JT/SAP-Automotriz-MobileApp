import 'package:flutter/material.dart';

class AppColors {
  // Rojos principales
  static const Color crimsonRed = Color(0xFFEA1D24); // primary
  static const Color deepRed = Color(0xFFD22530); // primaryContainer
  static const Color darkRed = Color(0xFFBE383E); // secondary
  static const Color rosePink = Color(0xFFCA696B); // secondaryContainer
  static const Color blushPink = Color(0xFFF0B2B3); // tertiary / error suave
  // Neutros
  static const Color creamWhite = Color(0xFFFBF4EC); // background / surface
  static const Color charcoal = Color(0xFF1D1A1B); // onBackground / onSurface
  static const Color warmGray = Color(0xFF8F8B8A); // outline / disabled
  // Acento
  static const Color golden = Color(0xFFE6BD5F); // tertiaryContainer / acento
  // Blancos y negros
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

// ─── AppTheme ────────────────────────────────────────────────────────────────
class AppTheme {
  final colorLightAppScheme = const ColorScheme(
    brightness: Brightness.light,

    // Primarios
    primary: AppColors.crimsonRed,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.deepRed,
    onPrimaryContainer: AppColors.creamWhite,
    // Secundarios
    secondary: AppColors.darkRed,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.rosePink,
    onSecondaryContainer: AppColors.white,
    // Terciarios (acento dorado)
    tertiary: AppColors.golden,
    onTertiary: AppColors.charcoal,
    tertiaryContainer: AppColors.blushPink,
    onTertiaryContainer: AppColors.charcoal,

    // Error
    error: AppColors.crimsonRed,
    onError: AppColors.white,
    errorContainer: AppColors.blushPink,
    onErrorContainer: AppColors.charcoal,

    // Superficie y fondo
    surface: AppColors.creamWhite,
    onSurface: AppColors.charcoal,
    surfaceContainerHighest: Color(0xFFF5EDE4),
    onSurfaceVariant: AppColors.warmGray,

    // Outline
    outline: AppColors.warmGray,
    outlineVariant: AppColors.blushPink,

    // Sombra e inversión
    shadow: AppColors.charcoal,
    scrim: AppColors.charcoal,
    inverseSurface: AppColors.charcoal,
    onInverseSurface: AppColors.creamWhite,
    inversePrimary: AppColors.blushPink,
  );

  // ─── TextTheme ─────────────────────────────────────────────────────────────
  final appTextTheme = const TextTheme(
    // Títulos
    titleLarge: TextStyle(
      fontSize: 22,
      color: AppColors.charcoal,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      color: AppColors.charcoal,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      color: AppColors.charcoal,
      fontWeight: FontWeight.w500,
    ),

    // Display — displaySmall se usa para mostrar errores
    displayLarge: TextStyle(
      fontSize: 26,
      color: AppColors.crimsonRed,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: TextStyle(
      fontSize: 14,
      color: AppColors.crimsonRed,
      fontWeight: FontWeight.w400,
    ),

    // Cuerpo
    bodyLarge: TextStyle(fontSize: 18, color: AppColors.charcoal),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.charcoal),
    bodySmall: TextStyle(fontSize: 14, color: AppColors.warmGray),

    // Etiquetas
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.charcoal,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.charcoal,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.warmGray,
    ),
  );

  // ─── IconTheme ─────────────────────────────────────────────────────────────
  final iconTheme = const IconThemeData(color: AppColors.crimsonRed, size: 24);

  // ─── ElevatedButton ────────────────────────────────────────────────────────
  final appElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.crimsonRed,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.warmGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  // ─── OutlinedButton ────────────────────────────────────────────────────────
  final appOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.crimsonRed,
      side: const BorderSide(color: AppColors.crimsonRed),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  // ─── TextButton ────────────────────────────────────────────────────────────
  final appTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.crimsonRed,
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );

  // ─── InputDecoration ───────────────────────────────────────────────────────
  final appInputDecorationTheme = const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    iconColor: AppColors.crimsonRed,
    prefixIconColor: AppColors.crimsonRed,
    suffixIconColor: AppColors.crimsonRed,
    labelStyle: TextStyle(color: AppColors.warmGray, fontSize: 14),
    floatingLabelStyle: TextStyle(
      color: AppColors.crimsonRed,
      fontWeight: FontWeight.w500,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.warmGray),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.warmGray),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.crimsonRed, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.crimsonRed),
    ),
  );

  // ─── getTheme ───────────────────────────────────────────────────────────────
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorScheme: colorLightAppScheme,
    textTheme: appTextTheme,
    iconTheme: iconTheme,
    elevatedButtonTheme: appElevatedButtonTheme,
    outlinedButtonTheme: appOutlinedButtonTheme,
    textButtonTheme: appTextButtonTheme,
    inputDecorationTheme: appInputDecorationTheme,
  );
}
