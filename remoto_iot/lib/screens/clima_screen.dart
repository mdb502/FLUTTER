// lib/screens/clima_screen.dart (repetir para clima y multimedia)
import 'package:flutter/material.dart';

class ClimaScreen extends StatelessWidget {
  const ClimaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Pantalla: Clima',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
