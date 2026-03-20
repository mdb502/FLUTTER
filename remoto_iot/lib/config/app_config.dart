class AppConfig {
  // --- Prefijos de Ruta ---
  static const String root = "casa";
  static const String microsRoot = "casa/micros";

  // --- Sufijos de Control (Lo que el ESP entiende) ---
  // Cambiamos 'set' por 'estado' como mencionaste antes
  static const String triacSuffix = "estado";

  // --- Tópicos Globales de Sistema (Reflejando tus #define de C) ---
  static String topicInicio(String clientId) => "$microsRoot/$clientId/inicio";
  static String topicControl(String clientId) =>
      "$microsRoot/$clientId/control";
  static String topicEvento(String clientId) => "$microsRoot/$clientId/evento";

  // --- Formatos de Mensaje ---
  static const String msgOn = "1";
  static const String msgOff = "0";
}
