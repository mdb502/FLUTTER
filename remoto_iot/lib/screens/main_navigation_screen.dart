// lib/screens/main_navigation_screen.dart

import 'package:flutter/material.dart';
import 'luces_int_screen.dart';
import 'luces_ext_screen.dart';
import 'luz_piscina_screen.dart';
import 'multimedia_screen.dart';
import 'clima_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Estado inicial: Luces Interiores
  Widget _currentScreen = const LucesIntScreen();
  String _currentTitle = 'Luces Interiores';

  void _updateScreen(Widget screen, String title) {
    setState(() {
      _currentScreen = screen;
      _currentTitle = title;
    });
    Navigator.pop(context); // Cierra el menú lateral automáticamente
  }

  @override
  Widget build(BuildContext context) {
    // Definimos el color neomórfico base para reutilizarlo
    const Color neumorphicBackground = Color(0xFFE0E5EC);

    return Scaffold(
      backgroundColor: neumorphicBackground,
      appBar: AppBar(
        title: Text(
          _currentTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            Colors.transparent, // Barra transparente para que se vea el fondo
        elevation: 0, // Sin sombra
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ), // Icono del menú en oscuro
      ),
      // --- AQUÍ ESTÁ EL MENÚ LATERAL MODIFICADO ---
      drawer: Drawer(
        backgroundColor: neumorphicBackground, // Fondo del drawer neomórfico
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Encabezado con imagen de fondo
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // 1. Asegúrate de tener 'living_a.jpg' en assets/images/
                  image: AssetImage('assets/images/living_a.jpg'),
                  fit: BoxFit.cover, // La imagen cubre todo el espacio
                ),
              ),
              // Titulo principal: mdbHome (con sombra para legibilidad)
              accountName: const Text(
                'mdbHome',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              // Subtítulo (opcional)
              accountEmail: const Text(
                'Sistema de Control Inteligente',
                style: TextStyle(
                  color: Colors.white70,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
                ),
              ),
              // Aquí podrías poner un logo circular si quisieras
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.home_work_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            // Opciones del Menú (puedes usar iconos neomórficos aquí más adelante)
            _menuItem(
              'assets/images/luces.png',
              'Luces Interiores',
              const LucesIntScreen(),
            ),
            _menuItem(
              'assets/images/focos.png',
              'Luces Exteriores',
              const LucesExtScreen(),
            ),
            _menuItem(
              'assets/images/piscina.png',
              'Luz Piscina',
              const LuzPiscinaScreen(),
            ),
            _menuItem(
              'assets/images/multimedia.png',
              'Multimedia',
              const MultimediaScreen(),
            ),
            _menuItem('assets/images/clima.png', 'Clima', const ClimaScreen()),
          ],
        ),
      ),
      // El cuerpo dinámico que cambia según el menú
      body: Container(padding: const EdgeInsets.all(16), child: _currentScreen),
    );
  }

  // Widget auxiliar para crear los items del menú con consistencia
  ListTile _menuItem(String assetPath, String label, Widget screen) {
    return ListTile(
      leading: Image.asset(
        assetPath,
        width:
            24, // Ajustamos el tamaño para que coincida con un icono estándar
        height: 24,
        color: Colors
            .black54, // Opcional: para darle un tono uniforme si el PNG es negro/gris
      ),
      title: Text(label, style: const TextStyle(color: Colors.black87)),
      onTap: () => _updateScreen(screen, label),
    );
  }
}
