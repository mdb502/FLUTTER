import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <-- 1. FALTA ESTA IMPORTACIÓN
import '../providers/luces_provider.dart';

class MqttMgr {
  late MqttServerClient client;
  final LucesProvider provider;

  MqttMgr(this.provider);

  Future<void> conectar() async {
    // 2. Extraemos las credenciales del .env de forma segura
    final String host =
        dotenv.env['MQTT_HOST'] ??
        'ce8c66f8369340a68d67bd9634f441c4.s2.eu.hivemq.cloud';
    final String user = dotenv.env['MQTT_USER'] ?? '';
    final String pass = dotenv.env['MQTT_PASS'] ?? '';

    final String clientId =
        'MDB_${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}';

    client = MqttServerClient.withPort(host, clientId, 8883);

    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.setProtocolV311();
    client.keepAlivePeriod = 20;

    client.onBadCertificate = (dynamic cert) => true;

    try {
      print('🚀 Conectando al estilo HiveMQ GitHub...');

      // 3. Usamos las variables locales que ya validamos que no sean nulas
      await client.connect(user, pass);

      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        print('✅ OnConnected - ¡Conexión exitosa!');
        _suscribirTodo();
        client.updates!.listen(_onMessage);
      } else {
        print('❌ Fallo: Estado es ${client.connectionStatus!.state}');
        client.disconnect();
      }
    } catch (e) {
      print('❌ Excepción en connect: $e');
      client.disconnect();
    }
  }

  void _suscribirTodo() {
    // Sumamos ambas listas para suscribirnos a todo en un solo ciclo
    final todasLasLuces = provider.lucesInteriores + provider.lucesExteriores;
    print('Intentando suscribir a ${todasLasLuces.length} luces');

    for (var luz in todasLasLuces) {
      client.subscribe(luz.topicStatus, MqttQos.atLeastOnce);
      print('📡 Suscrito con QoS 1 a: ${luz.topicStatus}');
    }
  }

  void publicarComando(String subTopic, String valor) {
    // Verificamos conexión antes de publicar
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(valor);

      print('📤 Publicando en $subTopic -> Mensaje: $valor');
      client.publishMessage(
        subTopic,
        MqttQos.atLeastOnce,
        builder.payload!,
        retain: true,
      );
    } else {
      print('⚠️ No se puede publicar: Cliente desconectado');
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
    final String payload = MqttPublishPayload.bytesToStringAsString(
      recMess.payload.message,
    );
    final String topic = c[0].topic;

    print('📩 Mensaje recibido en $topic: $payload');

    // Enviamos la información al Provider para que actualice la interfaz
    provider.actualizarEstadoDesdeMQTT(topic, payload);
  }
}
