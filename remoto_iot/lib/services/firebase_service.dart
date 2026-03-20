import 'package:firebase_database/firebase_database.dart';
import '../models/dispositivo_model.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<List<DispositivoESP>> obtenerConfiguracionLuces() async {
    List<DispositivoESP> listaTemporal = [];

    try {
      final snapshot = await _dbRef.child('CLuces').get();

      if (snapshot.exists) {
        // Firebase nos devuelve un Map<dynamic, dynamic>
        final Map<dynamic, dynamic> data = snapshot.value as Map;

        // Recorremos cada entrada del mapa
        data.forEach((key, value) {
          // key es "L01", value son sus datos {idx: 1, ubi: "Living", ...}
          final dispositivo = DispositivoESP.fromJson(
            key.toString(), // El primer argumento: ID
            Map<dynamic, dynamic>.from(value), // El segundo argumento: Datos
          );
          listaTemporal.add(dispositivo);
        });
      }
    } catch (e) {
      print("Error en FirebaseService: $e");
    }

    return listaTemporal;
  }
}
