// lib/widgets/remote_layouts/buttons/round_button.dart

import 'package:flutter/material.dart'; // <--- ESTO SOLUCIONA LOS ERRORES
import '../../../theme/app_theme.dart';
import '../../common/neumorphic_container.dart';

Widget buildRoundButton({
  required String label,
  required bool isLearned,
  required VoidCallback onTap,
  IconData? icon, // Añadí esto por si quieres usar íconos en lugar de texto
}) {
  return GestureDetector(
    onTap: onTap,
    child: NeumorphicContainer(
      // Asegúrate de que tu NeumorphicContainer acepte el parámetro shape
      // Si no lo acepta, envuélvelo en un Container circular antes.
      borderRadius: 100, // Forzamos forma circular si es rectangular
      child: SizedBox(
        width: 60,
        height: 60,
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  color: isLearned ? AppColors.accent : AppColors.textGrey,
                  size: 20,
                )
              : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.buttonLabel.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isLearned ? AppColors.accent : AppColors.textGrey,
                  ),
                ),
        ),
      ),
    ),
  );
}
