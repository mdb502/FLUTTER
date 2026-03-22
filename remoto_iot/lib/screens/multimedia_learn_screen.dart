// lib/screens/multimedia_learn_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../config/app_config.dart';
import '../services/mqtt_mgr.dart';
import '../widgets/common/neumorphic_container.dart';

class MultimediaLearnScreen extends StatefulWidget {
  const MultimediaLearnScreen({super.key});

  @override
  State<MultimediaLearnScreen> createState() => _MultimediaLearnScreenState();
}

class _MultimediaLearnScreenState extends State<MultimediaLearnScreen> {
  final _tipoController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _botonController = TextEditingController();
  final _botonFocusNode = FocusNode();

  bool _aprendido = false;

  @override
  void initState() {
    super.initState();

    // 1. Resetear el icono apenas el usuario empiece a escribir un nuevo botón
    _botonController.addListener(_onBotonTextChanged);

    // 2. Escuchar el evento del ESP32
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mqttProvider = Provider.of<MqttMgr>(context, listen: false);
      mqttProvider.onMessageReceived = _procesarMensajeMqtt;
    });
  }

  // Lógica separada para limpiar el icono al escribir
  void _onBotonTextChanged() {
    if (_botonController.text.isNotEmpty && _aprendido) {
      setState(() => _aprendido = false);
    }
  }

  // Procesador de mensajes MQTT
  void _procesarMensajeMqtt(String topic, String message) {
    if (topic == AppConfig.remoteTopicEvent) {
      try {
        final data = jsonDecode(message);
        if (data['status'] == "aprendido_ok") {
          _confirmarAprendizaje();
        }
      } catch (e) {
        print("❌ Error en JSON de evento: $e");
      }
    }
  }

  @override
  void dispose() {
    // Limpiamos los listeners para evitar fugas de memoria
    final mqttProvider = Provider.of<MqttMgr>(context, listen: false);
    mqttProvider.onMessageReceived = null;

    _botonController.removeListener(_onBotonTextChanged);
    _botonFocusNode.dispose();
    _tipoController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _botonController.dispose();
    super.dispose();
  }

  void _confirmarAprendizaje() {
    if (!mounted) return;

    setState(() => _aprendido = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ ¡Comando guardado con éxito!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Opcional: Limpiar el campo del botón automáticamente tras el éxito
    // para dejarlo listo para el siguiente comando del mismo equipo.
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) _botonController.clear();
    });
  }

  void _iniciarAprendizaje() {
    final tipo = _tipoController.text.trim();
    final marca = _marcaController.text.trim();
    final modelo = _modeloController.text.trim();
    final boton = _botonController.text.trim();

    if (tipo.isEmpty || marca.isEmpty || modelo.isEmpty || boton.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("⚠️ Completa los campos")));
      return;
    }

    final String idEquipo = "${tipo}_${marca}_${modelo}".replaceAll(' ', '_');

    final Map<String, dynamic> payload = {
      "accion": AppConfig.actionLearn,
      "dispositivo": idEquipo,
      "boton": boton.toLowerCase(),
    };

    try {
      setState(() => _aprendido = false);

      Provider.of<MqttMgr>(
        context,
        listen: false,
      ).publicarComando(AppConfig.remoteTopicCommand, jsonEncode(payload));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Esperando señal IR para $boton...")),
      );
    } catch (e) {
      print("❌ Error MQTT: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        title: const Text("Aprender Comando IR"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildInputGroup("Información del Equipo", [
              _buildField("Tipo", "Ej: Receiver", _tipoController),
              _buildField("Marca", "Ej: Kebidu", _marcaController),
              _buildField("Modelo", "Ej: 747D", _modeloController),
            ]),
            const SizedBox(height: 30),
            _buildInputGroup("Configurar Botón", [
              _buildField(
                "Botón",
                "Ej: power",
                _botonController,
                focusNode: _botonFocusNode,
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _iniciarAprendizaje,
                    icon: const Icon(Icons.sensors),
                    label: const Text("Iniciar Aprendizaje"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // Indicador visual de éxito
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      _aprendido
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _aprendido ? Colors.green : Colors.grey,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInputGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 15),
        ...children,
      ],
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller, {
    FocusNode? focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: NeumorphicContainer(
              borderRadius: 10,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
