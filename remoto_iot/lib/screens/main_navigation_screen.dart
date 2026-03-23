// lib/screen/main_navigation_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/mqtt_mgr.dart';
import '../providers/luces_provider.dart';
import 'luces_int_screen.dart';
import 'luces_ext_screen.dart';
import 'luz_piscina_screen.dart';
import 'multimedia_hub_screen.dart';
import 'clima_screen.dart';
import 'login_screen.dart';
//import '../models/control_remoto.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late MqttMgr _mqttMgr;

  Widget _currentScreen = const LucesInterioresScreen();
  String _currentTitle = 'Luces Interiores';

  void _updateScreen(Widget screen, String title) {
    setState(() {
      _currentScreen = screen;
      _currentTitle = title;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    // Mantenemos la inicialización crítica de MQTT
    final lucesProvider = Provider.of<LucesProvider>(context, listen: false);
    _mqttMgr = MqttMgr(lucesProvider);
    _mqttMgr.conectar();
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

              // 1. LUCES INTERIORES (Restaurado)
              ListTile(
                leading: Image.asset('assets/images/luces.png', width: 24),
                title: const Text("Luces Interiores"),
                onTap: () => _updateScreen(
                  const LucesInterioresScreen(),
                  "Luces Interiores",
                ),
              ),

              // 2. LUCES EXTERIORES (Con imagen asset)
              ListTile(
                leading: Image.asset('assets/images/focos.png', width: 24),
                title: const Text("Luces Exteriores"),
                onTap: () => _updateScreen(
                  const LucesExterioresScreen(),
                  "Luces Exteriores",
                ),
              ),

              // 3. LUZ PISCINA
              ListTile(
                leading: Image.asset('assets/images/piscina.png', width: 24),
                title: const Text("Luz Piscina"),
                onTap: () =>
                    _updateScreen(const LuzPiscinaScreen(), "Luz Piscina"),
              ),

              // 4. MULTIMEDIA (Única instancia corregida)
              ListTile(
                leading: Image.asset('assets/images/multimedia.png', width: 24),
                title: const Text("Multimedia"),
                onTap: () => _updateScreen(
                  const MultimediaHubScreen(),
                  "Gestión Multimedia",
                ),
              ),

              // 5. CLIMA
              ListTile(
                leading: Image.asset('assets/images/clima.png', width: 24),
                title: const Text("Clima y Sensores"),
                onTap: () =>
                    _updateScreen(const ClimaScreen(), "Clima y sensores"),
              ),

              const Divider(),

              // 5. CERRAR SESIÓN (Lógica sensible de Firebase mantenida)
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Cerrar Sesión",
                  style: TextStyle(color: Colors.redAccent),
                ),
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
