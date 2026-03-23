// lib/providers/luces_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/dispositivo_model.dart';
import '../services/firebase_service.dart';

class LucesProvider with ChangeNotifier {
  List<DispositivoESP> _dispositivos = [];
  bool _cargando = false;

  // NUEVO: Estado para el feedback del Control Remoto
  // Usamos un Map por si en el futuro tienes más de un equipo (TV, Audio, etc.)
  final Map<String, bool> _estadosMultimedia = {};

  List<DispositivoESP> get dispositivos => _dispositivos;
  bool get cargando => _cargando;

  // Getters para las pantallas
  List<DispositivoESP> get lucesInteriores {
    var lista = _dispositivos.where((d) => d.zona == 'Interior').toList();
    lista.sort((a, b) => a.idx.compareTo(b.idx));
    return lista;
  }

  List<DispositivoESP> get lucesExteriores {
    var lista = _dispositivos.where((d) => d.zona == 'Exterior').toList();
    lista.sort((a, b) => a.idx.compareTo(b.idx));
    return lista;
  }

  // Getter para saber si un dispositivo específico está "confirmado" como ON
  bool estaEncendidoMultimedia(String idDispositivo) =>
      _estadosMultimedia[idDispositivo] ?? false;

  Future<void> inicializarConfiguracion() async {
    _cargando = true;
    notifyListeners();
    try {
      _dispositivos = await FirebaseService().obtenerConfiguracionLuces();
    } catch (e) {
      print("Error en Provider: $e");
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void actualizarEstadoDesdeMQTT(String topico, String valor) {
    // --- LÓGICA PARA MULTIMEDIA (CORREGIDA) ---
    // --- LÓGICA PARA MULTIMEDIA (CORREGIDA SIN TIMER) ---
    if (topico == "multimedia/estado") {
      try {
        final Map<String, dynamic> data = jsonDecode(valor);
        String id = data['dispositivo'] ?? "";
        String estado = data['estado'] ?? ""; // "on" o "off"

        if (id.isNotEmpty) {
          // Actualizamos el mapa de estados de forma permanente
          if (estado == "on") {
            _estadosMultimedia[id] = true;
          } else if (estado == "off") {
            _estadosMultimedia[id] = false;
          }

          print('📡 Estado IR actualizado para $id: $estado');
          notifyListeners(); // La pantalla se actualiza y se QUEDA así.
        }
      } catch (e) {
        print('❌ Error parseando JSON multimedia: $e');
      }
      return;
    }

    // --- LÓGICA PARA LUCES (EXISTENTE) ---
    final todas = [...lucesInteriores, ...lucesExteriores];
    try {
      final dispositivo = todas.firstWhere((l) => l.topicStatus == topico);
      bool nuevoEstado = (valor == "1");

      if (dispositivo.encendido != nuevoEstado) {
        dispositivo.encendido = nuevoEstado;
        notifyListeners();
        print(
          '✅ Estado sincronizado para ${dispositivo.etiqueta}: $nuevoEstado',
        );
      }
    } catch (e) {
      print('ℹ️ Tópico no reconocido: $topico');
    }
  }
}
