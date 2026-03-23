import 'package:flutter/material.dart';
import '../../models/dispositivo_model.dart';

class TarjetaLuzNeomorfica extends StatelessWidget {
  final DispositivoESP luz;
  final VoidCallback onPowerToggle;

  const TarjetaLuzNeomorfica({
    super.key,
    required this.luz,
    required this.onPowerToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: _boxDecorationNeumorfica(hundido: false),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  luz.ubicacion,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  luz.etiqueta,
                  style: const TextStyle(
                    color: Color(0xFF00ADEE),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Botón Power (Cambia de icono y relieve)
          _botonCircular(
            presionado: luz.encendido,
            iconPath: luz.encendido
                ? 'assets/iconos/sw_on.png'
                : 'assets/iconos/sw_off.png',
            onTap: onPowerToggle,
          ),
          const SizedBox(width: 15),
          Text(
            luz.modo,
            style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(width: 8),
          _botonCircular(
            presionado: false,
            iconPath: 'assets/iconos/config.png',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // --- Estilo Neumórfico ---
  BoxDecoration _boxDecorationNeumorfica({required bool hundido}) {
    return BoxDecoration(
      color: const Color(0xFFE0E5EC),
      borderRadius: BorderRadius.circular(50),
      boxShadow: hundido
          ? [
              const BoxShadow(
                color: Colors.white,
                offset: Offset(3, 3),
                blurRadius: 3,
              ),
            ] // Simplificado
          : [
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-5, -5),
                blurRadius: 10,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(5, 5),
                blurRadius: 10,
              ),
            ],
    );
  }

  Widget _botonCircular({
    required bool presionado,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: _boxDecorationNeumorfica(hundido: presionado),
        child: Image.asset(iconPath, width: 25, height: 25),
      ),
    );
  }
}
