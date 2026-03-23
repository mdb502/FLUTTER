// lib/common/neumorphic_container.dart
import 'package:flutter/material.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isPressed; // Para el efecto "hundido" del botón Mute

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 20,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC), // Color base neumórfico
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPressed
            ? [
                // Sombras internas para efecto "Hundido"
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(4, 4),
                  blurRadius: 15,
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  offset: const Offset(-4, -4),
                  blurRadius: 15,
                  spreadRadius: -5,
                ),
              ]
            : [
                // Sombras externas para efecto "Elevado"
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(10, 10),
                  blurRadius: 20,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  offset: const Offset(-10, -10),
                  blurRadius: 20,
                ),
              ],
      ),
      child: Center(child: child),
    );
  }
}
