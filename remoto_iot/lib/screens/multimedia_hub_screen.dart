// screens/multimedia_hub_screen.dart
import 'package:flutter/material.dart';
import '../widgets/common/custom_menu_card.dart'; // Widget reutilizable
import 'remote_control_screen.dart';
import 'multimedia_learn_screen.dart'; // Para navegar a la pantalla de aprendizaje

class MultimediaHubScreen extends StatelessWidget {
  const MultimediaHubScreen({super.key});

  // Método para mostrar las opciones de Escenarios
  void _showEscenarios(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFE0E5EC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Seleccionar Escenario",
            style: TextStyle(
              fontFamily: 'Abel', // Añade la fuente aquí
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blueGrey,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.radio),
            title: const Text("Radio Escritorio"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.speaker),
            title: const Text("Radio Living"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text("Ver Película"),
            onTap: () {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 1, // Una columna para tarjetas grandes
          childAspectRatio: 3,
          mainAxisSpacing: 20,
          children: [
            CustomMenuCard(
              titulo: "Escenarios",
              subtitulo: "Configuraciones predefinidas",
              icon: Icons.auto_awesome,
              onTap: () => _showEscenarios(context),
            ),
            CustomMenuCard(
              titulo: "Control Remoto",
              subtitulo: "Dispositivos registrados",
              icon: Icons.settings_remote,
              onTap: () {
                // CAMBIO: Navegamos directo a la nueva pantalla v2
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RemoteControlScreen(),
                  ),
                );
              },
            ),
            CustomMenuCard(
              titulo: "Aprender Comandos",
              subtitulo: "Registrar nuevos códigos IR",
              icon: Icons.settings_input_antenna,
              onTap: () {
                print("Abriendo modo aprendizaje...");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MultimediaLearnScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
