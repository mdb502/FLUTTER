// widgets/multimedia/rueda_multimedia.dart
import 'package:flutter/material.dart';
import '../common/neumorphic_container.dart';

class RuedaMultimedia extends StatelessWidget {
  final Function(String) onAction;

  const RuedaMultimedia({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Center(
      // 1. Usamos el NeumorphicContainer para el círculo grande
      child: NeumorphicContainer(
        width: 280,
        height: 280,
        borderRadius: 140, // Círculo perfecto
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Botones de Volumen
            _buildControl(Alignment.topCenter, Icons.add, "vol_up"),
            _buildControl(Alignment.bottomCenter, Icons.remove, "vol_down"),

            // Botones de Input
            _buildControl(
              Alignment.centerLeft,
              Icons.arrow_back_ios_new,
              "input_prev",
            ),
            _buildControl(
              Alignment.centerRight,
              Icons.arrow_forward_ios,
              "input_next",
            ),

            // 2. Usamos el NeumorphicContainer para el botón Mute (Efecto hundido)
            GestureDetector(
              onTap: () => onAction("mute"),
              child: NeumorphicContainer(
                width: 100,
                height: 100,
                borderRadius: 50,
                isPressed: true, // <--- Esto le da el toque de "botón central"
                child: Icon(
                  Icons.volume_off,
                  size: 40,
                  color: Colors.blueGrey[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControl(Alignment align, IconData icon, String cmd) {
    return Align(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: IconButton(
          icon: Icon(icon, color: Colors.grey[700], size: 35),
          onPressed: () => onAction(cmd),
        ),
      ),
    );
  }
}
