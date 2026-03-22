// lib/services/mqtt_mgr.dart
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../providers/luces_provider.dart';
import '../config/app_config.dart'; // <--- IMPORTANTE para los tópicos

class MqttMgr {
  // --- LÓGICA SINGLETON ---
  static final MqttMgr _instance = MqttMgr._internal();

  factory MqttMgr(LucesProvider provider) {
    _instance.provider = provider;
    return _instance;
  }

  MqttMgr._internal();
  // ------------------------

  // 1. EL "MENSAJERO" PARA LAS PANTALLAS
  Function(String topic, String message)? onMessageReceived;

  MqttServerClient? client;
  late LucesProvider provider;
  bool _estaConectando = false;

  Future<void> conectar() async {
    if (_estaConectando ||
        (client?.connectionStatus?.state == MqttConnectionState.connected)) {
      print(
        "⚠️ MQTT: Ya hay una conexión activa o en proceso. Abortando duplicado.",
      );
      return;
    }

    _estaConectando = true;

    final String host =
        dotenv.env['MQTT_HOST'] ??
        'ce8c66f8369340a68d67bd9634f441c4.s2.eu.hivemq.cloud';
    final String user = dotenv.env['MQTT_USER'] ?? '';
    final String pass = dotenv.env['MQTT_PASS'] ?? '';

    final String clientId =
        'MDB_${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}';

    client = MqttServerClient.withPort(host, clientId, 8883);
    client!.secure = true;
    client!.securityContext = SecurityContext.defaultContext;
    client!.setProtocolV311();
    client!.keepAlivePeriod = 20;
    client!.onBadCertificate = (dynamic cert) => true;

    try {
      print('🚀 Conectando a HiveMQ: $host');
      await client!.connect(user, pass);

      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        print('✅ OnConnected - ¡Conexión única exitosa!');
        _suscribirTodo();
        client!.updates!.listen(_onMessage);
      }
    } catch (e) {
      print('❌ Excepción en connect: $e');
      client?.disconnect();
    } finally {
      _estaConectando = false;
    }
  }

  void _suscribirTodo() {
    if (client == null) return;

    final todasLasLuces = provider.lucesInteriores + provider.lucesExteriores;
    for (var luz in todasLasLuces) {
      client!.subscribe(luz.topicStatus, MqttQos.atLeastOnce);
    }

    // 2. SUSCRIPCIÓN AL TÓPICO DE EVENTOS DEL ESP32
    // Usamos el tópico definido en AppConfig: "casa/cremoto/CREM_Escritorio/evento"
    client!.subscribe(AppConfig.remoteTopicEvent, MqttQos.atLeastOnce);

    print('📡 Suscrito a eventos de Multimedia y luces');
  }

  void publicarComando(String subTopic, String valor) {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(valor);

      print('📤 Publicando en $subTopic -> Mensaje: $valor');
      client!.publishMessage(
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

    // 3. NOTIFICAR A LA PANTALLA (Si hay alguien escuchando)
    if (onMessageReceived != null) {
      onMessageReceived!(topic, payload);
    }

    // Seguir notificando al provider de luces como siempre
    provider.actualizarEstadoDesdeMQTT(topic, payload);
  }
}
