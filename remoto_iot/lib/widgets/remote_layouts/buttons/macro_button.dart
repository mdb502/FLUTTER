// lib/widgets/remote_layouts/buttons/macro_button.dart

import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class MacroButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isDisabled;

  const MacroButton({
    super.key,
    required this.label,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isDisabled ? 0.3 : 1.0, // Se "apaga" visualmente
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDisabled
                ? []
                : [
                    const BoxShadow(
                      color: AppColors.lightShadow,
                      offset: Offset(-3, -3),
                      blurRadius: 5,
                    ),
                    const BoxShadow(
                      color: AppColors.darkShadow,
                      offset: Offset(3, 3),
                      blurRadius: 5,
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppTextStyles.font,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDisabled ? Colors.grey : AppColors.accent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
