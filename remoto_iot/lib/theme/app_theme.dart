// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppColors {
  // Fondo Neomórfico Base
  static const Color background = Color(0xFFE0E5EC);

  // Sombras Neomórficas (Fundamentales para tus Widgets)
  static const Color lightShadow = Color(0xFFFFFFFF);
  static const Color darkShadow = Color(0xFFA3B1C6);

  // Colores de Estado
  static const Color accent = Colors.blueAccent;
  static const Color warning = Colors.orangeAccent;
  static const Color success = Colors.green; // Para las marcas de aprendizaje
  static const Color activeLight = Color(0xFFFFD700);
  static const Color textGrey = Colors.blueGrey;
}

class AppTextStyles {
  static const String font = 'Abel';

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: font,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textGrey,
  );

  // Estilo para los botones de la grilla (Más pequeños y elegantes)
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: font,
    fontSize: 12, // Reducido para mejor estética
    fontWeight: FontWeight.w600,
    color: Colors.black54,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.font,
      scaffoldBackgroundColor: AppColors.background,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.appBarTitle,
        iconTheme: IconThemeData(color: AppColors.textGrey),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textGrey),
        bodyMedium: TextStyle(color: AppColors.textGrey),
        titleMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textGrey,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        labelStyle: const TextStyle(color: AppColors.textGrey),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textGrey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textGrey.withOpacity(0.2)),
        ),
      ),
    );
  }
}
