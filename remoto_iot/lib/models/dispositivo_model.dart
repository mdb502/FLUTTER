import '../config/app_config.dart';

class DispositivoESP {
  final int idx;
  final String id;
  final String ubicacion;
  final String etiqueta;
  final String zona;
  final String tBase;
  final String microId;

  // Datos de Operación (Vienen por MQTT, no Firebase)
  bool encendido;
  String modo;

  DispositivoESP({
    required this.idx,
    required this.id,
    required this.ubicacion,
    required this.etiqueta,
    required this.zona,
    required this.tBase,
    required this.microId,
    this.encendido = false,
    this.modo = "Normal",
  });

  // Constructor que "recoge" datos directos de Firebase
  factory DispositivoESP.fromJson(String id, Map<dynamic, dynamic> json) {
    return DispositivoESP(
      id: id,
      idx: json['idx'] ?? 99,
      ubicacion: json['ubi'] ?? '',
      etiqueta: json['etiq'] ?? '',
      zona: json['zona'] ?? 'Interior',
      tBase: json['t_base'] ?? '',
      microId: json['micro_id'] ?? '',
    );
  }

  // Lógica de Tópicos Dinámicos usando la configuración centralizada
  String get topicBase => "${AppConfig.root}/${zona.toLowerCase()}/$tBase/";

  // Tópico para que la App envíe comandos (ej: casa/interior/switch01/estado)
  String get topicSet => "$topicBase${AppConfig.triacSuffix}";

  // Tópico donde la App escucha confirmaciones (ej: casa/interior/switch01/state)
  String get topicStatus => "$topicBase${AppConfig.triacSuffix}";
}
