import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'luces_int_screen.dart';
import 'luces_ext_screen.dart';
import 'login_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Volvemos al manejo de estados por Widget y Título
  Widget _currentScreen = const LucesInterioresScreen();
  String _currentTitle = 'Luces Interiores';

  void _updateScreen(Widget screen, String title) {
    setState(() {
      _currentScreen = screen;
      _currentTitle = title;
    });
    Navigator.pop(context); // Cierra el drawer al seleccionar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle),
        backgroundColor: const Color(0xFFE0E5EC),
        elevation: 0,
        foregroundColor: Colors.black54,
      ),

      body: _currentScreen,

      // Espacio reservado para la futura barra informativa
      bottomNavigationBar: Container(
        height: 60,
        color: const Color(0xFFE0E5EC),
        child: const Center(
          child: Text(
            "Barra informativa (Próximamente)",
            style: TextStyle(color: Colors.black38, fontSize: 12),
          ),
        ),
      ),

      drawer: Drawer(
        child: Container(
          color: const Color(0xFFE0E5EC),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFFE0E5EC),
                  image: DecorationImage(
                    image: AssetImage('assets/images/living_a.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                accountName: const Text(
                  "mdbHome",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  FirebaseAuth.instance.currentUser?.email ?? "",
                  style: const TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.home, color: Colors.blueGrey, size: 40),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text("Luces Interiores"),
                onTap: () => _updateScreen(
                  const LucesInterioresScreen(),
                  "Luces Interiores",
                ),
              ),
              ListTile(
                leading: const Icon(Icons.wb_sunny),
                title: const Text("Luces Exteriores"),
                onTap: () => _updateScreen(
                  const LucesExterioresScreen(),
                  "Luces Exteriores",
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings_remote),
                title: const Text("Multimedia (NAD)"),
                onTap: () => _updateScreen(
                  const Center(child: Text("Pantalla Multimedia")),
                  "Multimedia",
                ),
              ),
              ListTile(
                leading: const Icon(Icons.thermostat),
                title: const Text("Clima y Sensores"),
                onTap: () => _updateScreen(
                  const Center(child: Text("Pantalla Clima")),
                  "Clima",
                ),
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text("Cerrar Sesión"),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
