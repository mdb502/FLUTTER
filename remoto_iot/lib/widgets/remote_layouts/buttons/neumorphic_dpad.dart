// lib/widgets/remote_layouts/buttons/neumorphic_dpad.dart

import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class NeumorphicDPad extends StatelessWidget {
  final Function(String) onAction;
  final String labelCenter; // "OK", "MUTE", "ENTER"

  const NeumorphicDPad({
    super.key,
    required this.onAction,
    this.labelCenter = "OK",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightShadow,
            offset: Offset(-5, -5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: AppColors.darkShadow,
            offset: Offset(5, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Botón ARRIBA (Vol + / Up)
          _buildDirectionalBtn(
            Alignment.topCenter,
            Icons.keyboard_arrow_up,
            "UP",
          ),
          // Botón ABAJO (Vol - / Down)
          _buildDirectionalBtn(
            Alignment.bottomCenter,
            Icons.keyboard_arrow_down,
            "DOWN",
          ),
          // Botón IZQUIERDA (Anterior / Left)
          _buildDirectionalBtn(
            Alignment.centerLeft,
            Icons.keyboard_arrow_left,
            "LEFT",
          ),
          // Botón DERECHA (Siguiente / Right)
          _buildDirectionalBtn(
            Alignment.centerRight,
            Icons.keyboard_arrow_right,
            "RIGHT",
          ),

          // BOTÓN CENTRAL (Mute / OK)
          Center(
            child: GestureDetector(
              onTap: () => onAction("CENTER"),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                  border: Border.all(
                    color: AppColors.textGrey.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    const BoxShadow(
                      color: AppColors.lightShadow,
                      offset: Offset(-2, -2),
                      blurRadius: 5,
                    ),
                    const BoxShadow(
                      color: AppColors.darkShadow,
                      offset: Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    labelCenter,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.font,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionalBtn(Alignment align, IconData icon, String id) {
    return Align(
      alignment: align,
      child: IconButton(
        iconSize: 40,
        icon: Icon(icon, color: AppColors.textGrey),
        onPressed: () => onAction(id),
      ),
    );
  }
}
