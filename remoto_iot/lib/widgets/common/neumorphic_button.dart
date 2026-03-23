// lib/widgets/common/neumorphic_button.dart
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'; // Opcional, para sombras internas

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;

  const NeumorphicButton({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius = 15,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false; // Estado para simular el "hundido"

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isPressed
              ? [
                  // Sombras cuando está PRESIONADO (efecto hundido)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 15,
                    spreadRadius: 1,
                    inset:
                        true, // Requiere la librería 'flutter_inset_box_shadow'
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    offset: const Offset(-4, -4),
                    blurRadius: 15,
                    spreadRadius: 1,
                    inset: true,
                  ),
                ]
              : [
                  // Sombras cuando está NORMAL (efecto extruido)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(8, 8),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    offset: const Offset(-8, -8),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: widget.child,
      ),
    );
  }
}
