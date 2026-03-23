// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'providers/luces_provider.dart';
import 'screens/splash_screen.dart';
import 'services/mqtt_mgr.dart';

void main() async {
  // 1. Asegura que los bindings de Flutter estén listos antes de usar servicios nativos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Carga de configuraciones y servicios externos
  try {
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp();
    print("✅ Servicios inicializados (Firebase & Dotenv)");
  } catch (e) {
    print("❌ Error cargando servicios: $e");
  }

  // 3. Inicialización manual de los servicios con dependencias cruzadas
  final lucesProv = LucesProvider();
  final mqttServicio = MqttMgr(lucesProv);

  // 4. Iniciar la App con MultiProvider
  runApp(
    MultiProvider(
      providers: [
        // Pasamos la instancia ya creada de LucesProvider
        ChangeNotifierProvider<LucesProvider>.value(value: lucesProv),
        // Pasamos el MqttMgr ya vinculado a ese provider
        ChangeNotifierProvider<MqttMgr>.value(value: mqttServicio),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita el banner de debug
      title: 'mdbHome IoT',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(
          0xFFE0E5EC,
        ), // Color base neumórfico
      ),
      home: const SplashScreen(),
    );
  }
}
