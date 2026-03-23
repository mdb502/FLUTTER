// lib/screens/remote_details_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart'; // Importante
import '../services/mqtt_mgr.dart'; // Tu archivo de manager
import '../theme/app_theme.dart';
import '../widgets/remote_layouts/amplifier_layout.dart';

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
    debugPrint("Ejecutando Macro: $macroId");
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
            activeColor: AppColors.accent,
            onChanged: (val) => setState(() => _isLearningMode = val),
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance
            .ref("CRemotos/${widget.equipoId}")
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const Center(child: Text("Error de conexión"));
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final Map<dynamic, dynamic> data =
              snapshot.data!.snapshot.value as Map;

          List<String> inputsEncontrados = data.keys
              .map((e) => e.toString())
              .where((key) => key.startsWith("input_"))
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: AmplifierLayout(
              isLearningMode: _isLearningMode,
              espId: widget.espId,
              equipoId: widget.equipoId,
              inputs: inputsEncontrados,
              onAction: (cmd, isMacro) => _processAction(cmd, isMacro),
            ),
          );
        },
      ),
    );
  }
}
