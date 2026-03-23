// lib/widgets/remote_layouts/neumorphic_learn_button.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart'; // Importamos para usar AppColors y AppTextStyles

class NeumorphicLearnButton extends StatelessWidget {
  final String label;
  final String commandId;
  final bool isLearned;
  final VoidCallback onTap;

  const NeumorphicLearnButton({
    super.key,
    required this.label,
    required this.commandId,
    required this.isLearned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.lightShadow,
              offset: Offset(-4, -4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: AppColors.darkShadow,
              offset: Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Marca de "Aprendido" (Check verde)
            if (isLearned)
              const Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 16,
                ),
              ),

            // Texto del Botón con la fuente Abel
            Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.buttonLabel.copyWith(
                    // Forzamos la fuente Abel aquí por si el TextStyle base no la tiene
                    fontFamily: AppTextStyles.font,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
