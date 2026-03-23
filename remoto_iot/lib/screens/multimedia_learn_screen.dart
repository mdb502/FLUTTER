// lib/screens/multimedia_learn_screen.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import '../config/app_config.dart';
import '../config/layouts_config.dart';
import '../services/mqtt_mgr.dart';
import '../widgets/remote_layouts/neumorphic_learn_button.dart';
import '../widgets/common/neumorphic_container.dart';
import '../theme/app_theme.dart';

class MultimediaLearnScreen extends StatefulWidget {
  const MultimediaLearnScreen({super.key});

  @override
  State<MultimediaLearnScreen> createState() => _MultimediaLearnScreenState();
}

class _MultimediaLearnScreenState extends State<MultimediaLearnScreen> {
  // --- VARIABLES DE ESTADO ---
  String _tipoSeleccionado =
      AppConfig.tiposDispositivos.first; // "Receiver" por defecto
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();

  String? _espCapturador;

  Map<String, bool> _botonesAprendidos = {};
  String? _ultimoBotonPresionado;

  @override
  void initState() {
    super.initState();
    // Limpiar el callback de mensajes al entrar para evitar conflictos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MqttMgr>(context, listen: false).onMessageReceived = null;
    });
  }

  // --- LÓGICA DE FIREBASE ---
  Future<void> _checkExistingButtons() async {
    final marca = _marcaController.text.trim();
    final modelo = _modeloController.text.trim();

    if (marca.isEmpty || modelo.isEmpty) {
      setState(() => _botonesAprendidos.clear());
      return;
    }

    final String idEquipo = "${_tipoSeleccionado}_${marca}_${modelo}"
        .replaceAll(' ', '_');

    try {
      final ref = FirebaseDatabase.instance.ref("CRemotos/$idEquipo");
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final Map<dynamic, dynamic> data = snapshot.value as Map;
        Map<String, bool> tempMap = {};
        for (var key in data.keys) {
          tempMap[key.toString()] = true;
        }
        setState(() => _botonesAprendidos = tempMap);
      } else {
        setState(() => _botonesAprendidos.clear());
      }
    } catch (e) {
      debugPrint("Error Firebase: $e");
    }
  }

  // --- LÓGICA MQTT ---
  void _cambiarCapturador(String? nuevoId) {
    if (nuevoId == null) return;
    setState(() {
      _espCapturador = nuevoId;
      _botonesAprendidos.clear();
    });

    final mqtt = Provider.of<MqttMgr>(context, listen: false);
    mqtt.subscribe(AppConfig.getEventTopic(nuevoId));

    mqtt.onMessageReceived = (topic, message) {
      if (topic == AppConfig.getEventTopic(nuevoId)) {
        final data = jsonDecode(message);
        if (data['status'] == AppConfig.statusLearnedOk &&
            _ultimoBotonPresionado != null) {
          setState(() {
            _botonesAprendidos[_ultimoBotonPresionado!] = true;
          });
          _showSnackBar(
            "✅ Botón $_ultimoBotonPresionado guardado",
            Colors.green,
          );
        }
      }
    };
  }

  void _iniciarAprendizaje(String botonId) {
    if (_espCapturador == null) {
      _showError("Selecciona un ESP32 primero");
      return;
    }
    if (_marcaController.text.isEmpty || _modeloController.text.isEmpty) {
      _showError("Marca y Modelo son obligatorios");
      return;
    }

    setState(() {
      _botonesAprendidos[botonId] =
          false; // Limpia marca verde actual para esperar la nueva
      _ultimoBotonPresionado = botonId;
    });

    final idEquipo =
        "${_tipoSeleccionado}_${_marcaController.text.trim()}_${_modeloController.text.trim()}"
            .replaceAll(' ', '_');

    final payload = {
      "accion": AppConfig.actionLearn,
      "dispositivo": idEquipo,
      "boton": botonId,
    };

    Provider.of<MqttMgr>(context, listen: false).publicarComando(
      AppConfig.getCommandTopic(_espCapturador!),
      jsonEncode(payload),
    );
  }

  // --- HELPERS DE UI ---
  List<Map<String, String>> _getActualLayout() {
    switch (_tipoSeleccionado) {
      case 'Amplifier':
        return LayoutsConfig.amplifierStandard;
      case 'Receiver':
      default:
        return LayoutsConfig.receiverStandard;
    }
  }

  void _showError(String msg) => _showSnackBar(msg, Colors.redAccent);

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- CONSTRUCCIÓN DE LA PANTALLA ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Fábrica de Controles"),
        // El estilo del título ya viene del Theme global (AppTextStyles.appBarTitle)
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        child: Column(
          children: [
            _buildCapturadorSelector(),
            const SizedBox(height: 25),

            _buildInlineDropdown(),

            _buildInlineField(
              "Marca",
              _marcaController,
              onChanged: (_) => _checkExistingButtons(),
            ),
            _buildInlineField(
              "Modelo",
              _modeloController,
              onChanged: (_) => _checkExistingButtons(),
            ),

            const SizedBox(height: 35),
            const Divider(thickness: 1, color: Colors.black12),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Mapeo de Botones",
                style: TextStyle(
                  fontFamily: AppTextStyles.font, // Inyectamos Abel
                  fontSize: 16,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGrey,
                ),
              ),
            ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 25,
                crossAxisSpacing: 40,
                childAspectRatio: 1.2,
              ),
              itemCount: _getActualLayout().length,
              itemBuilder: (context, index) {
                final btn = _getActualLayout()[index];
                return NeumorphicLearnButton(
                  label: btn['label']!,
                  commandId: btn['id']!,
                  isLearned: _botonesAprendidos[btn['id']] ?? false,
                  onTap: () => _iniciarAprendizaje(btn['id']!),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              "Tipo",
              style: TextStyle(
                fontFamily: AppTextStyles.font, // Inyectamos Abel
                fontWeight: FontWeight.bold,
                color: AppColors.textGrey,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.textGrey.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _tipoSeleccionado,
                  isExpanded: true,
                  style: const TextStyle(
                    fontFamily:
                        AppTextStyles.font, // Texto del Dropdown en Abel
                    color: AppColors.textGrey,
                    fontSize: 16,
                  ),
                  items: AppConfig.tiposDispositivos
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _tipoSeleccionado = val!;
                      _botonesAprendidos.clear();
                    });
                    _checkExistingButtons();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineField(
    String label,
    TextEditingController controller, {
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppTextStyles.font, // Inyectamos Abel
                fontWeight: FontWeight.bold,
                color: AppColors.textGrey,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontFamily: AppTextStyles.font,
              ), // Texto que escribe el usuario
              decoration: InputDecoration(
                isDense: true,
                labelStyle: const TextStyle(fontFamily: AppTextStyles.font),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapturadorSelector() {
    return NeumorphicContainer(
      borderRadius: 12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _espCapturador,
            hint: Text(
              "Seleccionar Capturador (ESP32)",
              style: TextStyle(
                fontFamily: AppTextStyles.font,
                color: AppColors.textGrey.withOpacity(0.7),
              ),
            ),
            isExpanded: true,
            style: const TextStyle(
              fontFamily: AppTextStyles.font,
              color: AppColors.textGrey,
              fontSize: 16,
            ),
            // USAMOS LA LISTA DE APPCONFIG
            items: AppConfig.capturadoresIR.map((id) {
              return DropdownMenuItem(
                value: id,
                child: Text(
                  id,
                  style: const TextStyle(fontFamily: AppTextStyles.font),
                ),
              );
            }).toList(),
            onChanged: _cambiarCapturador,
          ),
        ),
      ),
    );
  }
}
