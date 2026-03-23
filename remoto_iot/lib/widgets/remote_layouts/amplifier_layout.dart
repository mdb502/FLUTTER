// lib/widgets/remote_layouts/amplifier_layout.dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'buttons/macro_button.dart';
import 'buttons/round_button.dart';
import 'buttons/neumorphic_dpad.dart';

class AmplifierLayout extends StatelessWidget {
  final bool isLearningMode;
  final String espId;
  final String equipoId;
  final List<String> inputs; // Lista dinámica de inputs
  final Function(String commandId, bool isMacro) onAction;

  const AmplifierLayout({
    super.key,
    required this.isLearningMode,
    required this.espId,
    required this.equipoId,
    required this.inputs,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    // Parseo de identificación
    final partes = equipoId.split('_');
    final tipo = partes.length > 0 ? partes[0] : "";
    final marcaModelo = partes.length > 1 ? partes.sublist(1).join(" ") : "";
    final ubicacion = espId.replaceFirst("CREM_", "");

    return Column(
      children: [
        // --- 1. IDENTIFICACIÓN ---
        Text(
          ubicacion.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        Text(
          tipo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textGrey,
          ),
        ),
        Text(
          marcaModelo,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textGrey,
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 25),

        // --- 2. MACRO COMANDOS (Solo en Operación) ---
        if (!isLearningMode) ...[
          Row(
            children: [
              Expanded(
                child: MacroButton(
                  label: "RADIO",
                  onTap: () => onAction("MACRO_RADIO", true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MacroButton(
                  label: "DVD",
                  onTap: () => onAction("MACRO_DVD", true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MacroButton(
                  label: "AUX",
                  onTap: () => onAction("MACRO_AUX", true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],

        // --- 3. BOTÓN POWER (Sobre el D-Pad) ---
        buildRoundButton(
          label: "PWR",
          icon: Icons.power_settings_new,
          isLearned: true,
          // CAMBIO: Enviamos "power" directamente, tal como está en Firebase
          onTap: () => onAction("power", false),
        ),

        const SizedBox(height: 20),

        // --- 4. D-PAD CENTRAL ---
        NeumorphicDPad(
          labelCenter: "MUTE",
          onAction: (direccion) {
            String cmd = "mute"; // Default
            if (direccion == "UP") cmd = "vol_up";
            if (direccion == "DOWN") cmd = "vol_down";
            if (direccion == "CENTER") cmd = "mute";

            onAction(cmd, false);
          },
        ),

        const SizedBox(height: 30),

        // --- 5. INPUTS DINÁMICOS (Bajo el D-Pad) ---
        const Text(
          "INPUT SELECTOR",
          style: TextStyle(fontSize: 9, color: Colors.grey, letterSpacing: 1),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: inputs.map((input) {
            String cleanLabel = input.replaceAll("input_", "").toUpperCase();
            return buildRoundButton(
              label: cleanLabel,
              isLearned: true,
              // CAMBIO: Enviamos el string 'input' original (ej: "input_aux")
              // No lo convertimos a Mayúsculas ni le agregamos prefijos
              onTap: () => onAction(input, false),
            );
          }).toList(),
        ),
      ],
    );
  }
}
