// lib/config/app_config.dart
class AppConfig {
  // Luces
  static const String root = "casa";
  static const String triacSuffix = "estado";

  // Multimedia
  static const String topicBaseCremoto = "casa/cremoto";
  static const String actionLearn = "aprender";
  static const String statusLearnedOk = "aprendido_ok";

  // LISTA MAESTRA DE TIPOS
  static const List<String> tiposDispositivos = [
    "Receiver",
    "Amplifier",
    "Proyector",
    "TvBox",
  ];

  // LISTA DE CAPTURADORES (ESP32 FÍSICOS)
  static const List<String> capturadoresIR = [
    "CREM_Escritorio",
    "CREM_Living",
    "CREM_Pelicula",
  ];

  static String getCommandTopic(String espId) =>
      "$topicBaseCremoto/$espId/comando";
  static String getEventTopic(String espId) =>
      "$topicBaseCremoto/$espId/evento";
}
