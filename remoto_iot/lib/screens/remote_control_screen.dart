// lib/screens/remote_control_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../config/app_config.dart';
import '../theme/app_theme.dart';
import '../widgets/common/neumorphic_container.dart';
import 'remote_details_screen.dart'; // Asegúrate de haber creado este archivo

class RemoteControlScreen extends StatefulWidget {
  const RemoteControlScreen({super.key});

  @override
  State<RemoteControlScreen> createState() => _RemoteControlScreenState();
}

class _RemoteControlScreenState extends State<RemoteControlScreen> {
  // ELIMINADA: _seleccionActual ya no es necesaria porque navegamos a otra pantalla

  String _formatRoomName(String rawName) {
    return rawName.replaceFirst("CREM_", "");
  }

  // MÉTODO DEFINIDO: Maneja la navegación al seleccionar un equipo
  void _handleNavigation(
    BuildContext context,
    String roomKey,
    String? equipoId,
  ) {
    if (equipoId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RemoteDetailsScreen(equipoId: equipoId, espId: roomKey),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Control Remoto")),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        itemCount: AppConfig.capturadoresIR.length,
        itemBuilder: (context, index) {
          final capturadorId = AppConfig.capturadoresIR[index];
          final roomName = _formatRoomName(capturadorId);

          return Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: NeumorphicContainer(
              borderRadius: 15,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomName,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.font,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 15),
                    StreamBuilder(
                      stream: FirebaseDatabase.instance
                          .ref("Ubicaciones/$capturadorId")
                          .onValue,
                      builder: (context, snapshot) {
                        // CORRECCIÓN: Bloque con llaves {} para el if
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }

                        if (snapshot.hasData &&
                            snapshot.data!.snapshot.value != null) {
                          final data = snapshot.data!.snapshot.value;
                          List<String> equipos = [];
                          try {
                            if (data is List) {
                              equipos = data
                                  .where((e) => e != null)
                                  .cast<String>()
                                  .toList();
                            } else if (data is Map) {
                              equipos = data.values.cast<String>().toList();
                            }
                          } catch (e) {
                            debugPrint("Error parseando: $e");
                          }
                          return _buildDropdown(capturadorId, equipos);
                        }
                        return const Text("Cargando equipos...");
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown(String roomKey, List<String> opciones) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: null, // Mantenemos null para que siempre muestre el "Hint"
          hint: const Text(
            "Seleccionar Equipo",
            style: TextStyle(fontSize: 14),
          ),
          isExpanded: true,
          items: opciones.map((String equipo) {
            return DropdownMenuItem<String>(
              value: equipo,
              child: Text(equipo.replaceAll('_', ' ')),
            );
          }).toList(),
          onChanged: (newValue) =>
              _handleNavigation(context, roomKey, newValue),
        ),
      ),
    );
  }
}
