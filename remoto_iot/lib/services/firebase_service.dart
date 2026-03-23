// lib/services/firebase_service.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/dispositivo_model.dart';
import '../models/control_remoto.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // --- FUNCIÓN PARA LUCES (CORREGIDA) ---
  Future<List<DispositivoESP>> obtenerConfiguracionLuces() async {
    try {
      final snapshot = await _db.child('CLuces').get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> data =
            snapshot.value as Map<dynamic, dynamic>;

        // 1. Usamos DispositivoESP (con ESP al final)
        // 2. Usamos .fromJson que es el constructor que tienes en tu modelo
        return data.entries
            .map(
              (e) => DispositivoESP.fromJson(
                e.key.toString(),
                e.value as Map<dynamic, dynamic>,
              ),
            )
            .toList();
      }
      return [];
    } catch (e) {
      print("❌ Error al obtener configuración de luces: $e");
      return [];
    }
  }

  // --- FUNCIÓN PARA MULTIMEDIA ---
  Future<List<ControlRemoto>> obtenerControlesRemotos() async {
    try {
      final snapshot = await _db.child('CRemotos').get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> data =
            snapshot.value as Map<dynamic, dynamic>;
        // Convertimos las llaves (IDs como Amplifier_NAD_C350) en objetos
        return data.keys.map((id) => ControlRemoto(id.toString())).toList();
      }
      return [];
    } catch (e) {
      print("❌ Error al obtener CRemotos: $e");
      return [];
    }
  }
}
