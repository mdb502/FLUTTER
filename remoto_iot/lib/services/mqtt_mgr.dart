// lib/services/mqtt_mgr.dart
import 'dart:io';
import 'package:flutter/material.dart'; // Para ChangeNotifier
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../providers/luces_provider.dart';

class MqttMgr extends ChangeNotifier {
  // Añadimos ChangeNotifier
  static final MqttMgr _instance = MqttMgr._internal();

  factory MqttMgr(LucesProvider provider) {
    _instance.provider = provider;
    return _instance;
  }

  MqttMgr._internal();

  Function(String topic, String message)? onMessageReceived;
  MqttServerClient? client;
  late LucesProvider provider;
  bool _estaConectando = false;

  Future<void> conectar() async {
    if (_estaConectando ||
        (client?.connectionStatus?.state == MqttConnectionState.connected))
      return;

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
      await client!.connect(user, pass);
      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        _suscribirTodo();
        client!.updates!.listen(_onMessage);
        notifyListeners(); // Notificar que estamos conectados
      }
    } catch (e) {
      client?.disconnect();
    } finally {
      _estaConectando = false;
    }
  }

  void _suscribirTodo() {
    if (client == null) return;

    // Suscripción automática a luces
    final todasLasLuces = provider.lucesInteriores + provider.lucesExteriores;
    for (var luz in todasLasLuces) {
      client!.subscribe(luz.topicStatus, MqttQos.atLeastOnce);
    }

    print('📡 Suscrito a luces. Multimedia se suscribirá dinámicamente.');
  }

  // MÉTODO CLAVE: Ahora es público y funciona para Multimedia
  void subscribe(String topic) {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      client?.subscribe(topic, MqttQos.atLeastOnce);
      print('Suscrito a: $topic');
    }
  }

  void publicarComando(String subTopic, String valor) {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(valor);
      client!.publishMessage(
        subTopic,
        MqttQos.atLeastOnce,
        builder.payload!,
        retain: false,
      ); // Retain false para IR
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
    final String payload = MqttPublishPayload.bytesToStringAsString(
      recMess.payload.message,
    );
    final String topic = c[0].topic;

    if (onMessageReceived != null) {
      onMessageReceived!(topic, payload);
    }
    provider.actualizarEstadoDesdeMQTT(topic, payload);
  }
}
