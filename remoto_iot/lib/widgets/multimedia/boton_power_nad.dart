// lib/widgets/multimedia/boton_power_nad.dart
import 'package:flutter/material.dart';
import '../common/neumorphic_container.dart';

class BotonPowerNad extends StatelessWidget {
  final Function(String) onAction;
  final bool estaActivo; // <--- El color depende de esto

  const BotonPowerNad({
    super.key,
    required this.onAction,
    this.estaActivo = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onAction("power"),
      child: NeumorphicContainer(
        width: 100,
        height: 100,
        borderRadius: 50,
        // El efecto visual también depende del estado del Provider
        isPressed: estaActivo,
        child: Icon(
          Icons.power_settings_new,
          size: 45,
          // Rojo si está en espera, Verde si el ESP32 confirmó
          color: estaActivo ? Colors.greenAccent : Colors.redAccent,
        ),
      ),
    );
  }
}
