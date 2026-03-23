// models/control_remoto.dart
class ControlRemoto {
  final String idRaw; // Ej: "Amplifier_NAD_C350"
  late String tipo;
  late String marca;
  late String modelo;

  ControlRemoto(this.idRaw) {
    List<String> partes = idRaw.split('_');
    tipo = partes.length > 0 ? partes[0] : "Generic";
    marca = partes.length > 1 ? partes[1] : "Unknown";
    modelo = partes.length > 2 ? partes[2] : "";
  }

  String get nombreVisible => "$marca $modelo".trim();
}
