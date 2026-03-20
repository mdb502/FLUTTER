import 'package:flutter/material.dart';
import 'dart:async';
import 'main_navigation_screen.dart';
import 'package:provider/provider.dart';
import '../providers/luces_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/mqtt_mgr.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _textScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScale = Tween<double>(
      begin: 2.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _textScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // --- SOLUCIÓN AL ERROR ---
    // Ejecuta la carga una vez que el Splash esté dibujado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatosYNavigar();
    });
  }

  Future<void> _cargarDatosYNavigar() async {
    // 1. Verificamos si ya hay una sesión activa de Firebase
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // CASO: YA ESTÁS LOGUEADO
      final lucesProv = Provider.of<LucesProvider>(context, listen: false);

      try {
        // Intentamos cargar los datos (ahora tenemos permiso)
        await lucesProv.inicializarConfiguracion();
        final mqtt = Provider.of<MqttMgr>(context, listen: false);
        await mqtt.conectar();
      } catch (e) {
        debugPrint("Error al cargar datos protegidos: $e");
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    } else {
      // CASO: PRIMERA VEZ O SIN SESIÓN
      // Esperamos un poco para que veas tu logo animado
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ), // La pantalla neomórfica
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo limpio como tu imagen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animamos el Logo
            ScaleTransition(
              scale: _logoScale,
              child: Image.asset(
                'assets/images/logo.png', // Asegúrate de añadirlo a tu pubspec.yaml
                width: 180,
              ),
            ),
            const SizedBox(height: 20),
            // Animamos el Texto
            ScaleTransition(
              scale: _textScale,
              child: const Text(
                'mdbHome',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
