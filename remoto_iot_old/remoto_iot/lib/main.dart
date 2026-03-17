import 'package:flutter/material.dart';

void main() {
  runApp(const MiControlRemoto());
}

class MiControlRemoto extends StatelessWidget {
  const MiControlRemoto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Control Remoto Universal'),
          backgroundColor: Colors.indigo,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.settings_remote, size: 100, color: Colors.indigo),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print("Botón presionado: Enviando comando a MQTT...");
                },
                child: const Text('Encender NAD C350'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}