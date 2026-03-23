// lib/config/commands_map.dart

class RemoteCommands {
  // Identificadores de Layouts
  static const String layoutReceiver = "Receiver";
  static const String layoutTV = "TV";
  static const String layoutTVBox = "TVBox";

  // Esta función ayudará a la App a decidir qué dibujo mostrar
  static String getLayoutType(String deviceId) {
    if (deviceId.contains("Receiver") || deviceId.contains("Amplifier")) {
      return layoutReceiver;
    }
    if (deviceId.contains("TVBox")) return layoutTVBox;
    return layoutTV; // Default
  }
}
