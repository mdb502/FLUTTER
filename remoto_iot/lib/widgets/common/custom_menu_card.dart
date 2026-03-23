import 'package:flutter/material.dart';
import 'neumorphic_container.dart';

class CustomMenuCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icon;
  final VoidCallback onTap;

  const CustomMenuCard({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NeumorphicContainer(
        borderRadius: 15,
        // Eliminamos el padding de aquí si NeumorphicContainer no lo soporta
        child: Padding(
          padding: const EdgeInsets.all(15.0), // <--- Lo movemos aquí
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blueGrey),
              const SizedBox(width: 20),
              Expanded(
                // Añadimos Expanded para evitar desbordamientos de texto
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitulo,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
