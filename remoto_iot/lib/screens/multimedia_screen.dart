// lib/screens/multimedia_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <--- NUEVO
import '../providers/luces_provider.dart'; // <--- NUEVO
import '../models/control_remoto.dart';
import '../services/mqtt_mgr.dart';
import '../widgets/multimedia/rueda_multimedia.dart';
import '../widgets/multimedia/boton_power_nad.dart';

class MultimediaScreen extends StatelessWidget {
  final ControlRemoto equipo;

  const MultimediaScreen({super.key, required this.equipo});

  void _enviarComando(BuildContext context, String accion) {
    final mqttService = Provider.of<MqttMgr>(context, listen: false);

    final payload = {"dispositivo": equipo.idRaw, "boton": accion};
    mqttService.publicarComando("multimedia/control", jsonEncode(payload));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              equipo.nombreVisible,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
                color: Colors.blueGrey,
              ),
            ),
            const Spacer(),

            // Y en el Consumer del botón Power:
            Consumer<LucesProvider>(
              builder: (context, provider, child) {
                final bool estaConfirmado = provider.estaEncendidoMultimedia(
                  equipo.idRaw,
                );

                return BotonPowerNad(
                  estaActivo: estaConfirmado,
                  onAction: (_) =>
                      _enviarComando(context, "power"), // <--- Aquí también
                );
              },
            ),

            // ---------------------------------
            const Spacer(),
            RuedaMultimedia(
              onAction: (accion) => _enviarComando(context, accion),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
