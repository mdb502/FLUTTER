import 'package:flutter/material.dart';
import 'dart:async';
import 'main_navigation_screen.dart'; // Tu esqueleto principal

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
      duration: const Duration(milliseconds: 1500), // Duración de la animación
    );

    // Animación del Logo: Inicia grande (2.0) y llega a tamaño normal (1.0)
    _logoScale = Tween<double>(
      begin: 2.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // Animación del Texto: Inicia en cero y llega a su tamaño (1.0)
    _textScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Iniciar animación
    _controller.forward();

    // Navegar a la pantalla principal tras 3 segundos
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    });
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
