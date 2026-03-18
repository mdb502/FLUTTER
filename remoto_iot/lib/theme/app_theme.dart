import 'package:flutter/material.dart';

class AppColors {
  // Fondo Neomórfico Base
  static const Color background = Color(0xFFE0E5EC);

  // Sombras Neomórficas
  static const Color lightShadow = Color(0xFFFFFFFF);
  static const Color darkShadow = Color(0xFFA3B1C6);

  // Colores de Estado
  static const Color accent = Colors.blueAccent;
  static const Color warning = Colors.orangeAccent;
  static const Color activeLight = Color(
    0xFFFFD700,
  ); // Dorado para ampolletas encendidas
}

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: Colors.black87,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );
}
