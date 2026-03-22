// lib/config/app_config.dart

/* Sincronización con ESP32 (C/ESP-IDF):
   #define MQTT_CLIENT_ID        "CREM_Escritorio"
   #define MQTT_TOPIC_COMANDO    "casa/cremoto/" MQTT_CLIENT_ID "/comando"
   #define MQTT_TOPIC_EVENTO     "casa/cremoto/" MQTT_CLIENT_ID "/evento"
   #define FIREBASE_PATH_REMOTOS "CRemotos"
*/

class AppConfig {
  // --- Estructura de Rutas Base ---
  static const String root = "casa";
  static const String microsRoot = "$root/cremoto";

  // --- Configuración Multimedia (Escritorio) ---
  static const String multimediaClientId = "CREM_Escritorio";

  // Tópicos específicos para el módulo Multimedia actual
  static const String remoteTopicBase = "$microsRoot/$multimediaClientId";
  static const String remoteTopicCommand = "$remoteTopicBase/comando";
  static const String remoteTopicEvent = "$remoteTopicBase/evento";

  // --- Protocolo de Acciones (JSON) ---
  static const String actionLearn = "aprender";
  static const String actionStatusLearned =
      "aprendido_ok"; //mensaje mqtt de comando aprendido

  // --- Control de Dispositivos (Luces/Triacs) ---
  static const String triacSuffix = "estado";
  static const String msgOn = "1";
  static const String msgOff = "0";

  // --- Generadores Dinámicos de Tópicos (Para múltiples clientes) ---
  static String topicInicio(String clientId) => "$microsRoot/$clientId/inicio";
  static String topicComando(String clientId) =>
      "$microsRoot/$clientId/comando";
  static String topicEvento(String clientId) => "$microsRoot/$clientId/evento";
}
