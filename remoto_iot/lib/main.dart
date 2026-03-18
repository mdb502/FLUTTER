import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MdbHomeApp());
}

class MdbHomeApp extends StatelessWidget {
  const MdbHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mdbHome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(
          0xFFE0E5EC,
        ), // Color Neomórfico base
      ),
      home: const SplashScreen(),
    );
  }
}
