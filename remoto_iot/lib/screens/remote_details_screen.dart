// lib/screens/remote_details_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart'; // Importante
import '../services/mqtt_mgr.dart'; // Tu archivo de manager
import '../theme/app_theme.dart';
import '../widgets/remote_layouts/amplifier_layout.dart';
import '../widgets/remote_layouts/receiver_layout.dart';

class RemoteDetailsScreen extends StatefulWidget {
  final String equipoId;
  final String espId;

  const RemoteDetailsScreen({
    super.key,
    required this.equipoId,
    required this.espId,
  });

  @override
  State<RemoteDetailsScreen> createState() => _RemoteDetailsScreenState();
}

class _RemoteDetailsScreenState extends State<RemoteDetailsScreen> {
  bool _isLearningMode = false;

  // --- LÓGICA DE ENVÍO DE COMANDOS ---
  void _processAction(String commandId, bool isMacro) {
    if (_isLearningMode) {
      _sendLearningRequest(commandId);
    } else {
      if (isMacro) {
        _executeMacro(commandId);
      } else {
        // Ahora siempre enviamos el ID del botón (ej: "power")
        _sendSingleCommand(commandId);
      }
    }
  }

  void _sendSingleCommand(String botonId) {
    final topic = "casa/cremoto/${widget.espId}/comando";

    // Construcción del JSON
    final Map<String, String> payloadMap = {
      "dispositivo": widget.equipoId,
      "boton": botonId, // Ya viene limpio desde el layout corregido
    };
    final String jsonPayload = jsonEncode(payloadMap);

    debugPrint("MQTT PUBLISH: $topic");
    debugPrint("PAYLOAD: $jsonPayload");

    // --- CONEXIÓN REAL CON MQTT_MGR ---
    // Usamos la instancia Singleton de tu MqttMgr
    MqttMgr(context.read()).publicarComando(topic, jsonPayload);
  }

  void _sendLearningRequest(String botonId) {
    final topic = "casa/cremoto/${widget.espId}/learn";

    // Para aprender, enviamos solo el ID del botón como string simple
    // o el mismo JSON si tu ESP32 lo prefiere así.
    MqttMgr(context.read()).publicarComando(topic, botonId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Modo Aprendizaje: Presiona botón para $botonId"),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  void _executeMacro(String macroId) async {
    if (macroId.startsWith("MACRO_RADIO_")) {
      String secuencia = macroId.replaceFirst("MACRO_RADIO_", ""); // Ej: "941"

      for (int i = 0; i < secuencia.length; i++) {
        _sendSingleCommand(secuencia[i]);
        // 500ms es un buen estándar, pero si el receptor "se come" números, sube a 700ms
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.equipoId.replaceAll('_', ' ')),
        actions: [
          Switch(
            value: _isLearningMode,
            // REEMPLAZO: activeColor ya no se usa
            activeThumbColor: AppColors.accent,
            activeTrackColor: AppColors.accent.withValues(
              alpha: 0.5,
            ), // Color de la pista al estar activo
            inactiveThumbColor:
                Colors.grey, // Color del círculo al estar apagado
            onChanged: (val) => setState(() => _isLearningMode = val),
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance
            .ref()
            .child('CRemotos/${widget.equipoId}')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data?.snapshot.value == null) {
            return const Center(child: Text("Sin datos disponibles"));
          }

          // Extraemos la data y quitamos el warning de "variable no usada"
          final Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
            snapshot.data!.snapshot.value as Map,
          );

          // Buscamos los inputs (solo para el amplificador NAD)
          final List<String> inputsEncontrados = data.keys
              .where((k) => k.toString().startsWith('INP_'))
              .map((k) => k.toString())
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: widget.equipoId.toLowerCase().contains('receiver')
                ? ReceiverLayout(
                    onAction: (cmd, isMacro) => _processAction(cmd, isMacro),
                  )
                : AmplifierLayout(
                    isLearningMode: _isLearningMode,
                    espId: widget.espId,
                    equipoId: widget.equipoId,
                    inputs: inputsEncontrados, // Ahora sí está definida
                    onAction: (cmd, isMacro) => _processAction(cmd, isMacro),
                  ),
          );
        },
      ),
    );
  }
}
