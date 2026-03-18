import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(15),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: const [
            BoxShadow(
              color: AppColors.lightShadow,
              offset: Offset(-7, -7),
              blurRadius: 15,
            ),
            BoxShadow(
              color: AppColors.darkShadow,
              offset: Offset(7, 7),
              blurRadius: 15,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
