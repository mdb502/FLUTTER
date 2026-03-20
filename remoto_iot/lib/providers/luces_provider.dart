import 'package:flutter/material.dart';
import '../models/dispositivo_model.dart';
import '../services/firebase_service.dart';

class LucesProvider with ChangeNotifier {
  List<DispositivoESP> _dispositivos = [];
  bool _cargando = false;

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

  Future<void> inicializarConfiguracion() async {
    _cargando = true;
    notifyListeners();

    try {
      // Llamamos al servicio que ya corregimos con (key, value)
      _dispositivos = await FirebaseService().obtenerConfiguracionLuces();
    } catch (e) {
      print("Error en Provider: $e");
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // Para actualizar desde MQTT
  void actualizarEstadoDesdeMQTT(String topico, String valor) {
    // Combinamos todas las listas para buscar el dispositivo
    final todas = [...lucesInteriores, ...lucesExteriores];

    try {
      // Buscamos cuál luz corresponde a ese tópico
      final dispositivo = todas.firstWhere((l) => l.topicStatus == topico);

      bool nuevoEstado = (valor == "1");

      // Solo actualizamos y notificamos si el estado es diferente al actual
      if (dispositivo.encendido != nuevoEstado) {
        dispositivo.encendido = nuevoEstado;
        notifyListeners(); // <--- Esto hace la magia en la pantalla
        print(
          '✅ Estado sincronizado para ${dispositivo.etiqueta}: $nuevoEstado',
        );
      }
    } catch (e) {
      print('ℹ️ Tópico no reconocido: $topico');
    }
  }
}
